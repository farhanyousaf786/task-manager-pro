import 'package:flutter/material.dart';
import 'package:taskreminder/Database/TaskModel.dart';
import 'package:taskreminder/Pages/DashboardPage/ListViewTask.dart';

class TaskCard extends StatefulWidget {
  final int id;
  final String task;
  final String subTask;
  final String category;
  final String time;
  final String date;
  final String isComplete;
  final List allTasks;
  final Function deleteFunction;
  final MyBuilder builder;

  const TaskCard({
    Key? key,
    required this.id,
    required this.task,
    required this.subTask,
    required this.category,
    required this.time,
    required this.date,
    required this.isComplete,
    required this.deleteFunction,
    required this.allTasks,
    required this.builder,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  String currentPage = "all";

  void currentTask() {
    print('test');
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
    widget.builder.call(context, currentTask);

    return Column(
      children: [
        Text(widget.subTask),
        GestureDetector(
          onTap: () => widget.deleteFunction(otherTaskCard),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.blue.shade900,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 3, top: 3),
              child: Text(
                "Delete",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'bal',
                  fontSize: 15,
                  color: Colors.blue.shade100,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
