import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart' as getx;
import 'package:ristey/global_vars.dart';
import 'package:ristey/screens/search_profile/video_call.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:developer' as developer;


class NewCallController extends getx.GetxController {
  final _localRenderer = webrtc.RTCVideoRenderer();
  final _remoteRenderer = webrtc.RTCVideoRenderer();
  webrtc.RTCPeerConnection? peerConnection;
  webrtc.MediaStream? localStream;
  late IO.Socket socket;
  getx.RxString myId = ''.obs;
  getx.RxString? remoteId = getx.RxString("");
  getx.RxBool inCall = false.obs;
  getx.RxBool micEnabled = true.obs;
  getx.RxBool videoEnabled = true.obs;
  String? _currentFacingMode = 'user';
  getx.RxBool speakerEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    myId.value = userSave.uid!;
    connectToSignalingServer();
    setupFirebaseMessaging();
  }

  

  Future<void> initRenderers() async {
 await _localRenderer.initialize();
   await _remoteRenderer.initialize();
  }

  Future<void> connectToSignalingServer() async {
    socket = IO.io('https://newserver-production-b062.up.railway.app/videocall', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) {
      print('Connected to videocall namespace');
      socket.emit('register', myId.value);
    });

    socket.on('newCall', (data) async {
      print('Incoming call from ${data['callerId']}');
      if (!inCall.value) {
        remoteId!.value = data['callerId'];
        // getx.Get.toNamed('/incoming-call', arguments: data);
        handleIncomingCall(data);
      }
    });
socket.on('callRequest', (data) async {
      developer.log('Received call request from ${data['callerId']}');
      if (!inCall.value) {
        remoteId!.value = data['callerId'];
        getx.Get.toNamed('/incoming-call', arguments: data);
      }
    });
    socket.on('callAnswered', (data) async {
      print('Call answered');
      await handleCallAnswered(data);
    });

    socket.on('iceCandidate', (data) async {
      print('Received ICE candidate: ${data['iceCandidate']['candidate']}');
      await handleIceCandidate(data);
    });

    socket.on('error', (data) {
      print('Socket error: ${data['message']}');
      getx.Get.snackbar('Error', data['message']);
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
      endCall();
    });
  }
Future<void> toggleSpeaker() async {
    if (localStream != null) {
      speakerEnabled.value = !speakerEnabled.value;
      try {
        await webrtc.Helper.setSpeakerphoneOn(speakerEnabled.value);
        print('Speaker ${speakerEnabled.value ? 'enabled' : 'disabled'}');
      } catch (e) {
        print('Error toggling speaker: $e');
        getx.Get.snackbar('Error', 'Failed to toggle speaker');
        speakerEnabled.value = !speakerEnabled.value; // Revert on error
      }
      update();
    }
  }
  Future<void> initWebRTC() async {
    if (peerConnection != null) {
      print('WebRTC already initialized');
      return;
    }

    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
        // Add TURN server for better connectivity
        // {'urls': 'turn:your-turn-server.com:3478', 'username': 'user', 'credential': 'pass'},
      ],
      'sdpSemantics': 'unified-plan',
    };

    peerConnection = await webrtc.createPeerConnection(config);
    localStream = await webrtc.navigator.mediaDevices.getUserMedia({'audio': true, 'video': true});
    print('Local stream acquired: ${localStream?.id}');
    _localRenderer.srcObject = localStream;
    print('Local renderer srcObject set');

    localStream!.getTracks().forEach((track) {
      peerConnection!.addTrack(track, localStream!);
      print('Added track: ${track.kind}');
    });

    peerConnection!.onIceCandidate = (candidate) {
      if (candidate != null && remoteId?.value != null) {
        print('Sending ICE candidate: ${candidate.candidate}');
        socket.emit('iceCandidate', {
          'targetId': remoteId!.value,
          'iceCandidate': candidate.toMap(),
        });
      }
    };

    peerConnection!.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        print('Received remote stream: ${event.streams[0].id}');
        _remoteRenderer.srcObject = event.streams[0];
        inCall.value = true;
        update(); // Notify GetX to rebuild UI
      } else {
        print('No streams received in onTrack');
      }
    };

    peerConnection!.onConnectionState = (state) {
      print('Connection state: $state');
      if (state == webrtc.RTCPeerConnectionState.RTCPeerConnectionStateDisconnected ||
          state == webrtc.RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
        endCall();
      }
    };

    update();
  }
