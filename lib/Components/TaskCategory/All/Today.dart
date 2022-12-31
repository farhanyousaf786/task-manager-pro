import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:intl/intl.dart';
import 'package:taskreminder/Database/DBModel.dart';
import 'package:taskreminder/Database/TaskModel.dart';

class TodayTasks extends StatefulWidget {
  final int id;
  final String task;
  final String subTask;
  final String category;
  final String time;
  final String date;
  final String isComplete;
  final Function deleteFunction;
  final Function completeTask;

  const TodayTasks({
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
  }) : super(key: key);

  @override
  State<TodayTasks> createState() => _TodayTasksState();
}

class _TodayTasksState extends State<TodayTasks> {
  List<String> subList = [];
  late TimeOfDay time;

  @override
  void initState() {
    getTime();
    slipSubTask();

    super.initState();
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
    var time0 = widget.time.substring(10, 15);
    time = TimeOfDay(
        hour: int.parse(time0.split(":")[0]),
        minute: int.parse(time0.split(":")[1]));
  }

  @override
  Widget build(BuildContext context) {
    var otherTaskCard = TaskModel(
      id: widget.id,
      task: widget.subTask,
      subTask: widget.subTask,
      category: widget.category,
      time: widget.time,
      date: widget.date,
      isComplete: widget.isComplete,
    );

    return SwipeActionCell(
      backgroundColor: Colors.white,

      key: ObjectKey(widget.id),

      /// this key is necessary
      trailingActions: <SwipeAction>[
        SwipeAction(
            backgroundRadius: 10,
            title: "Delete",
            style: TextStyle(
                fontSize: 12, color: Colors.white, fontFamily: 'mplu'),
            onTap: (CompletionHandler handler) async {
              widget.deleteFunction(otherTaskCard);
            },
            color: Colors.red),
        SwipeAction(
            title: "Edit",
            style: const TextStyle(
                fontSize: 12, color: Colors.white, fontFamily: 'mplu'),
            onTap: (CompletionHandler handler) async {},
            color: Colors.blueAccent),
      ],

      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5, right: 8, left: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blueAccent.withOpacity(0.1),
          ),
          padding: const EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              task(),
              subTask(),
              reminder(),
            ],
          ),
        ),
      ),
    );
  }

  task() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                widget.completeTask(widget.id, "yes");
              },
              child: Icon(
                widget.isComplete == "yes"
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
                color: Colors.grey.shade500,
              ),
            ),
            Text(
              "  ${widget.task.length > 18 ? "${widget.task.substring(0, 17)}...." : widget.task}",
              style: const TextStyle(
                  fontFamily: 'mplus',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87),
            ),
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

  subTask() {
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
          return Padding(
            padding: const EdgeInsets.only(left: 32, top: 1, bottom: 1),
            child: Text(
              "${i + 1})  ${subList[i].length > 10 ? "${subList[i].substring(0, 9)}..." : subList[i]}",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  fontSize: 12),
            ),
          );
        },
      );
    }
  }

  reminder() {
    return Row(
      children: [
        Icon(
          Icons.check_circle_outline,
          color: Colors.transparent,
        ),
        Text(
          widget.time + widget.date.toString(),
        )
      ],
    );
  }
}
