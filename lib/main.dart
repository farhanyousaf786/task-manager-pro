import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskreminder/Pages/LandingPage.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To-Do Task Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LandingPage() // this page wil contain all pages along with bottom bar
        );
  }
}

//keytool -genkey -v -keystore D:\IT\Pro\appKeys\TaskReminder\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
//flutter build appbundle --target-platform android-arm,android-arm64
//flutter build apk --target-platform=android-arm
//flutter build apk --target-platform=android-arm64
//flutter build appbundle --release