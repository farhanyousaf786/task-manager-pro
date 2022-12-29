import 'package:flutter/material.dart';
import 'package:taskreminder/Pages/AboutPage/AboutPage.dart';
import 'package:taskreminder/Pages/CalendarPage/CalendarView.dart';
import 'package:taskreminder/Pages/DashboardPage/ListViewTask.dart';
import 'package:taskreminder/Pages/AddTaskPage/AddTask.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int pageIndex = 0;

  // all pages to add on bottom bar
  final pages = [
    const ListViewTask(),
    const CalendarViewTask(),
    const AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffC4DFCB),
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              context: context,
              builder: (context) => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: AddTask(),
                ),
              ),
            );
          },
          backgroundColor: Colors.lightBlue,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 0;
                  });
                },
                icon: pageIndex == 0
                    ? const Icon(
                        Icons.view_list_sharp,
                        color: Colors.white,
                        size: 25,
                      )
                    : const Icon(
                        Icons.view_list_outlined,
                        color: Colors.white,
                        size: 25,
                      ),
              ),
              const Text(
                "Tasks",
                style: TextStyle(
                    fontFamily: 'mplus',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              )
            ],
          ),
          Column(
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 1;
                  });
                },
                icon: pageIndex == 1
                    ? const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                        size: 25,
                      )
                    : const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.white,
                        size: 25,
                      ),
              ),
              const Text(
                "Calender",
                style: TextStyle(
                    fontFamily: 'mplus',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              )
            ],
          ),
          Column(
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 2;
                  });
                },
                icon: pageIndex == 2
                    ? const Icon(
                        Icons.info,
                        color: Colors.white,
                        size: 25,
                      )
                    : const Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 25,
                      ),
              ),
              const Text(
                "INFO",
                style: TextStyle(
                    fontFamily: 'mplus',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              )
            ],
          ),
        ],
      ),
    );
  }
}
