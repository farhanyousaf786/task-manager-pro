import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:taskreminder/Database/DBModel.dart';

class CalendarViewTask extends StatefulWidget {
  const CalendarViewTask({Key? key}) : super(key: key);

  @override
  State<CalendarViewTask> createState() => _CalendarViewTaskState();
}

class _CalendarViewTaskState extends State<CalendarViewTask> {
  final DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  var db = DatabaseConnect();
  final EventList<Event> _markedDateMap = EventList<Event>(events: {});
  List? titleList = [];
  List? dateList = [];
  List? categoryList = [];
  List? allTask = [];

  @override
  void initState() {
    addTaskToCalender();
    super.initState();
  }

  addTaskToCalender() {
    db.getBpRecord().then((value) => {
          for (int i = 0; i < value.length; i++)
            {
              if (value[i].date != "null")
                {
                  print(value[i].date),
                  print(value[i].date.substring(0, 4)),
                  print(value[i].date.substring(5, 7)),
                  print(value[i].date.substring(8, 10)),
                  _markedDateMap.add(
                    DateTime(
                      int.parse(value[i].date.substring(0, 4)),
                      int.parse(value[i].date.substring(5, 7)),
                      int.parse(
                        value[i].date.substring(8, 10),
                      ),
                    ),
                    Event(
                        date: DateTime(
                          int.parse(value[i].date.substring(0, 4)),
                          int.parse(value[i].date.substring(5, 7)),
                          int.parse(
                            value[i].date.substring(8, 10),
                          ),
                        ),
                        title: value[i].task,
                        icon: _eventIcon,
                        description: value[i].category),
                  ),
                }
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    /// Example Calendar Carousel without header and custom prev & next button
    final _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.white,
      onDayPressed: (date, events) => {
        this.setState(() => _currentDate2 = date),

        allTask = events.toList(),

        for (int i = 0; i < allTask!.length; i++)
          {
            print(allTask?[i].title),
            print(allTask?[i].description),
            print(allTask?[i].date),

            titleList!.add(allTask?[i].title),
            categoryList!.add(allTask?[i].description),
            dateList!.add(allTask?[i].date),
            // categoryList.add(list[i].category);
            // dateList.add(list[i].date);
          },
        showTasks(),

        // Future.delayed(const Duration(seconds: 2), () {
        //   print(
        //     ">>>>>>" + categoryList.toString(),
        //   );
        //
        // });
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
//      firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder:
          CircleBorder(side: BorderSide(color: Colors.blueAccent.shade100)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blueAccent.shade100,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blueAccent.shade100,
      ),
      // markedDateShowIcon: true,
      // markedDateIconMaxShown: 2,
      // markedDateIconBuilder: (event) {
      //   return event.icon;
      // },
      // markedDateMoreShowTotal:
      //     true,
      todayButtonColor: Colors.blueAccent,
      selectedDayTextStyle: const TextStyle(
        color: Colors.yellow,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "All Tasks",
            style: TextStyle(fontFamily: 'mplus', fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //custom icon
              // This trailing comma makes auto-formatting nicer for build methods.
              //custom icon without header
              Container(
                margin: const EdgeInsets.only(
                  top: 30.0,
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      _currentMonth,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    )),
                    TextButton(
                      child: Text('PREV'),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(
                              _targetDateTime.year, _targetDateTime.month - 1);
                          _currentMonth =
                              DateFormat.yMMM().format(_targetDateTime);
                        });
                      },
                    ),
                    TextButton(
                      child: Text('NEXT'),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(
                              _targetDateTime.year, _targetDateTime.month + 1);
                          _currentMonth =
                              DateFormat.yMMM().format(_targetDateTime);
                        });
                      },
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: _calendarCarouselNoHeader,
              ),
              //
            ],
          ),
        ));
  }

  showTasks() {
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
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: allTask?.length,
              itemBuilder: (context, i) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                " ${i + 1})  ${titleList?[i].length > 20 ? "${titleList?[i].substring(0, 19)}..." : titleList?[i]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'mplus',
                                    fontSize: 12,
                                    color: Colors.blueAccent),
                              ),
                              Text(
                                " (${categoryList?[i]})",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'mplus',
                                    fontSize: 10,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "${DateFormat.yMMMd().format(dateList![i])}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'mplus',
                                fontSize: 12,
                                color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  //  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static final Widget _eventIcon = Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blueAccent, width: 2.0)),
    child: const Icon(
      Icons.add_alert_rounded,
      color: Colors.amber,
    ),
  );
}
