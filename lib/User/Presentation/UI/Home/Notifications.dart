

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:amity_university/api_service_baseurl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, String>> notifications = [];
  bool isLoading = true;
  bool hasError = false;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
    fetchNotifications();
  }

  Future<void> _setupFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Get FCM token
    String? token = await messaging.getToken();
    debugPrint("📱 FCM Token: $token");

    // Request notification permission (iOS)
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // Initialize local notifications
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);
    await flutterLocalNotificationsPlugin.initialize(initSettings);

    // Foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📩 New FCM notification: ${message.notification?.title}");
      _showLocalNotification(message);
      setState(() {
        notifications.insert(0, {
          "title": message.notification?.title ?? "No Title",
          "message": message.notification?.body ?? "No Message",
          "time": formatDateTime(DateTime.now().toIso8601String()),
        });
      });
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      platformDetails,
      payload: 'Default',
    );
  }

  Future<void> fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}api/admin/notification/'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final filteredData = data.where((item) => item['userType'] == 'User').toList();

        setState(() {
          notifications = filteredData.map<Map<String, String>>((item) {
            return {
              "title": item['title'] ?? "No Title",
              "message": item['message'] ?? "No Message",
              "time": formatDateTime(item['created_at']),
            };
          }).toList();
          isLoading = false;
          hasError = false;
        });
      } else {
        throw Exception("Failed with status: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint('❌ Error fetching notifications: $e');
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  String formatDateTime(dynamic dateTime) {
    if (dateTime == null) return "Time N/A";
    try {
      DateTime dt = DateTime.parse(dateTime).toLocal();
      String hour = (dt.hour % 12 == 0 ? 12 : dt.hour % 12).toString();
      String minute = dt.minute.toString().padLeft(2, '0');
      String period = dt.hour >= 12 ? 'PM' : 'AM';
      return "$hour:$minute $period";
    } catch (_) {
      return "Time N/A";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(color: Colors.white)),
        backgroundColor: ColorPicker.blueColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(
                  child: Text(
                    "Failed to load notifications. Please try again.",
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              : notifications.isEmpty
                  ? const Center(
                      child: Text(
                        "No Notifications",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: notifications.length,
                      padding: const EdgeInsets.all(10),
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return ListTile(
                          leading: const Icon(Icons.notifications, color: ColorPicker.blueColor),
                          title: Text(
                            notification["title"]!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(notification["message"]!),
                          trailing: Text(
                            notification["time"]!,
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        );
                      },
                    ),
    );
  }
}