Future<void> requestCall(String targetId,String profilePic,String profilename,String uid) async {
    developer.log('Requesting call to $targetId');
    remoteId?.value = targetId;
    socket.emit('callRequest', {
      'callerId': myId.value,
      'calleeId': targetId,
     'profilePic':profilePic,
     'profilename':profilename,
     'uid':uid
    });
  }
 Future<void> startCall(String targetId, String profilePic, String profilename, String uid) async {
  print('Starting call to $targetId');
  remoteId?.value = targetId;
  inCall.value = true;
 if (peerConnection == null) {
    print("peer connection is null, attempting to re-initialize");
    await initWebRTC(); // Re-initialize WebRTC
    if(peerConnection == null){
      print("peer connection is still null after re-initialization");
      inCall.value = false;
      return;
    }
    print("peer connection re-initialized");
  }
  try {
    final offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    print('Sending offer: ${offer.sdp}');
    socket.emit('makeCall', {
      'calleeId': targetId,
      'sdpOffer': offer.toMap(),
    });
    update();

    getx.Get.to(VideoCall(
      profilepic: profilePic,
      profileId: targetId,
      profileName: profilename,
      uid: uid,
    ));
  } catch (e) {
    log("error on start call : $e");
    inCall.value = false;
  }
}

  Future<void> acceptCall(String callerId, dynamic sdpOffer, Map<String, dynamic> data) async {
    print('Accepting call from $callerId');
    await handleIncomingCall(data);
    getx.Get.back(); // Close incoming call screen
    getx.Get.toNamed('/call'); // Navigate to CallScreen
  }

  Future<void> handleIncomingCall(Map<String, dynamic> data) async {
    developer.log('Handling incoming call from ${data['callerId']}');
    remoteId?.value = data['callerId'];
    inCall.value = true;
    if (peerConnection == null) {
      await initWebRTC();
      developer.log('WebRTC initialized for incoming call');
    }
    developer.log('Setting remote description: ${data['sdpOffer']['sdp']}');
    await peerConnection!.setRemoteDescription(
      webrtc.RTCSessionDescription(data['sdpOffer']['sdp'], data['sdpOffer']['type']),
    );
    developer.log('Creating answer');
    final answer = await peerConnection!.createAnswer();
    await peerConnection!.setLocalDescription(answer);
    developer.log('Sending answer: ${answer.sdp}');
    socket.emit('answerCall', {
      'callerId': data['callerId'],
      'sdpAnswer': answer.toMap(),
    });
    update(); // Ensure UI reflects the call state
  }

  Future<void> handleCallAnswered(Map<String, dynamic> data) async {
    print('Handling call answered with SDP: ${data['sdpAnswer']['sdp']}');
    await peerConnection!.setRemoteDescription(
      webrtc.RTCSessionDescription(data['sdpAnswer']['sdp'], data['sdpAnswer']['type']),
    );
  }

  Future<void> handleIceCandidate(Map<String, dynamic> data) async {
    final candidate = webrtc.RTCIceCandidate(
      data['iceCandidate']['candidate'],
      data['iceCandidate']['sdpMid'],
      data['iceCandidate']['sdpMLineIndex'],
    );
    await peerConnection!.addCandidate(candidate);
    print('Added ICE candidate');
  }

  void endCall() {
    print('Ending call');
    inCall.value = false;
    remoteId?.value = "";
    _remoteRenderer.srcObject = null;
    _localRenderer.srcObject = null;
    localStream?.getTracks().forEach((track) => track.stop());
    localStream?.dispose();
    localStream = null;
    peerConnection?.close();
    peerConnection = null;
    speakerEnabled.value = false; // Reset speaker mode
    webrtc.Helper.setSpeakerphoneOn(false); // Ensure earpiece is default on end
    getx.Get.back();
    update();
  }
