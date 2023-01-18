import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          "Todo List | Task Manager",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'mplus',
            fontSize: 19,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/Icon.png',
              height: 100,
              width: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 1),
              child: Center(
                child: Text(
                  "Following features (Coming Soon)",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'mplus',
                      fontSize: 18,
                      color: Colors.blueAccent),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Center(
                child: Text(
                  "1) Save Data Online (Access From any device)",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'mplus',
                      fontSize: 13,
                      color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Center(
                child: Text(
                  "2) Dark Mode",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'mplus',
                      fontSize: 13,
                      color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Center(
                child: Text(
                  "3) Chart Date",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'mplus',
                      fontSize: 13,
                      color: Colors.grey),
                ),
              ),
            ),
            howToDelete(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment(0, 1.0),
                child: Text("ads"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  howToDelete() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width/1.1,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.blueAccent),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Quik Delete",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'mplus',
                      fontSize: 19,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network('https://imgur.com/4ZNMTPm.gif'),
              ),
            ],
          )),
    );
  }
}
