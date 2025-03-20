import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ristey/models/new_user_modal.dart';
import 'package:ristey/screens/navigation/use.dart';
import 'package:ristey/screens/profile/profile_scroll.dart';
import 'package:ristey/services/chat_services.dart';

class NotificationServiceLocal {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    // _configureLocalTimeZone();
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          print(payload);
        });

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: (details) {
      print(details.payload);
    }, onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      if (notificationResponse.payload == "") {
      } else if (notificationResponse.payload == "4") {
        Get.to(Use());
      } else {
        NewUserModel newUserModel =
            await ChatService().getuserdatabyid(notificationResponse.payload!);

        Get.to(MainAppContainer(
          notiPage: true,
          user_data: [newUserModel],
        ));
      }
    });
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
        icon: '@mipmap/ic_launcher',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin
        .show(id, title, body, await notificationDetails(), payload: payLoad);
  }

  
}
