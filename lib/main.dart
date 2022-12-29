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
        title: 'To-Do Task Reminder',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:
            const LandingPage() // this page wil contain all pages along with bottom bar
        );
  }
}

// //flutter build appbundle --target-platform android-arm,android-arm64
// //flutter build apk --target-platform=android-arm
// //flutter build apk --target-platform=android-arm64
// //flutter build appbundle --release


// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:notification_permissions/notification_permissions.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   late Future<String> permissionStatusFuture;
//
//   var permGranted = "granted";
//   var permDenied = "denied";
//   var permUnknown = "unknown";
//   var permProvisional = "provisional";
//
//   @override
//   void initState() {
//     super.initState();
//     // set up the notification permissions class
//     // set up the future to fetch the notification data
//     permissionStatusFuture = getCheckNotificationPermStatus();
//     // With this, we will be able to check if the permission is granted or not
//     // when returning to the application
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   /// When the application has a resumed status, check for the permission
//   /// status
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       setState(() {
//         permissionStatusFuture = getCheckNotificationPermStatus();
//       });
//     }
//   }
//
//   /// Checks the notification permission status
//   Future<String> getCheckNotificationPermStatus() {
//     return NotificationPermissions.getNotificationPermissionStatus()
//         .then((status) {
//       switch (status) {
//         case PermissionStatus.denied:
//           return permDenied;
//         case PermissionStatus.granted:
//           return permGranted;
//         case PermissionStatus.unknown:
//           return permUnknown;
//         case PermissionStatus.provisional:
//           return permProvisional;
//         default:
//           return null!;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Notification Permissions'),
//         ),
//         body: Center(
//             child: Container(
//               margin: EdgeInsets.all(20),
//               child: FutureBuilder(
//                 future: permissionStatusFuture,
//                 builder: (context, snapshot) {
//                   // if we are waiting for data, show a progress indicator
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator();
//                   }
//
//                   if (snapshot.hasError) {
//                     return Text('error while retrieving status: ${snapshot.error}');
//                   }
//
//                   if (snapshot.hasData) {
//                     var textWidget = Text(
//                       "The permission status is ${snapshot.data}",
//                       style: TextStyle(fontSize: 20),
//                       softWrap: true,
//                       textAlign: TextAlign.center,
//                     );
//                     // The permission is granted, then just show the text
//                     if (snapshot.data == permGranted) {
//                       return textWidget;
//                     }
//
//                     // else, we'll show a button to ask for the permissions
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         textWidget,
//                         SizedBox(
//                           height: 20,
//                         ),
//                         ElevatedButton(
//                           child: Text("Ask for notification status".toUpperCase()),
//                           onPressed: () {
//                             // show the dialog/open settings screen
//                             NotificationPermissions.requestNotificationPermissions(
//                                 iosSettings: const NotificationSettingsIos(
//                                     sound: true, badge: true, alert: true))
//                                 .then((_) {
//                               // when finished, check the permission status
//                               setState(() {
//                                 permissionStatusFuture =
//                                     getCheckNotificationPermStatus();
//                               });
//                             });
//                           },
//                         )
//                       ],
//                     );
//                   }
//                   return Text("No permission status yet");
//                 },
//               ),
//             )),
//       ),
//     );
//   }
// }