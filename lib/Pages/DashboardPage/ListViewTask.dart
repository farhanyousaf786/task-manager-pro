import 'package:flutter/material.dart';

class ListViewTask extends StatefulWidget {
  const ListViewTask({Key? key}) : super(key: key);

  @override
  State<ListViewTask> createState() => _ListViewTaskState();
}

class _ListViewTaskState extends State<ListViewTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text("Lists"),
    );
  }
}
