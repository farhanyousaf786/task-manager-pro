
import 'package:flutter/material.dart';

class CalendarViewTask extends StatefulWidget {
  const CalendarViewTask({Key? key}) : super(key: key);

  @override
  State<CalendarViewTask> createState() => _CalendarViewTaskState();
}

class _CalendarViewTaskState extends State<CalendarViewTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(),
      body: Text("Calendar View"),);
  }
}
