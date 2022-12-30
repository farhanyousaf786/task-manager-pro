import 'package:flutter/material.dart';

class FutureTask extends StatefulWidget {
  final int id;
  final String task;
  final String subTask;
  final String category;
  final String time;
  final String date;
  final String isComplete;
  final Function deleteFunction;

  const FutureTask(
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
  State<FutureTask> createState() => _FutureTaskState();
}

class _FutureTaskState extends State<FutureTask> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.task);
  }
}
