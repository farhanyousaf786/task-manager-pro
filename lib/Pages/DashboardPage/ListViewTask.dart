import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:taskreminder/Components/NoTask.dart';
import 'package:taskreminder/Components/TaskCard.dart';
import 'package:taskreminder/Database/Constants.dart';
import 'package:taskreminder/Database/DBModel.dart';
import 'package:taskreminder/Database/TaskModel.dart';
import 'package:taskreminder/Pages/AddTaskPage/AddTask.dart';
import 'package:taskreminder/main.dart';

typedef MyBuilder = void Function(
    BuildContext context, void Function() currentTask);

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
  late void Function() currentTask;

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

  void deleteItem(TaskModel taskModel) async {
    await db.deleteBpRecord(taskModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: db.getBpRecord(),
      initialData: const [],
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        var data = snapshot.data;
        var dataLength = data!.length;
        return dataLength == 0
            ? const NoTask()
            : Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  bottom: PreferredSize(
                    preferredSize:
                        Size(MediaQuery.of(context).size.width * 2, 0),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: categoryList()),
                  ),
                ),
                body: ListView.builder(
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
                      allTasks: data,
                      deleteFunction: deleteItem,
                      builder: (BuildContext context, void Function() ct) {
                        currentTask = ct;
                      },
                    );
                  },
                ),
              );
      },
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

  Widget categoryList() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              Constants.currentPage = 'all';
            });
            currentTask.call();
          },
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Container(
              padding:
              const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Constants.currentPage == "all"
                    ? Colors.blueAccent
                    : Colors.blueAccent.withOpacity(0.2),
              ),
              child: Text(
                "All",
                style: TextStyle(
                    fontFamily: 'mplus',
                    color: Constants.currentPage == "all"
                        ? Colors.white
                        : Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              Constants.currentPage = 'work';
            });
            currentTask.call();
          },
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Container(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Constants.currentPage == "work"
                    ? Colors.blueAccent
                    : Colors.blueAccent.withOpacity(0.2),
              ),
              child: Text(
                "Work",
                style: TextStyle(
                    fontFamily: 'mplus',
                    color: Constants.currentPage == "work"
                        ? Colors.white
                        : Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
