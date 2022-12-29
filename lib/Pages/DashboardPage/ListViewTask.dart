import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:taskreminder/Components/TaskCard.dart';
import 'package:taskreminder/Database/DBModel.dart';
import 'package:taskreminder/Database/TaskModel.dart';
import 'package:taskreminder/Pages/AddTaskPage/AddTask.dart';
import 'package:taskreminder/main.dart';

class ListViewTask extends StatefulWidget {
  const ListViewTask({
    Key? key,
  }) : super(key: key);

  @override
  State<ListViewTask> createState() => _ListViewTaskState();
}

class _ListViewTaskState extends State<ListViewTask> {
  late Future<String> permissionStatusFuture;
  var permGranted = "granted";
  var permDenied = "denied";
  var permUnknown = "unknown";
  var permProvisional = "provisional";
  var currentPerm = "";
  var db = DatabaseConnect();
  late AddTask feedPage;

  late Widget currentPage;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      // set up the notification permissions class
      // set up the future to fetch the notification data
      permissionStatusFuture = getCheckNotificationPermStatus();
      // With this, we will be able to check if the permission is granted or not
      // when returning to the application
      permissionStatusFuture.then((snapshot) => {
            setState(() {
              currentPerm = snapshot.toString();
            }),
          });

      Future.delayed(const Duration(seconds: 2), () {
        if (currentPerm == "denied") {
          _showMyDialog();
        } else if (currentPerm == "unknown") {
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.requestPermission();
        } else {
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.requestPermission();
        }
      });
    });
  }

  /// When the application has a resumed status, check for the permission
  /// status
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        permissionStatusFuture = getCheckNotificationPermStatus();
      });
    }
  }

  /// Checks the notification permission status
  Future<String> getCheckNotificationPermStatus() {
    return NotificationPermissions.getNotificationPermissionStatus()
        .then((status) {
      switch (status) {
        case PermissionStatus.denied:
          return permDenied;
        case PermissionStatus.granted:
          return permGranted;
        case PermissionStatus.unknown:
          return permUnknown;
        case PermissionStatus.provisional:
          return permProvisional;
        default:
          return null!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: db.getBpRecord(),
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          var data = snapshot.data;
          var dataLength = data!.length;
          return dataLength == 0
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: Lottie.asset('assets/taskMan.json'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () => {
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: AddTask(),
                                  ),
                                ),
                              )
                            },
                            child: const Text(
                              "Click + to Add Task",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'mplus'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: dataLength,
                  itemBuilder: (context, i) {
                    return TaskCard(
                      id: data[i].id,
                      task: data[i].task,
                      subTask: data[i].subTask,
                      category: data[i].category,
                      date: data[i].date,
                      time: data[i].time,
                      isComplete: data[i].isComplete,
                      deleteFunction: deleteItem,
                    );
                  },
                );
        },
      ),
    );
  }

  late String userData;

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Please Eanble Notification For Reminder",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'mplus',
                  fontSize: 15,
                ),
              ),
            ),
            ElevatedButton(
              child: Text(
                "Click Here To Enable".toUpperCase(),
                style:
                    TextStyle(fontFamily: 'mplus', fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                // show the dialog/open settings screen
                NotificationPermissions.requestNotificationPermissions(
                        iosSettings: const NotificationSettingsIos(
                            sound: true, badge: true, alert: true))
                    .then((_) {
                  // when finished, check the permission status
                  setState(() {
                    permissionStatusFuture = getCheckNotificationPermStatus();
                  });
                });
                Navigator.pop(context);
              },
            ),
          ],
        ));
      },
    );
  }

  void deleteItem(TaskModel taskModel) async {
    await db.deleteBpRecord(taskModel);
    setState(() {});
  }
}
