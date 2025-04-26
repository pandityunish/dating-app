import 'package:get/get.dart';
import 'package:ristey/screens/profile/service/notification_service.dart';

class NotificationController extends GetxController {
  // Reactive variable for unread count
  final RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch initial unread count when the controller is initialized
    fetchUnreadCount();
  }

  // Method to fetch unread count from NotificationService
  Future<void> fetchUnreadCount() async {
    try {
      final count = await NotificationService().getnumberofnoti();
      unreadCount.value = count; // Update reactive variable
    } catch (e) {
      // Handle errors (e.g., log or show a snackbar)
      print('Error fetching unread count: $e');
    }
  }
}