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

  final EventList<Event> _markedDateMap = EventList<Event>(events: {});

  @override
  void initState() {

    /// Add more events to _markedDateMap EventList
    // _markedDateMap.add(
    //     DateTime(2023, 1, 1),
    //     Event(
    //       date: DateTime(2023, 1, 1),
    //       title: 'Event 5',
    //       icon: _eventIcon,
    //     ));

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
                          int.parse(value[i].date.substring(8, 10),),),
                      Event(
                        date:  DateTime(
                          int.parse(value[i].date.substring(0, 4)),
                          int.parse(value[i].date.substring(5, 7)),
                          int.parse(value[i].date.substring(8, 10),),),
                        title: value[i].task,
                        icon: _eventIcon,

                      )),
                }
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    /// Example Calendar Carousel without header and custom prev & next button
    final _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.white,
      onDayPressed: (date, events) {
        this.setState(() => _currentDate2 = date);
        events.forEach((event) => print(event.title));
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
          CircleBorder(side: BorderSide(color: Colors.yellow)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      // markedDateShowIcon: true,
      // markedDateIconMaxShown: 2,
      // markedDateIconBuilder: (event) {
      //   return event.icon;
      // },
      // markedDateMoreShowTotal:
      //     true,
      todayButtonColor: Colors.yellow,
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
          title: Text("Task"),
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
}
