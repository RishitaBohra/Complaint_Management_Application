// import 'dart:io';

// import 'package:amity_university/ServiceProvider/Presentation/UI/Auth/Preloginscreen.dart';
// import 'package:amity_university/ServiceProvider/Presentation/UI/Auth/serviceproviderlogin.dart';
// import 'package:amity_university/ServiceProvider/Presentation/UI/Home/EndProcess/AfterPhoto.dart';
// import 'package:amity_university/ServiceProvider/Presentation/UI/Home/Serviceproviderhome.dart';

// import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
// import 'package:amity_university/User/Presentation/UI/Auth%20File/LoginScreen.dart';
// import 'package:amity_university/User/Presentation/UI/Home/Home.dart';
// import 'package:amity_university/User/Presentation/UI/SplashScreen.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:amity_university/Ztext.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:camera/camera.dart';

// // 🟢 Firebase Packages (commented out)
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// // 🔵 Background Handler (commented out)
// // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// //   await Firebase.initializeApp();
// //   print("🔵 Background message: ${message.messageId}");
// // }
// List<CameraDescription> cameras = [];

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   cameras = await availableCameras();

//   // 🟢 Firebase initialization (commented out)
//   // await Firebase.initializeApp();

//   // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   runApp(
//     ProviderScope(
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//   @override
//   void initState() {
//     super.initState();
//     // _setupFirebaseMessaging();
//   }

//   // void _setupFirebaseMessaging() async {
//   //   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   //   // Request permission (iOS only)
//   //   await messaging.requestPermission(alert: true, badge: true, sound: true);

//   //   // Get FCM token
//   //   String? token = await messaging.getToken();
//   //   print("📱 FCM Token: $token");

//   //   // Initialize local notifications
//   //   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   //   const AndroidInitializationSettings androidSettings =
//   //       AndroidInitializationSettings('@mipmap/ic_launcher');
//   //   const InitializationSettings initSettings =
//   //       InitializationSettings(android: androidSettings);

//   //   await flutterLocalNotificationsPlugin.initialize(initSettings);

//   //   // Listen for foreground messages
//   //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   //     print("📩 Foreground message: ${message.notification?.title}");
//   //     _showNotification(message);
//   //   });

//   //   // Handle when app opened from terminated
//   //   FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
//   //     if (message != null) {
//   //       print("📦 Opened from terminated: ${message.notification?.title}");
//   //     }
//   //   });

//   //   // Handle when app opened from background
//   //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//   //     print("📦 Opened from background: ${message.notification?.title}");
//   //   });
//   // }

//   // Future<void> _showNotification(RemoteMessage message) async {
//   //   const AndroidNotificationDetails androidDetails =
//   //       AndroidNotificationDetails(
//   //     'high_importance_channel',
//   //     'High Importance Notifications',
//   //     importance: Importance.max,
//   //     priority: Priority.high,
//   //   );

//   //   const NotificationDetails platformDetails =
//   //       NotificationDetails(android: androidDetails);

//   //   await flutterLocalNotificationsPlugin.show(
//   //     0,
//   //     message.notification?.title ?? '',
//   //     message.notification?.body ?? '',
//   //     platformDetails,
//   //     payload: 'Default',
//   //   );
//   // }

//   Future<bool> checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? loggedInMobile = prefs.getString('loggedInMobile');
//     return loggedInMobile != null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Complaint App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: ColorPicker.blueColor),
//       ),
//       // home: FutureBuilder<bool>(
//       //   future: checkLoginStatus(),
//       //   builder: (context, snapshot) {
//       //     if (snapshot.connectionState == ConnectionState.waiting) {
//       //       return const Scaffold(
//       //         body: Center(child: CircularProgressIndicator()),
//       //       );
//       //     } else {
//       //       if (snapshot.data == true) {
//       //         return const HomeScreen(); // if logged in
//       //       } else {
//       //         return const SplashScreen(); // if not logged in
//       //       }
//       //     }
//       //   },
//       // ),
//       home:HomeScreen()
//     );
//   }
// }



import 'dart:io';

import 'package:amity_university/ServiceProvider/Presentation/UI/Auth/Preloginscreen.dart';
import 'package:amity_university/ServiceProvider/Presentation/UI/Auth/serviceproviderlogin.dart';
import 'package:amity_university/ServiceProvider/Presentation/UI/Home/EndProcess/AfterPhoto.dart';
import 'package:amity_university/ServiceProvider/Presentation/UI/Home/Serviceproviderhome.dart';
import 'package:amity_university/User/Presentation/Constants/ColorPicker.dart';
import 'package:amity_university/User/Presentation/UI/Auth%20File/LoginScreen.dart';
import 'package:amity_university/User/Presentation/UI/Home/Home.dart';
import 'package:amity_university/User/Presentation/UI/SplashScreen.dart';
import 'package:amity_university/Ztext.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<String?> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedInMobile = prefs.getString('loggedInMobile');
    String? role = prefs.getString('userRole'); // 'user' or 'provider'
    if (loggedInMobile != null && role != null) {
      return role;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Complaint App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorPicker.blueColor),
      ),
      home: FutureBuilder<String?>(
        future: getUserRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            if (snapshot.hasData) {
              if (snapshot.data == 'user') {
                return const HomeScreen(); // user screen
              } else if (snapshot.data == 'service_provider') {
                return const ServiceProviderHomeScreen(); // provider screen
              }
            }
            return const SplashScreen(); // default screen if no login
          }
        },
      ),
    );
  }
}
