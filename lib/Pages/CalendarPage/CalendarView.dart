import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:taskreminder/Database/Constants.dart';
import 'package:taskreminder/Database/DBModel.dart';
import 'package:taskreminder/Pages/CalendarPage/CalendarView.dart';
import 'package:taskreminder/Pages/LandingPage.dart';

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
  String? category = "";
  List? timeList = [];
  var time;
  late TimeOfDay reminderTime;
  late bool isLoading = true;

  @override
  void initState() {
    addTaskToCalender();
    loadNativeAd();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  addTaskToCalender() {
    db.getBpRecord().then((value) => {
          for (int i = 0; i < value.length; i++)
            {
              if (value[i].date != "null" && value[i].isComplete == "no")
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
                        dot: Container(
                          height: 4,
                          width: 4,
                          decoration: BoxDecoration(
                              color: Colors.deepPurple.shade700,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        description: "${value[i].time}_${value[i].category}"),
                  ),
                }
            }
        });
  }

  NativeAd? nativeAd;
  bool isNativeAdLoaded = false;
  void loadNativeAd() {
    nativeAd = NativeAd(
      adUnitId: "ca-app-pub-5525086149175557/2206697644",
      factoryId: "listTileMedium",
      listener: NativeAdListener(onAdLoaded: (ad) {
        setState(() {
          isNativeAdLoaded = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        nativeAd!.dispose();
      }),
      request: AdRequest(),
    );
    nativeAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    /// Example Calendar Carousel without header and custom prev & next button
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "All Tasks",
            style: TextStyle(fontFamily: 'mplus', fontWeight: FontWeight.bold),
          ),
        ),
        body: isLoading == true
            ? const Center(
                child: Text(
                "Loading...",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 20,
                    fontFamily: 'mplus',
                    fontWeight: FontWeight.bold),
              ))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //custom icon
                    // This trailing comma makes auto-formatting nicer for build methods.
                    //custom icon without header
                    Container(
                      margin: const EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
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
                                _targetDateTime = DateTime(_targetDateTime.year,
                                    _targetDateTime.month - 1);
                                _currentMonth =
                                    DateFormat.yMMM().format(_targetDateTime);
                              });
                            },
                          ),
                          TextButton(
                            child: Text('NEXT'),
                            onPressed: () {
                              setState(() {
                                _targetDateTime = DateTime(_targetDateTime.year,
                                    _targetDateTime.month + 1);
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
                      child: CalendarCarousel<Event>(
                        todayBorderColor: Colors.white,
                        onDayPressed: (date, events) => {
                          setState(() => {_currentDate2 = date}),
                          allTask = events.toList(),
                          for (int i = 0; i < allTask!.length; i++)
                            {
                              category = allTask?[i]
                                  .description
                                  .toString()
                                  .substring(15),
                              time = allTask?[i]
                                  .description
                                  .toString()
                                  .substring(10, 15),
                              reminderTime = TimeOfDay(
                                hour: int.parse(time.split(":")[0]),
                                minute: int.parse(time.split(":")[1]),
                              ),
                              timeList!.add(formatTimeOfDay(reminderTime)),
                              titleList!.add(allTask?[i].title),
                              categoryList!.add(allTask?[i]
                                  .description
                                  .toString()
                                  .substring(17)),
                              dateList!.add(allTask?[i].date),
                              // categoryList.add(list[i].category);
                              // dateList.add(list[i].date);
                            },
                          showTasks(),
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
                        height: 300.0,
                        selectedDateTime: _currentDate2,
                        targetDateTime: _targetDateTime,
                        customGridViewPhysics: NeverScrollableScrollPhysics(),
                        markedDateCustomShapeBorder: CircleBorder(
                            side: BorderSide(color: Colors.blueAccent)),
                        markedDateCustomTextStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.blueAccent,
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
                        minSelectedDate:
                            _currentDate.subtract(Duration(days: 360)),
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
                            _currentMonth =
                                DateFormat.yMMM().format(_targetDateTime);
                          });
                        },
                        onDayLongPressed: (DateTime date) {
                          print('long pressed date $date');
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Align(
                        alignment: Alignment(0, 1.0),
                        child: isNativeAdLoaded
                            ? Container(
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          height: 300,
                          child: AdWidget(
                            ad: nativeAd!,
                          ),
                        )
                            : SizedBox(),
                      ),
                    ),
                    //
                  ],
                ),
              ));
  }

  showTasks() {
    return showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: false,
        barrierColor: Colors.red.withOpacity(0.2),
        elevation: 0,
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (context) {
          return Column(
            children: [
              Container(
                color: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Tasks",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'mplus',
                            fontSize: 17,
                            color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () => {
                          setState(() {
                            Constants.index = 1;
                          }),
                          Navigator.pushAndRemoveUntil<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) =>
                                  const LandingPage(),
                            ),
                            (route) =>
                                false, //if you want to disable back feature set to false
                          )
                        },
                        child: Text(
                          "Next>>",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'mplus',
                              fontSize: 17,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
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
                        child: Column(
                          children: [
                            Row(
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
                                    "${timeList![i]}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'mplus',
                                        fontSize: 12,
                                        color: Colors.blueAccent),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
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
