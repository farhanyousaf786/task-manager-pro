import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:taskreminder/Database/Constants.dart';
import 'package:taskreminder/Database/TaskModel.dart';
import 'package:taskreminder/Pages/DashboardPage/ListViewTask.dart';

class TaskWidget extends StatefulWidget {
  final int id;
  final String task;
  final String subTask;
  final String category;
  final String time;
  final String date;
  final String isComplete;
  final MyBuilder builder;
  final Function deleteFunction;
  final Function completeTask;

  const TaskWidget({
    Key? key,
    required this.task,
    required this.id,
    required this.subTask,
    required this.category,
    required this.time,
    required this.date,
    required this.isComplete,
    required this.deleteFunction,
    required this.completeTask,
    required this.builder,
  }) : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  List<String> subList = [];
  late TimeOfDay? reminderTime = const TimeOfDay(hour: 15, minute: 0);
  late DateTime? reminderDate = DateTime.now();
  String currentPage = "all";

  @override
  void initState() {
    initializeDateFormatting('pt_BR', null);
    if (widget.time == "null") {
    } else {
      getTime();
      getDate();
      Future.delayed(const Duration(milliseconds: 100), () {});
    }
    slipSubTask();
    super.initState();
  }

  void currentTask() {
    setState(() {
      currentPage = Constants.currentPage;
    });
  }

