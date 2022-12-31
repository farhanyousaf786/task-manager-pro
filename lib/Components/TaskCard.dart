import 'package:flutter/material.dart';
import 'package:taskreminder/Components/TaskCategory/All/All.dart';
import 'package:taskreminder/Database/Constants.dart';
import 'package:taskreminder/Pages/DashboardPage/ListViewTask.dart';

class TaskCard extends StatefulWidget {
  final List allTasks;
  final Function deleteFunction;
  final Function completeTask;
  final MyBuilder builder;

  const TaskCard({
    Key? key,
    required this.deleteFunction,
    required this.allTasks,
    required this.builder,
    required this.completeTask,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  void initState() {
    print(widget.allTasks.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AllTask(
      allTasks: widget.allTasks,
      deleteFunction: widget.deleteFunction,
      completeTask: widget.completeTask,
      builder: widget.builder,
    );
  }
}
