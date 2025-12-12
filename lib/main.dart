import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'screens/categories_screen.dart';
import 'firebase_options.dart'; // Од flutterfire configure

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initNotifications();
  }

  Future<void> initNotifications() async {
    final settings = await FirebaseMessaging.instance.requestPermission();
    print("Permission: ${settings.authorizationStatus}");


    await FirebaseMessaging.instance.subscribeToTopic("daily_recipe");
    print("Subscribed to topic: daily_recipe");


    final token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
  }

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM TOKEN: $token");

    runApp(MyApp());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealDB Recipes',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const CategoriesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
