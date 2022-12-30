import 'package:flutter/material.dart';
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.task),
        ),

        GestureDetector(

            onTap: ()=>{
              widget.deleteFunction(otherTaskCard)

            },
            child: Text("delete"))
      ],
    );
  }
}
