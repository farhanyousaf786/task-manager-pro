import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:taskreminder/Database/TaskModel.dart';

class AllTask extends StatefulWidget {
  final int id;
  final String task;
  final String subTask;
  final String category;
  final String time;
  final String date;
  final String isComplete;
  final List allTasks;
  final Function deleteFunction;

  const AllTask(
      {Key? key,
      required this.id,
      required this.task,
      required this.subTask,
      required this.category,
      required this.time,
      required this.date,
      required this.isComplete,
      required this.allTasks,
      required this.deleteFunction})
      : super(key: key);

  @override
  State<AllTask> createState() => _AllTaskState();
}

class _AllTaskState extends State<AllTask> {
  List<String> subList = [];
  late DateTime myDate;
  late bool isLoading = true;

  @override
  void initState() {
    initializeDateFormatting('pt_BR', null);
    slipSubTask();
    getTodayAndFutureTask();
    super.initState();
  }

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
        print(values[i]);
        subList.add(values[i]!);
      }
    }
  }

  getTodayAndFutureTask() {
    // DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(widget.date);
    var trimmedDate =
        widget.date.substring(0, widget.date.lastIndexOf(' ') + 1);
    Future.delayed(const Duration(seconds: 1), () {
      myDate = Intl.withLocale(
          'en', () => new DateFormat("yyyy-MM-dd").parse(trimmedDate));
      print("date: ${myDate}");
      setState(() {
        isLoading = false;
      });
    });
  }

  /// Returns the difference (in full days) between the provided date and today.
  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
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

    if (isLoading) {
      return Text("Loading..");
    } else {
      return Column(
        children: [
          // allTask(),

          if (calculateDifference(myDate) == 0)
            TodayTask(otherTaskCard)
          else
            calculateDifference(myDate) == 1
                ? TomorrowTasks(otherTaskCard)
                : calculateDifference(myDate) == -1
                    ? SizedBox(
                        height: 0,
                      )
                    : FutureTask(otherTaskCard),
        ],
      );
    }
  }

  TodayTask(var otherTaskCard) {
    return Column(
      children: [
        Text("Today Tasks"),
        Text("Task: ${widget.task}"),
        for (var i in subList) Text(i.toString()),
        GestureDetector(
          onTap: () => widget.deleteFunction(otherTaskCard),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.blueAccent.shade200.withOpacity(0.85),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, bottom: 3, top: 3),
              child: Text(
                "Delete",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'bal',
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  TomorrowTasks(var otherTaskCard) {
    return Column(
      children: [
        Text("Tommorow Tasks"),
        Text("Task: ${widget.task}"),
        for (var i in subList) Text(i.toString()),
        GestureDetector(
          onTap: () => widget.deleteFunction(otherTaskCard),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.blueAccent.shade200.withOpacity(0.85),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, bottom: 3, top: 3),
              child: Text(
                "Delete",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'bal',
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  FutureTask(var otherTaskCard) {
    return Column(
      children: [
        Text("Future Tasks"),
        Text("Task: ${widget.task}"),
        for (var i in subList) Text(i.toString()),
        GestureDetector(
          onTap: () => widget.deleteFunction(otherTaskCard),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.blueAccent.shade200.withOpacity(0.85),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, bottom: 3, top: 3),
              child: Text(
                "Delete",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'bal',
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
