import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:taskreminder/Components/TaskCategory/All/Future.dart';
import 'package:taskreminder/Components/TaskCategory/All/Today.dart';
import 'package:taskreminder/Components/TaskCategory/All/Tomorrow.dart';

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
  late DateTime myDate;
  late int? checkTaskDay;
  late bool isExpandToday = true;
  late bool isExpandTomorrow = true;
  late bool isExpandFuture = true;

  @override
  void initState() {
    initializeDateFormatting('pt_BR', null);
    super.initState();
  }

  /// Returns the difference (in full days) between the provided date and today.
  /// Yesterday : calculateDifference(date) == -1.
  /// Today : calculateDifference(date) == 0.
  /// Tomorrow : calculateDifference(date) == 1
  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => {
                  if (isExpandToday == false)
                    {
                      setState(() {
                        isExpandToday = true;
                      })
                    }
                  else
                    {
                      setState(() {
                        isExpandToday = false;
                      })
                    }
                },
                child: Row(
                  children: [
                    Text(
                      "Today",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'mplus',
                          fontSize: 16),
                    ),
                    Icon(isExpandToday == true
                        ? Icons.arrow_downward
                        : Icons.double_arrow_outlined)
                  ],
                ),
              ),
            ),
            isExpandToday == true
                ? Container(
                    color: Colors.blueAccent,
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: widget.allTasks.length,
                      itemBuilder: (context, i) {
                        if (widget.allTasks[i].date.toString() == "null") {
                          // without reminder = 2, will add to all list or Today list
                          checkTaskDay = 2;
                        } else if (widget.allTasks[i].date.toString() !=
                            "null") {
                          var trimmedDate =
                              widget.allTasks[i].date.substring(0, 10);
                          myDate = Intl.withLocale(
                              'en',
                              () =>
                                  DateFormat("yyyy-MM-dd").parse(trimmedDate));
                          checkTaskDay = calculateDifference(myDate);
                        }

                        // without reminder = 2 or with reminder = 0, will add to all list or Today list

                        return checkTaskDay == 0 || checkTaskDay == 2
                            ? TodayTasks(
                                task: widget.allTasks[i].task,
                                id: widget.allTasks[i].id,
                                subTask: widget.allTasks[i].subTask,
                                category: widget.allTasks[i].category,
                                date: widget.allTasks[i].date,
                                time: widget.allTasks[i].time,
                                isComplete: widget.allTasks[i].isComplete,
                                deleteFunction: widget.deleteFunction,
                              )
                            : const SizedBox(
                                height: 0,
                              );
                      },
                    ),
                  )
                : Text(
                    "Click to expand Today task",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'mplus',
                        fontSize: 16),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => {
                  if (isExpandTomorrow == false)
                    {
                      setState(() {
                        isExpandTomorrow = true;
                      })
                    }
                  else
                    {
                      setState(() {
                        isExpandTomorrow = false;
                      })
                    }
                },
                child: Row(
                  children: [
                    Text(
                      "Tomorrow",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'mplus',
                          fontSize: 16),
                    ),
                    Icon(isExpandTomorrow == true
                        ? Icons.arrow_downward
                        : Icons.double_arrow_outlined)
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.green,
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: widget.allTasks.length,
                itemBuilder: (context, i) {
                  if (widget.allTasks[i].date.toString() == "null") {
                  } else if (widget.allTasks[i].date.toString() != "null") {
                    var trimmedDate = widget.allTasks[i].date.substring(0, 10);
                    myDate = Intl.withLocale('en',
                        () => DateFormat("yyyy-MM-dd").parse(trimmedDate));
                    checkTaskDay = calculateDifference(myDate);
                  }
                  return checkTaskDay == 1
                      ? TomorrowTask(
                          task: widget.allTasks[i].task,
                          id: widget.allTasks[i].id,
                          subTask: widget.allTasks[i].subTask,
                          category: widget.allTasks[i].category,
                          date: widget.allTasks[i].date,
                          time: widget.allTasks[i].time,
                          isComplete: widget.allTasks[i].isComplete,
                          deleteFunction: widget.deleteFunction,
                        )
                      : const SizedBox(
                          height: 0,
                        );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => {
                  if (isExpandFuture == false)
                    {
                      setState(() {
                        isExpandFuture = true;
                      })
                    }
                  else
                    {
                      setState(() {
                        isExpandFuture = false;
                      })
                    }
                },
                child: Row(
                  children: [
                    Text(
                      "Future",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'mplus',
                          fontSize: 16),
                    ),
                    Icon(isExpandFuture == true
                        ? Icons.arrow_downward
                        : Icons.double_arrow_outlined)
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.red,
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: widget.allTasks.length,
                itemBuilder: (context, i) {
                  if (widget.allTasks[i].date.toString() == "null") {
                  } else if (widget.allTasks[i].date.toString() != "null") {
                    var trimmedDate = widget.allTasks[i].date.substring(0, 10);
                    myDate = Intl.withLocale('en',
                        () => DateFormat("yyyy-MM-dd").parse(trimmedDate));
                    checkTaskDay = calculateDifference(myDate);
                  }
                  return checkTaskDay! < 3
                      ? const SizedBox(
                          height: 0,
                        )
                      : FutureTask(
                          task: widget.allTasks[i].task,
                          id: widget.allTasks[i].id,
                          subTask: widget.allTasks[i].subTask,
                          category: widget.allTasks[i].category,
                          date: widget.allTasks[i].date,
                          time: widget.allTasks[i].time,
                          isComplete: widget.allTasks[i].isComplete,
                          deleteFunction: widget.deleteFunction,
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
