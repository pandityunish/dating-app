import 'dart:math';
import 'dart:developer' as dev;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:get/get.dart';
import 'package:ristey/global_vars.dart';
import 'package:ristey/models/ads_modal.dart';
import 'package:ristey/models/new_user_modal.dart';
import 'package:ristey/screens/mobile_chat_screen.dart';
import 'package:ristey/screens/notification.dart';
import 'package:ristey/screens/profile/profile_scroll.dart';
import 'package:ristey/services/chat_services.dart';

import '../global_vars.dart' as glb;
import 'dart:io' show Platform;
// import 'package:audioplayers/audioplayers.dart' as audio;

import '../screens/notification/Widget_Notification/ads_bar.dart';

FlutterLocalNotificationsPlugin flutterNotificationPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationData with WidgetsBindingObserver {
  // audio.AudioPlayer player = audio.AudioPlayer();

  AndroidNotificationChannel main_channel = const AndroidNotificationChannel(
      // message.notification!.android!.channelId.toString(),
      // message.notification!.android!.channelId.toString(),
      'high_importance_channel',
      'The Errors',
      importance: Importance.max,
      showBadge: true,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      sound: RawResourceAndroidNotificationSound('navnot'));
  AndroidNotificationChannel chat_channel = const AndroidNotificationChannel(
      'high_importance_channel_2', 'Chat',
      importance: Importance.defaultImportance,
      enableVibration: true,
      showBadge: true,
      playSound: true,
      enableLights: true,
      sound: RawResourceAndroidNotificationSound('chatnot'));
  static bool isChatting = false;
  static var uid = "";
  var notiDataUid = "";

  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(
      RemoteMessage message, BuildContext context) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      print("***********************");
      print(message);
      print(payload);
      print("*******************");
      handleMessage(message, context);
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) async {
      notiDataUid = message.data['uid'].toString();
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;
      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print('count:${android!.count}');

        print('data:${message.data.toString()}');
      }

      if (Platform.isIOS) {
        forgroundMessage();
      }
      if (Platform.isAndroid) {
        initLocalNotifications(message, context);
        showNotification(message);
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()!
            .createNotificationChannel(main_channel);
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()!
            .createNotificationChannel(chat_channel);
        // await player.setSource(AssetSource('sound/notification.wav'));
        // await player.resume();
      }
    });
  }

  bool _isRequestingPermission = false;

  void requestNotificationPermission() async {
    if (_isRequestingPermission) {
      // Prevent multiple simultaneous requests
      return;
    }

    _isRequestingPermission =
        true; // Set the flag to indicate a request is in progress

    try {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        if (kDebugMode) {
          print('User granted permission');
        }
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        if (kDebugMode) {
          print('User granted provisional permission');
        }
      } else {
        // Show a dialog if the user denies permissions
        print("User denied permission");
        Get.dialog(
          WillPopScope(
            onWillPop: () async => false,
            child: CupertinoAlertDialog(
              title: Icon(
                Icons.error,
                color: mainColor,
              ),
              content:
                  const Text('Please Allow Notification\nTo Proceed Further'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    // Request permissions again
                    PermissionStatus? statusNotification =
                        await Permission.notification.request();
                    NotificationSettings settings =
                        await messaging.requestPermission(
                      alert: true,
                      announcement: true,
                      badge: true,
                      carPlay: true,
                      criticalAlert: true,
                      provisional: true,
                      sound: true,
                    );
                    if (settings.authorizationStatus ==
                        AuthorizationStatus.authorized) {
                      if (kDebugMode) {
                        Get.back();
                      }
                    }
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: mainColor),
                  ),
                )
              ],
            ),
          ),
          barrierDismissible: false,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting permission: $e');
      }
    } finally {
      _isRequestingPermission =
          false; // Reset the flag after the request is complete
    }
  }

  String getNotificationSoundPath(String notificationType) {
    // switch (notificationType) {
    //   case 'profilepage':
    //     print("navnot");
    //     return 'navnot';
    //   case 'chat':
    //     print("chatnot");
    //     return 'chatnot';
    //   default:
    //     return 'null';
    // }
    if (notificationType == 'profilepage') {
      print('navnot');
      return 'navnot';
    } else if (notificationType == 'chat') {
      print('chatnot');
      return 'chatnot';
    } else {
      return 'null';
    }
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    if (kDebugMode) {
      print("isChatting: $isChatting");
      print("UID: $uid");
    }
    print("Channel Sound : ${message.data['sound']}");
    // HomeService().getuserdata();
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            // channel.id.toString(), channel.name.toString(),
            // channelDescription: 'your channel description',
            main_channel.id,
            main_channel.name,
            channelDescription: 'This is the main high descriptive channel',
            importance: main_channel.importance,
            priority: Priority.high,
            icon: "@mipmap/ic_launcher",
            playSound: main_channel.playSound,
            ticker: 'ticker',
            // largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),

            // sound: channel.sound
            // sound: RawResourceAndroidNotificationSound(
            //     getNotificationSoundPath(message.data['route']))
            sound: const RawResourceAndroidNotificationSound('navnot')
            //  icon: largeIconPath
            );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    print(identifyTextType(message.notification!.body!.replaceAll("'", "")) ==
        "Audio URL");
    print(message.notification!.body!.toString());
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        identifyTextType(message.notification!.body!.replaceAll("'", "")) ==
                "Video URL"
            ? "Video"
            : identifyTextType(
                        message.notification!.body!.replaceAll("'", "")) ==
                    "Audio URL"
                ? "Audio"
                : identifyTextType(
                            message.notification!.body!.replaceAll("'", "")) ==
                        "Image URL"
                    ? "Image"
                    : message.notification!.body!,
        notificationDetails,
      );
    });
  }

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
   dev.log("token ${token}");
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    print("Called Background Message");

    // When the app is terminated, check for the initial notification
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // Check if the message exists before proceeding
    if (initialMessage != null) {
      showNotification(initialMessage); // Display the notification
      handleMessage(initialMessage, context); // Handle the message
    }

    // When the app is in the background and the notification is clicked
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(event, context);
    });
  }

  void handleMessage(RemoteMessage message, BuildContext context) async {
    var contextmain = NavigationService.navigatorKey.currentContext;
    print("context: $contextmain");
    print("UID Value ${message.data['uid']}");
    print("UID Value ${message.data['route']}");

    // var profile = await FirebaseFirestore.instance
    //     .collection("user_data")
    //     .where('uid', isEqualTo: message.data["uid"])
    //     .get();

    if (message.data["route"] == "profilepage") {
      List<AdsModel> adslist = message.data["title"].contains("UNBLOCKED")
          ? navunblockads
          : message.data["title"].contains("BLOCKED")
              ? navblockads
              : message.data["title"].contains("INTEREST SENT")
                  ? interestads
                  : message.data["title"].contains("CANCEL")
                      ? cancelinterestads
                      : message.data["title"].contains("RECEIVE")
                          ? receiveinterestads
                          : message.data["title"].contains("ACCEPT")
                              ? acceptinterestads
                              : message.data["title"].contains("DECLINE")
                                  ? declineads
                                  : message.data["title"].contains("UNREPORTED")
                                      ? navunreportads
                                      : message.data["title"]
                                              .contains("REPORTED")
                                          ? navreportads
                                          : message.data["title"]
                                                  .contains("UNSHORTLISTED")
                                              ? navunsortlistads
                                              : message.data["title"]
                                                      .contains("SHORTLISTED")
                                                  ? navsortlistads
                                                  : [];
      print(message.data["uid"]);
      NewUserModel newUserModel =
          await ChatService().getuserdatabyid(message.data["uid"]);

      Get.to(MainAppContainer(
        notiPage: true,
        user_data: [newUserModel],
      ));
      // HomeService().getuserdata();
      if (adslist.isNotEmpty) {
        showadsbar(context, adslist, () {
          Navigator.pop(context);
        });
      }
    } else if (message.data["route"] == "Chat") {
      NewUserModel newUserModel;
      newUserModel = await ChatService().getuserdata(message.data["uid"]);
      Get.to(MobileChatScreen(
        profileDetail: newUserModel,
        profilepic: newUserModel.imageurls.isNotEmpty
            ? newUserModel.imageurls[0]
            : "https://firebasestorage.googleapis.com/v0/b/couplematch-47708.appspot.com/o/impImage%2Fnoimage.jpg?alt=media&token=4c0d4bc9-761e-48af-b947-4a05a0eaa6d2",
        roomid: "some",
      ));
    }
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
