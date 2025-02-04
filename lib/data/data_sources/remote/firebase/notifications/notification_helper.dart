import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationHelper {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Initializes Firebase notifications and local notifications for both platforms
  Future<void> initialize() async {
    await _initializeFirebaseApp();
    await _initializeNotificationSettings();
    await _initializeLocalNotifications();
    _setupMessageListeners();
  }

  /// Initializes Firebase App and sets up background message handler
  Future<void> _initializeFirebaseApp() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Initializes local notifications for both Android and iOS
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@drawable/app_icon');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap event
        print('Notification tapped: ${response.payload}');
      },
    );
  }

  /// Saves the FCM token to Firestore for the current user
  static Future<void> _saveFcmToken(String? token) async {
    if (token == null) return;

    // Replace this with your logic to get the current user's ID
    final String? userId = "CURRENT_USER_ID"; // Replace with actual user ID
    if (userId != null) {
      try {
        // Save the token to Firestore (update with your Firestore structure)
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'fcmToken': token,
        });
      } catch (e) {
        print('Failed to save FCM token: $e');
      }
    }
  }

  /// Requests notification permissions and saves the initial FCM token
  Future<void> _initializeNotificationSettings() async {
    final token = await _firebaseMessaging.getToken();
    await _saveFcmToken(token);

    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      await _saveFcmToken(newToken);
    });

    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Request permissions for iOS if necessary
    await _localNotificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Background message handler
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await _showNotification(message);
  }

  /// Sets up foreground and opened message listeners
  void _setupMessageListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Foreground message received: ${message.notification?.title}');
      await _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened from terminated state: ${message.data}');
      // Handle navigation or other actions here
    });
  }

  /// Displays a notification for both Android and iOS
  static Future<void> _showNotification(RemoteMessage message) async {
    final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'This is the default channel for notifications',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@drawable/app_icon',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await localNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: message.data.toString(),
    );
  }
}