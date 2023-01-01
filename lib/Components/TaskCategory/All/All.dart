import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:taskreminder/Components/TaskCategory/All/TaskWidget.dart';
import 'package:taskreminder/Database/Constants.dart';
import 'package:taskreminder/Pages/DashboardPage/ListViewTask.dart';

class AllTask extends StatefulWidget {
  final List allTasks;
  final Function deleteFunction;
  final Function completeTask;
  final MyBuilder builder;

  const AllTask(
      {Key? key,
      required this.allTasks,
      required this.deleteFunction,
      required this.completeTask,
      required this.builder})
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
  late bool isExpandComplete = true;
  late int taskRemaining = 0;

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

  taskRemainingCounter() {
    for (int i = 0; i < widget.allTasks.length; i++) {
      if (widget.allTasks[i].isComplete == "no") {
        taskRemaining = taskRemaining + 1;
      }
    }
    if (taskRemaining == 0) {
      Future.delayed(Duration.zero, () async {
        Constants.helperBottomSheet == 1 ? showTaskComplete() : null;
        setState(() {
          Constants.helperBottomSheet = 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
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
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.6)),
                  ),
                  Icon(
                    isExpandToday == true
                        ? Icons.arrow_drop_down
                        : Icons.arrow_drop_up,
                    color: Colors.black54,
                  )
                ],
              ),
            ),
          ),
          isExpandToday == true
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: widget.allTasks.length,
                    itemBuilder: (context, i) {
                      if (widget.allTasks[i].date.toString() == "null") {
                        // without reminder = 4, will add to all list or Today list
                        checkTaskDay = 4;
                      } else if (widget.allTasks[i].date.toString() != "null") {
                        var trimmedDate =
                            widget.allTasks[i].date.substring(0, 10);
                        myDate = Intl.withLocale('en',
                            () => DateFormat("yyyy-MM-dd").parse(trimmedDate));
                        checkTaskDay = calculateDifference(myDate);
                      }

                      taskRemaining = 0;
                      Constants.helperBottomSheet == 1
                          ? taskRemainingCounter()
                          : null;

                      // without reminder = 2 or with reminder = 0, will add to all list or Today list
                      return checkTaskDay == 0 &&
                                  widget.allTasks[i].isComplete == 'no' ||
                              checkTaskDay == 4 &&
                                  widget.allTasks[i].isComplete == 'no'
                          ? TaskWidget(
                              task: widget.allTasks[i].task,
                              id: widget.allTasks[i].id,
                              subTask: widget.allTasks[i].subTask,
                              category: widget.allTasks[i].category,
                              date: widget.allTasks[i].date,
                              time: widget.allTasks[i].time,
                              isComplete: widget.allTasks[i].isComplete,
                              deleteFunction: widget.deleteFunction,
                              completeTask: widget.completeTask,
                              builder: widget.builder,
                            )
                          : const SizedBox(
                              height: 0,
                            );
                    },
                  ),
                )
              : SizedBox(height: 0.0),
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
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.6)),
                  ),
                  Icon(
                    isExpandTomorrow == true
                        ? Icons.arrow_drop_down
                        : Icons.arrow_drop_up,
                    color: Colors.black54,
                  )
                ],
              ),
            ),
          ),
          isExpandTomorrow == true
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: widget.allTasks.length,
                    itemBuilder: (context, i) {
                      if (widget.allTasks[i].date.toString() == "null") {
                        checkTaskDay = 4;
                      } else if (widget.allTasks[i].date.toString() != "null") {
                        var trimmedDate =
                            widget.allTasks[i].date.substring(0, 10);
                        myDate = Intl.withLocale('en',
                            () => DateFormat("yyyy-MM-dd").parse(trimmedDate));
                        checkTaskDay = calculateDifference(myDate);
                      }
                      return checkTaskDay == 1 &&
                              checkTaskDay != 4 &&
                              widget.allTasks[i].isComplete == 'no'
                          ? TaskWidget(
                              task: widget.allTasks[i].task,
                              id: widget.allTasks[i].id,
                              subTask: widget.allTasks[i].subTask,
                              category: widget.allTasks[i].category,
                              date: widget.allTasks[i].date,
                              time: widget.allTasks[i].time,
                              isComplete: widget.allTasks[i].isComplete,
                              deleteFunction: widget.deleteFunction,
                              completeTask: widget.completeTask,
                              builder: widget.builder,
                            )
                          : const SizedBox(
                              height: 0,
                            );
                    },
                  ),
                )
              : SizedBox(height: 0.0),
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
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.6)),
                  ),
                  Icon(
                    isExpandFuture == true
                        ? Icons.arrow_drop_down
                        : Icons.arrow_drop_up,
                    color: Colors.black54,
                  )
                ],
              ),
            ),
          ),
          isExpandFuture == true
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: widget.allTasks.length,
                    itemBuilder: (context, i) {
                      if (widget.allTasks[i].date.toString() == "null") {
                        checkTaskDay = 4;
                      } else if (widget.allTasks[i].date.toString() != "null") {
                        var trimmedDate =
                            widget.allTasks[i].date.substring(0, 10);
                        myDate = Intl.withLocale('en',
                            () => DateFormat("yyyy-MM-dd").parse(trimmedDate));
                        checkTaskDay = calculateDifference(myDate);
                      }
                      return checkTaskDay! < 2 ||
                              widget.allTasks[i].date.toString() == "null" ||
                              widget.allTasks[i].isComplete != 'no'
                          ? const SizedBox(
                              height: 0,
                            )
                          : TaskWidget(
                              task: widget.allTasks[i].task,
                              id: widget.allTasks[i].id,
                              subTask: widget.allTasks[i].subTask,
                              category: widget.allTasks[i].category,
                              date: widget.allTasks[i].date,
                              time: widget.allTasks[i].time,
                              isComplete: widget.allTasks[i].isComplete,
                              deleteFunction: widget.deleteFunction,
                              completeTask: widget.completeTask,
                              builder: widget.builder,
                            );
                    },
                  ),
                )
              : const SizedBox(height: 0.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => {
                if (isExpandComplete == false)
                  {
                    setState(() {
                      isExpandComplete = true;
                    })
                  }
                else
                  {
                    setState(() {
                      isExpandComplete = false;
                    })
                  }
              },
              child: Row(
                children: [
                  Text(
                    "Completed",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'mplus',
                      fontSize: 16,
                      color: Colors.green.withOpacity(0.9),
                    ),
                  ),
                  Icon(
                    isExpandComplete == true
                        ? Icons.arrow_drop_down
                        : Icons.arrow_drop_up,
                    color: Colors.black54,
                  )
                ],
              ),
            ),
          ),
          isExpandComplete == true
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: widget.allTasks.length,
                    itemBuilder: (context, i) {
                      if (widget.allTasks[i].date.toString() == "null") {
                      } else if (widget.allTasks[i].date.toString() != "null") {
                        var trimmedDate =
                            widget.allTasks[i].date.substring(0, 10);
                        myDate = Intl.withLocale('en',
                            () => DateFormat("yyyy-MM-dd").parse(trimmedDate));
                        checkTaskDay = calculateDifference(myDate);
                      }
                      return widget.allTasks[i].isComplete == 'yes'
                          ? TaskWidget(
                              task: widget.allTasks[i].task,
                              id: widget.allTasks[i].id,
                              subTask: widget.allTasks[i].subTask,
                              category: widget.allTasks[i].category,
                              date: widget.allTasks[i].date,
                              time: widget.allTasks[i].time,
                              isComplete: widget.allTasks[i].isComplete,
                              deleteFunction: widget.deleteFunction,
                              completeTask: widget.completeTask,
                              builder: widget.builder,
                            )
                          : SizedBox(
                              height: 0,
                            );
                    },
                  ),
                )
              : SizedBox(height: 0.0)
        ],
      ),
    );
  }

  showTaskComplete() {
    return showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        barrierColor: Colors.red.withOpacity(0.2),
        elevation: 0,
        context: context,
        builder: (context) {
          return Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height / 2.3,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.linear_scale_sharp,
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: Lottie.asset('assets/taskMan.json'),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Hurry! Today's List is Clear",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'mplus',
                              fontSize: 12,
                              color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
