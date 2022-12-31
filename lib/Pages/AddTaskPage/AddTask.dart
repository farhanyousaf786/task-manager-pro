import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:popover/popover.dart';
import 'package:taskreminder/Components/SubTaskElement.dart';
import 'package:taskreminder/Database/DBModel.dart';
import 'package:taskreminder/Database/TaskModel.dart';
import 'package:taskreminder/Pages/LandingPage.dart';
import 'package:taskreminder/main.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  //text field that input task name
  var subTaskList = <TextEditingController>[];
  final taskController = TextEditingController();
  String categoryName = 'No Category';
  String subTask = "";
  var cards = <Card>[];
  DateTime? reminderDate;
  TimeOfDay? reminderTime;
  String isComplete = 'no';

  dataAndTimePicker() async {
    reminderDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    ))!;
    reminderTime =

        (await showTimePicker(context: context, initialTime: TimeOfDay.now(),
        cancelText: ""))!;

  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  _onDone() {

    if (cards.isNotEmpty) {
      for (int i = 0; i < cards.length; i++) {
        // give Flag _F_ into string so when we retrieve it
        // it makes us easy to separate each task
        subTask = "${subTask}_F_${subTaskList[i].text}";
      }
    }

    if (cards.isEmpty) {
      subTask = "N/A";
    }

    if (reminderTime != null && reminderDate != null) {
      setNotification();
    }

    Fluttertoast.showToast(
        msg: "Task Added to Reminder List",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    var taskInfo = TaskModel(
        task: taskController.text,
        subTask: subTask.toString(),
        category: categoryName.toString(),
        time: reminderTime.toString(),
        date: reminderDate.toString(),
        isComplete: isComplete.toString());

    addItem(taskInfo);
    print("date = >>>==  ${reminderDate.runtimeType}");
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const LandingPage(),
      ),
      (route) => false, //if you want to disable back feature set to false
    );
  }

  // create a database object so we can access database functions
  var db = DatabaseConnect();
  // function to add BP
  void addItem(TaskModel taskInfo) async {
    await db.insertBpRecord(taskInfo);
  }
  setNotification() async {
    var scheduledNotificationDateTime = reminderDate
        ?.add(Duration(hours: reminderTime!.hour, minutes: reminderTime!.minute))
        .subtract(const Duration(seconds: 5));

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      taskController.text,
      'To Do Notification',
      // 'Do the task',
      priority: Priority.max,
      importance: Importance.max,
      largeIcon: const DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
      styleInformation: const MediaStyleInformation(
        htmlFormatContent: true,
        htmlFormatTitle: true,
      ),
      sound: const RawResourceAndroidNotificationSound('notification1'),
      playSound: true,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.schedule(
        DateTime.now().microsecond,
        'Get It Done',
        'Time For: ${taskController.text}',
        scheduledNotificationDateTime!,
        platformChannelSpecifics);

    //
    // TimeOfDay _selectedTime;
    // String rTime;
    //
    // if (reminderTime != null) {
    //   setState(() {
    //     _selectedTime =
    //         reminderTime!.replacing(hour: reminderTime!.hourOfPeriod);
    //
    //     rTime = _selectedTime.hour.toString() +
    //         ":" +
    //         _selectedTime.minute.toString();
    //   });
    // }

    // await Provider.of<TaskData>(
    //   context,
    //   listen: false,
    // ).addTask(
    //   Task(
    //     reminderTime: rTime,
    //     title: currTask,
    //     isChecked: false,
    //     isRemindMe: remindMe,
    //     reminderDate: reminderDate == null
    //         ? null
    //         : reminderDate.add(Duration(
    //             hours: reminderTime.hour,
    //             minutes: reminderTime.minute,
    //           )),
    //     reminderId: reminderDate != null ? id : null,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 70,
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                controller: taskController,
                autofocus: true,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  isDense: true,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  filled: true,
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  labelText: 'My Task',
                  labelStyle: TextStyle(
                    fontFamily: "mplus",
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            reminderTime == null
                ? SizedBox(
                    height: 0,
                    width: 0,
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.blue.shade50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text(
                              "Reminder: ",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'mplus'),
                            ),
                          ),
                          Text(
                            "${DateFormat.yMMMd().format(reminderDate!)}  ",
                            style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: 'mplus'),
                          ),
                          Text(
                            "${formatTimeOfDay(reminderTime!)}    ",
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'mplus'),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                reminderTime = null;
                                reminderTime = null;
                              });
                            },
                            child: const Icon(
                              Icons.clear,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            SizedBox(
              height: cards.isEmpty
                  ? 0
                  : cards.length < 3
                      ? 100
                      : 200,
              child: ListView.builder(
                itemCount: cards.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        cards[index],
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                              onPressed: () => {
                                    cards.removeAt(index),
                                    setState(() {}),
                                  },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.grey,
                              )),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
                right: 8,
                left: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _subTask();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 22),
                          child: Container(
                            child: Text(
                              categoryName,
                              style: TextStyle(
                                fontFamily: 'mplus',
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                                color: categoryName == 'No Category'
                                    ? Colors.blueAccent
                                    : Colors.green,
                              ),
                            ),
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => {setState(() => cards.add(createCard()))},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.blue.shade50),
                            child: Row(
                              children: const [
                                Text(
                                  "Sub Task",
                                  style: TextStyle(
                                      fontFamily: 'mplus',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                      color: Colors.blueAccent),
                                ),
                                Icon(
                                  Icons.subdirectory_arrow_right,
                                  size: 15,
                                  color: Colors.blueAccent,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => {dataAndTimePicker()},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.green.shade50,
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  "Reminder ",
                                  style: TextStyle(
                                      fontFamily: 'mplus',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                      color: Colors.green),
                                ),
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.green.shade700,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => {
                            _onDone(),
                          },
                          child: const Icon(
                            Icons.done_outline_rounded,
                            color: Colors.blueAccent,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _subTask() {
    showPopover(
        shadow: <BoxShadow>[
          const BoxShadow(
            color: Colors.transparent,
            blurRadius: 0,
            offset: Offset(0, 0),
          ),
        ],
        context: context,
        bodyBuilder: (context) => SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        categoryName = "Work";
                      }),
                      Navigator.pop(context),
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Work",
                        style: TextStyle(
                            fontFamily: 'mplus',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        categoryName = "Personal";
                      }),
                      Navigator.pop(context),
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Personal",
                        style: TextStyle(
                            fontFamily: 'mplus',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        categoryName = "Watchlist";
                      }),
                      Navigator.pop(context),
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Watchlist",
                        style: TextStyle(
                            fontFamily: 'mplus',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        categoryName = "Birthday";
                      }),
                      Navigator.pop(context),
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Birthday",
                        style: TextStyle(
                            fontFamily: 'mplus',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        categoryName = "Urgent";
                      }),
                      Navigator.pop(context),
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Urgent",
                        style: TextStyle(
                            fontFamily: 'mplus',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        categoryName = "Important";
                      }),
                      Navigator.pop(context),
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Important",
                        style: TextStyle(
                            fontFamily: 'mplus',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        categoryName = "Home";
                      }),
                      Navigator.pop(context),
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Home",
                        style: TextStyle(
                            fontFamily: 'mplus',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        categoryName = "Others";
                      }),
                      Navigator.pop(context),
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Others",
                        style: TextStyle(
                            fontFamily: 'mplus',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        onPop: () => print('Popover was popped!'),
        direction: PopoverDirection.bottom,
        width: 120,
        height: MediaQuery.of(context).size.height / 3,
        arrowHeight: 15,
        arrowWidth: 25,
        backgroundColor: Colors.white,
        barrierColor: Colors.transparent,
        transitionDuration: Duration(milliseconds: 500));
  }

  Card createCard() {
    var subCatController = TextEditingController();
    subTaskList.add(subCatController);
    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.4,
          child: TextField(
            controller: subCatController,
            decoration: InputDecoration(
              fillColor: Colors.grey.shade100,
              isDense: true,
              border: InputBorder.none,
              filled: true,
              hintText: 'Sub Task ${cards.length + 1}',
              hintStyle: TextStyle(
                fontFamily: "mplus",
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