Future<void> flipCamera() async {
    if (localStream == null) {
      developer.log('No local stream to flip');
      return;
    }

    // Determine the new facing mode
    _currentFacingMode = _currentFacingMode == 'user' ? 'environment' : 'user';
    developer.log('Flipping camera to: $_currentFacingMode');

    // Stop existing video track
    final videoTrack = localStream!.getVideoTracks().first;
    videoTrack.stop();
    localStream!.removeTrack(videoTrack);

    // Get new video stream with the flipped camera
    final newStream = await webrtc.navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {'facingMode': _currentFacingMode},
    });
    final newVideoTrack = newStream.getVideoTracks().first;

    // Add new video track to the stream and peer connection
    localStream!.addTrack(newVideoTrack);
    if (peerConnection != null) {
      final senders = await peerConnection!.getSenders();
      final videoSender = senders.firstWhere((sender) => sender.track?.kind == 'video');
      await videoSender.replaceTrack(newVideoTrack);
      developer.log('Replaced video track in peer connection');
    }

    // Update renderer
    _localRenderer.srcObject = localStream;
    developer.log('Local renderer updated with new stream');
    update();
  }
  void toggleMic() {
    if (localStream != null) {
      final audioTrack = localStream!.getAudioTracks().first;
      micEnabled.value = !micEnabled.value;
      audioTrack.enabled = micEnabled.value;
      print('Mic ${micEnabled.value ? 'enabled' : 'disabled'}');
    }
  }

  void toggleVideo() {
    if (localStream != null) {
      final videoTrack = localStream!.getVideoTracks().first;
      videoEnabled.value = !videoEnabled.value;
      videoTrack.enabled = videoEnabled.value;
      _localRenderer.srcObject = videoEnabled.value ? localStream : null;
      print('Video ${videoEnabled.value ? 'enabled' : 'disabled'}');
    }
  }

  webrtc.RTCVideoRenderer get localRenderer => _localRenderer;
  webrtc.RTCVideoRenderer get remoteRenderer => _remoteRenderer;

  @override
  void onClose() {
    print('CallController onClose');
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    endCall();
    socket.disconnect();
    
    super.onClose();
  }
}

// Firebase Messaging Setup
void setupFirebaseMessaging() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print('FCM Token: $token'); // Send this to your server

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final callController = getx.Get.find<NewCallController>();
    if (message.data.containsKey('callerId') && !callController.inCall.value) {
      callController.handleIncomingCall({
        'callerId': message.data['callerId'],
        'sdpOffer': jsonDecode(message.data['sdpOffer']),
      }).then((_) {
        getx.Get.toNamed('/call');
      });
      showLocalNotification(message);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    final callController = getx.Get.find<NewCallController>();
    if (message.data.containsKey('callerId') && !callController.inCall.value) {
      callController.handleIncomingCall({
        'callerId': message.data['callerId'],
        'sdpOffer': jsonDecode(message.data['sdpOffer']),
      }).then((_) {
        getx.Get.toNamed('/call');
      });
    }
  });
}

Future<void> showLocalNotification(RemoteMessage message) async {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'call_channel',
    'Calls',
    importance: Importance.max,
    priority: Priority.high,
    fullScreenIntent: true,
  );
  const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);
  await notificationsPlugin.show(
    0,
    message.notification?.title ?? 'Incoming Call',
    message.notification?.body ?? 'You have a new call',
    notificationDetails,
  );
}