  removeNotificationFromSchedual(int id) async {
    final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  slipSubTask() {
    //this will split every subTask from _F_ Flaf

    if (widget.subTask == "N/A") {
    } else {
      final tagName = widget.subTask;
      final split = tagName.split('_F_');
      final Map<int, String> values = {
        for (int i = 0; i < split.length; i++) i: split[i]
      };
      for (int i = 1; i <= values.length - 1; i++) {
        subList.add(values[i]!);
      }
      print("Sub list >> $subList");
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  // get time in string and convert into TimeOfDat and then get PM AM
  // by using formatTimeOfDay function
  getTime() {
    var time = widget.time.substring(10, 15);
    reminderTime = TimeOfDay(
        hour: int.parse(time.split(":")[0]),
        minute: int.parse(time.split(":")[1]));
  }

  getDate() {
    var trimmedDate = widget.date.substring(0, 10);
    reminderDate = Intl.withLocale(
        'en', () => DateFormat("yyyy-MM-dd").parse(trimmedDate));
  }

  @override
  Widget build(BuildContext context) {
    widget.builder.call(context, currentTask);
    var otherTaskCard = TaskModel(
      id: widget.id,
      task: widget.subTask,
      subTask: widget.subTask,
      category: widget.category,
      time: widget.time,
      date: widget.date,
      isComplete: widget.isComplete,
    );

    return widget.category == Constants.currentPage
        ? SwipeActionCell(
            backgroundColor: Colors.white,
            key: ObjectKey(widget.id),

            /// this key is necessary
            trailingActions: <SwipeAction>[
              SwipeAction(
                  backgroundRadius: 10,
                  title: "Delete",
                  style: const TextStyle(
                      fontSize: 12, color: Colors.white, fontFamily: 'mplu'),
                  onTap: (CompletionHandler handler) async {
                    widget.deleteFunction(otherTaskCard);
                    removeNotificationFromSchedual(widget.id);
                  },
                  color: Colors.red),
            ],

            child: GestureDetector(
              onTap: () {
                showDetails(otherTaskCard);
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 5, bottom: 5, right: 8, left: 8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      task(),
                      subTask(),
                      reminder('false'),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Constants.currentPage == "all"
            ? SwipeActionCell(
                backgroundColor: Colors.white,
                key: ObjectKey(widget.id),

                /// this key is necessary
                trailingActions: <SwipeAction>[
                  SwipeAction(
                      backgroundRadius: 10,
                      title: "Delete",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: 'mplu'),
                      onTap: (CompletionHandler handler) async {
                        widget.deleteFunction(otherTaskCard);
                        removeNotificationFromSchedual(widget.id);
                      },
                      color: Colors.red),
                  // SwipeAction(
                  //     title: "Edit",
                  //     style: const TextStyle(
                  //         fontSize: 12,
                  //         color: Colors.white,
                  //         fontFamily: 'mplu'),
                  //     onTap: (CompletionHandler handler) async {},
                  //     color: Colors.blueAccent),
                ],

                child: GestureDetector(
                  onTap: () {
                    showDetails(otherTaskCard);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, right: 8, left: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.withOpacity(0.08),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          task(),
                          subTask(),
                          reminder('false'),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(
                height: 0,
              );
  }

  Widget task() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                widget.completeTask(
                    widget.id, widget.isComplete == "yes" ? "no" : "yes");
                removeNotificationFromSchedual(widget.id);
              },
              child: Icon(
                widget.isComplete == "yes"
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
                color: Colors.grey.shade500,
              ),
            ),
            Text(
              "  ${widget.task.length > 20 ? "${widget.task.substring(0, 19)}...." : widget.task}",
              style: TextStyle(
                  fontFamily: 'mplus',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  decoration: widget.isComplete == "yes"
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
            widget.time == "null"
                ? Text(
                    widget.category == "No Category"
                        ? ""
                        : " (${widget.category})",
                    style: TextStyle(
                      fontSize: 8,
                      fontFamily: 'mplus',
                      fontWeight: FontWeight.w600,
                      color: Colors.purple,
                    ),
                  )
                : Text(""),
          ],
        ),
        Row(
          children: [
            widget.date == "null"
                ? SizedBox(
                    width: 0,
                    height: 0,
                  )
                : Icon(
                    Icons.add_alert_rounded,
                    size: 16,
                    color: Colors.black.withOpacity(0.6),
                  )
          ],
        ),
      ],
    );
  }

  Widget subTask() {
    if (widget.subTask == "N/A") {
      return const SizedBox(
        height: 0,
      );
    } else {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: subList.length,
        itemBuilder: (context, i) {
          // without reminder = 2 or with reminder = 0, will add to all list or Today list
          return Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.transparent,
              ),
              Text(
                " ${i + 1})  ${subList[i].length > 20 ? "${subList[i].substring(0, 19)}..." : subList[i]}",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontFamily: 'mplus'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget reminder(String hide) {
    if (widget.time == "null") {
      return SizedBox(
        height: 0,
        width: 0,
      );
    } else {
      return Row(
        children: [
          hide == "true"
              ? const SizedBox(
                  height: 0,
                  width: 0,
                )
              : const Icon(
                  Icons.check_circle_outline,
                  color: Colors.transparent,
                ),
          Text(
            "  ${DateFormat.yMMMd().format(reminderDate!)} at ${formatTimeOfDay(reminderTime!)}",
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'mplus',
              fontWeight: FontWeight.w600,
              color: Colors.green.shade700,
            ),
          ),
          Text(
            widget.category == "No Category" ? "" : " (${widget.category})",
            style: TextStyle(
              fontSize: 8,
              fontFamily: 'mplus',
              fontWeight: FontWeight.w600,
              color: Colors.purple,
            ),
          ),
        ],
      );
    }
  }

  showDetails(var otherTaskCard) {
    showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        barrierColor: Colors.red.withOpacity(0.2),
        elevation: 0,
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Tasks Details",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "mplus",
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),

                  /// These are Task Widgets
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 30),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.task_alt_sharp,
                              size: 17,
                              color: Colors.black,
                            ),
                            Text(
                              " Tasks:",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "mplus",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 0, bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.task_alt_sharp,
                          size: 17,
                          color: Colors.transparent,
                        ),
                        Flexible(
                          child: Text(
                            " ${widget.task}",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "mplus",
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(),

                  /// These are subTask Widgets
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      top: 0,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_tree_rounded,
                          size: 17,
                          color: Colors.black,
                        ),
                        Text(
                          " Sub Tasks:",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "mplus",
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  subTaskForBottomSheet(),
                  const Divider(),

                  /// These are Reminder Widgets
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      top: 0,
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.calendar_month_outlined, size: 17, color: Colors.black,),

                        Text(
                          " Reminder:",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "mplus",
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  widget.time == "null"
                      ? Padding(
                          padding:
                              const EdgeInsets.only(left: 8, top: 1, bottom: 4),
                          child: Row(
                            children: [
                              Icon(Icons.task_alt_sharp, size: 17, color: Colors.transparent,),

                              Text(
                                " No Reminder Set",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "mplus",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(left: 8, top: 1, bottom: 4),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_month_outlined, size: 17, color: Colors.transparent,),
                              reminder('true'),
                            ],
                          ),
                        ),
                  const Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => {
                          widget.completeTask(widget.id,
                              widget.isComplete == "yes" ? "no" : "yes"),
                          removeNotificationFromSchedual(widget.id),
                          Navigator.pop(context),
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green, // background
                          onPrimary: Colors.blue,
                          elevation: 0.0// foreground
                        ),

                        child: Text(
                          widget.isComplete == "yes"
                              ? "Mark As Incomplete"
                              : "Mark As Complete",
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: "mplus",
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // background
                          onPrimary: Colors.blue,
                            elevation: 0.0// foreground
// foreground
                        ),
                        onPressed: () => {
                          widget.deleteFunction(otherTaskCard),
                          removeNotificationFromSchedual(widget.id),
                          Navigator.pop(context),
                        },
                        child: const Text(
                          "Delete Task",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "mplus",
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  subTaskForBottomSheet() {
    if (widget.subTask == "N/A") {
      return Row(
        children: [
          Icon(
            Icons.task_alt_sharp,
            size: 17,
            color: Colors.transparent,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 1, bottom: 4),
            child: Text(
              " There is No Sub Task Available",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: "mplus",
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.6)),
            ),
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          itemCount: subList.length,
          itemBuilder: (context, i) {
            // without reminder = 2 or with reminder = 0, will add to all list or Today list

            return Row(
              children: [
                Icon(
                  Icons.task_alt_sharp,
                  size: 17,
                  color: Colors.transparent,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 5, bottom: 1),
                    child: Text(
                      "${i + 1})  ${subList[i]}",
                      softWrap: true,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blueAccent,
                          fontSize: 12),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }
  }
}
