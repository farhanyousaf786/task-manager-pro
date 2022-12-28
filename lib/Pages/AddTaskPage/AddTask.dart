import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:popover/popover.dart';
import 'package:taskreminder/Components/SubTaskElement.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  //text field that input task name
  var subTaskList = <TextEditingController>[];
  final taskController = TextEditingController();
  String categoryName = 'No Category';
  String subTask = "";
  var cards = <Card>[];
  DateTime? reminderDate;
  TimeOfDay? reminderTime;

  Card createCard() {
    var subCatController = TextEditingController();
    subTaskList.add(subCatController);
    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.4,
          child: TextField(
            controller: subCatController,
            decoration: InputDecoration(
              fillColor: Colors.grey.shade100,
              isDense: true,
              border: InputBorder.none,
              filled: true,
              hintText: 'Sub Task ${cards.length + 1}',
              hintStyle: TextStyle(
                fontFamily: "mplus",
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  dataAndTimePicker() async {
    reminderDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    ))!;
    reminderTime =
        (await showTimePicker(context: context, initialTime: TimeOfDay.now()))!;
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  _onDone() {
    if (cards.isNotEmpty) {
      for (int i = 0; i < cards.length; i++) {
        // give Flag _F_ into string so when we retrieve it
        // it makes us easy to separate each task
        subTask = "${subTask}_F_${subTaskList[i].text}";
      }
    }
    if (cards.isEmpty) {
      subTask = "N/A";
    }
    print(">>> Sub Task: $subTask");
    print("Task Controller: ${taskController.text}");
    print("Category: ${categoryName}");
    print("Date: ${reminderDate.toString()}");
    print("Time: ${reminderTime.toString()}");

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 70,
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                controller: taskController,
                autofocus: true,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  isDense: true,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  filled: true,
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  labelText: 'My Task',
                  labelStyle: TextStyle(
                    fontFamily: "mplus",
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            reminderTime == null
                ? SizedBox(
                    height: 0,
                    width: 0,
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.blue.shade50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text(
                              "Reminder: ",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'mplus'),
                            ),
                          ),
                          Container(
                              child: Text(
                            DateFormat.yMMMd().format(reminderDate!) + "  ",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'mplus'),
                          )),
                          Container(
                            child: Text(
                              formatTimeOfDay(reminderTime!) + "    ",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontFamily: 'mplus'),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                reminderTime = null;
                                reminderTime = null;
                              });
                            },
                            child: Icon(
                              Icons.clear,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            SizedBox(
              height: cards.isEmpty
                  ? 0
                  : cards.length < 3
                      ? 100
                      : 200,
              child: ListView.builder(
                itemCount: cards.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        cards[index],
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                              onPressed: () => {
                                    cards.removeAt(index),
                                    setState(() {}),
                                  },
                              icon: Icon(
                                Icons.clear,
                                color: Colors.grey,
                              )),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
                right: 8,
                left: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _subTask();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 22),
                          child: Container(
                            child: Text(
                              categoryName,
                              style: TextStyle(
                                fontFamily: 'mplus',
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                                color: categoryName == 'No Category'
                                    ? Colors.blue
                                    : Colors.green,
                              ),
                            ),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: categoryName == 'No Category'
                                    ? Colors.blue
                                    : Colors.green,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => {setState(() => cards.add(createCard()))},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Add Sub Task",
                              style: TextStyle(
                                  fontFamily: 'mplus',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => {dataAndTimePicker()},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.green
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Reminder ",
                                  style: TextStyle(
                                      fontFamily: 'mplus',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                      color: Colors.green),
                                ),
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.green.shade700,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => {
                            _onDone(),
                          },
                          child: Icon(
                            Icons.send_outlined,
                            color: Colors.blue,
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _subTask() {
    showPopover(
      shadow: <BoxShadow>[
        BoxShadow(
          color: Colors.transparent,
          blurRadius: 0,
          offset: Offset(0, 0),
        ),
      ],

        context: context,
        bodyBuilder: (context) => SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        categoryName = "Work";
                      }),
                      Navigator.pop(context),
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Work",
                        style: TextStyle(
                            fontFamily: 'mplus',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        categoryName = "Personal";
                      }),
                      print(categoryName),
                      Navigator.pop(context),
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Personal",
                        style: TextStyle(
                            fontFamily: 'mplus',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        categoryName = "Watchlist";
                      }),
                      print(categoryName),
                      Navigator.pop(context),
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Watchlist",
                        style: TextStyle(
                            fontFamily: 'mplus',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        categoryName = "Birthday";
                      }),
                      print(categoryName),
                      Navigator.pop(context),
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Birthday",
                        style: TextStyle(
                            fontFamily: 'mplus',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        categoryName = "Urgent";
                      }),
                      print(categoryName),
                      Navigator.pop(context),
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Urgent",
                        style: TextStyle(
                            fontFamily: 'mplus',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        categoryName = "Important";
                      }),
                      print(categoryName),
                      Navigator.pop(context),
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Important",
                        style: TextStyle(
                            fontFamily: 'mplus',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        categoryName = "Home";
                      }),
                      print(categoryName),
                      Navigator.pop(context),
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Home",
                        style: TextStyle(
                            fontFamily: 'mplus',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        categoryName = "Others";
                      }),
                      print(categoryName),
                      Navigator.pop(context),
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Others",
                        style: TextStyle(
                            fontFamily: 'mplus',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        onPop: () => print('Popover was popped!'),
        direction: PopoverDirection.bottom,
        width: 120,
        height: MediaQuery.of(context).size.height / 3,
        arrowHeight: 15,
        arrowWidth: 25,
        backgroundColor: Colors.white,
        barrierColor: Colors.transparent,
        transitionDuration: Duration(milliseconds: 500));
  }
}
