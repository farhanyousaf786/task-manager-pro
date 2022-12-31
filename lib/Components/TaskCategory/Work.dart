import 'package:flutter/material.dart';
import 'package:taskreminder/Database/TaskModel.dart';

class WorkTask extends StatefulWidget {

  final List allTasks;
  final Function deleteFunction;

  const WorkTask(
      {Key? key,
      required this.allTasks,
      required this.deleteFunction})
      : super(key: key);

  @override
  State<WorkTask> createState() => _WorkTaskState();
}

class _WorkTaskState extends State<WorkTask> {
  @override
  Widget build(BuildContext context) {



    return Column(
      children: [
        Text("work")

      ],
    );
  }
}
