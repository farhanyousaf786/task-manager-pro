import 'package:flutter/material.dart';
import 'package:taskreminder/Pages/LandingPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do Task Reminder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LandingPage()  // this page wil contain all pages along with bottom bar
    );
  }
}


//flutter build appbundle --target-platform android-arm,android-arm64
//flutter build apk --target-platform=android-arm
//flutter build apk --target-platform=android-arm64
//flutter build appbundle --release
