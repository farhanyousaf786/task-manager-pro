import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
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

  const TodayTasks(
      {Key? key,
      required this.task,
      required this.id,
      required this.subTask,
      required this.category,
      required this.time,
      required this.date,
      required this.isComplete,
      required this.deleteFunction})
      : super(key: key);

  @override
  State<TodayTasks> createState() => _TodayTasksState();
}

class _TodayTasksState extends State<TodayTasks> {
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
          child: Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.grey.shade500,
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
        ),
      ),
    );
  }
}
