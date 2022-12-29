import 'package:flutter/material.dart';

class WorkTask extends StatefulWidget {
  const WorkTask({Key? key}) : super(key: key);

  @override
  State<WorkTask> createState() => _WorkTaskState();
}

class _WorkTaskState extends State<WorkTask> {
  @override
  Widget build(BuildContext context) {
    return Text("Work List");
  }
}
