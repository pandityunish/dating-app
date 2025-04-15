import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ristey/common/api_routes.dart';
import 'package:ristey/screens/audio_clip/audio_clip_accept.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart' as getx;
class AudioSharingController extends GetxController {
  getx.RxString myId = ''.obs;
  getx.RxString audioFilePath = ''.obs;
  getx.RxBool isUploading = false.obs;
  getx.RxList<String> onlineUsers = <String>[].obs;
  getx.RxString? selectedUserId = ''.obs;
  String? pendingAudioUrl;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late IO.Socket socket;

  @override
  void onInit() {
    super.onInit();
    connectToSignalingServer();
  }

  Future<void> connectToSignalingServer() async {
    socket = IO.io('$baseurl/audioClip', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) {
      print('Connected to audio sharing server');
    });

    socket.on('registrationSuccess', (data) {
      myId.value = data;
      print('Registered as $data');
      update();
    });

    socket.on('registrationError', (message) {
      Get.snackbar('Error', message);
    });

    socket.on('userList', (data) {
      onlineUsers.value = List<String>.from(data);
      onlineUsers.remove(myId.value); // Remove self from list
      update();
    });

    socket.on('audioRequest', (data) {
      pendingAudioUrl = data['audioUrl'];
      Get.to(IncomingAudioClipScreen(audioUrl: data['audioUrl']));
      // _showAudioRequestDialog(data['senderId']);
    });

    socket.on('audioAccepted', (data) {
      Get.snackbar('Success', 'User ${data['recipientId']} accepted your audio');
    });

    socket.on('audioRejected', (data) {
      Get.snackbar('Rejected', 'User ${data['recipientId']} rejected your audio');
    });

    socket.on('error', (data) {
      Get.snackbar('Error', data['message']);
    });

    socket.onDisconnect((_) {
      print('Audio sharing socket disconnected');
    });
  }

  void registerUser(String userId) {
    if (userId.isNotEmpty) {
      socket.emit('register', userId);
    }
  }

  

  void sendAudio() {
    if (audioFilePath.value.isNotEmpty && selectedUserId != null && selectedUserId!.value.isNotEmpty) {
      socket.emit('sendAudio', {
        'audioUrl': audioFilePath.value,
        'recipientId': selectedUserId!.value,
      });
      audioFilePath.value = ''; // Clear after sending
    }
  }

  void _showAudioRequestDialog(String senderId) {
    Get.dialog(
      AlertDialog(
        title: Text('Audio Request'),
        content: Text('User $senderId sent you an audio clip'),
        actions: [
          TextButton(
            onPressed: () {
              socket.emit('acceptAudio', {'senderId': senderId});
              _audioPlayer.play(UrlSource(pendingAudioUrl!));
              pendingAudioUrl = null;
              Get.back();
            },
            child: Text('Accept'),
          ),
          TextButton(
            onPressed: () {
              socket.emit('rejectAudio', {'senderId': senderId});
              pendingAudioUrl = null;
              Get.back();
            },
            child: Text('Reject'),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    socket.disconnect();
    super.onClose();
  }
}