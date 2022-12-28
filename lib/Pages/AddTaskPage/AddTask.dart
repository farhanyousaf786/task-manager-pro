import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  //text field that input task name
  final taskController = TextEditingController();

  // task name store in string
  String taskName = '';
  String categoryName = 'No Category';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Container(
              height: 70,
              padding: EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                controller: taskController,
                autofocus: true,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textCapitalization: TextCapitalization.sentences,
                onChanged: (newVal) {
                  taskName = newVal;
                },
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: new BorderSide(color: Colors.grey, width: 1),
                  ),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: new BorderSide(color: Colors.grey, width: 1),
                  ),
                  labelText: 'Enter Task Name',
                  labelStyle: TextStyle(
                    fontFamily: "mplus",
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
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
                                    ? Colors.grey
                                    : Colors.blue,
                              ),
                            ),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      Padding(
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
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.send_outlined,
                        color: Colors.blue,
                        size: 25,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _subTask() {
    showPopover(
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
                    onTap: ()=>{ setState(() {
                      categoryName = "Urgent";
                    }),
                      print(categoryName),
                      Navigator.pop(context),},
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
                    onTap: ()=>{ setState(() {
                      categoryName = "Important";
                    }),
                      print(categoryName),
                      Navigator.pop(context),},
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
                    onTap: ()=>{ setState(() {
                      categoryName = "Home";
                    }),
                      print(categoryName),
                      Navigator.pop(context),},
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
                    onTap: ()=>{ setState(() {
                      categoryName = "Others";
                    }),
                      print(categoryName),
                      Navigator.pop(context),},
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
