import 'package:flutter/material.dart';

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
                      Padding(
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
}
