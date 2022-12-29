import 'package:flutter/material.dart';
import 'package:taskreminder/Components/TaskCategory/All.dart';
import 'package:taskreminder/Components/TaskCategory/Work.dart';
import 'package:taskreminder/Database/Constants.dart';
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
    setState(() {
      currentPage = Constants.currentPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.builder.call(context, currentTask);

    return currentPage == 'all'
        ? AllTask(
            id: widget.id,
            task: widget.task,
            subTask: widget.subTask,
            category: widget.category,
            time: widget.time,
            date: widget.date,
            isComplete: widget.isComplete,
            allTasks: widget.allTasks,
            deleteFunction: widget.deleteFunction)
        : WorkTask(
            id: widget.id,
            task: widget.task,
            subTask: widget.subTask,
            category: widget.category,
            time: widget.time,
            date: widget.date,
            isComplete: widget.isComplete,
            allTasks: widget.allTasks,
            deleteFunction: widget.deleteFunction);
  }
}
