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


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Text(
              'Task Name',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontFamily: 'cute',
                fontSize: 16.0,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 65,
              padding: EdgeInsets.only(left: 50, right: 50),
              child: TextField(
                controller: taskController,
                maxLength: 50,
                autofocus: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textCapitalization: TextCapitalization.sentences,
                onChanged: (newVal) {
                  taskName = newVal;
                },
                decoration: InputDecoration(
                  fillColor: Colors.blue.shade50,
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide:
                    new BorderSide(color: Colors.blue.shade700, width: 1),
                  ),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide:
                    new BorderSide(color: Colors.blue.shade700, width: 1),
                  ),
                  labelText: ' Task',
                  labelStyle: TextStyle(
                    fontFamily: "Cutes",
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                    fontSize: 10,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
