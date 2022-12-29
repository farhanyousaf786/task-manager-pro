
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:taskreminder/Pages/AddTaskPage/AddTask.dart';

class NoTask extends StatelessWidget {
  const NoTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,

      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Lottie.asset('assets/taskMan.json'),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () => {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context)
                                  .viewInsets
                                  .bottom),
                          child: AddTask(),
                        ),
                      ),
                    )
                  },
                  child: const Text(
                    "Click + to Add Task",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'mplus'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
