import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
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
  // // create a database object so we can access database functions
  // var db = DatabaseConnect();
  //
  // completeTask(String isComplete) {
  //   db.updateBpRecord(widget.id, isComplete);
  //   setState(() {});
  // }

  @override
  void initState() {
    slipSubTask();

    super.initState();
  }

  List<String> subList = [];

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
              widget.subTask == "N/A"
                  ? SizedBox(
                      height: 00,
                    )
                  : subTask()
            ],
          ),
        ),
      ),
    );
  }

  subTask() {

   return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      itemCount: subList.length,
      itemBuilder: (context, i) {
        // without reminder = 2 or with reminder = 0, will add to all list or Today list
        return Text(subList[i]);
      },
    );

  }
}
