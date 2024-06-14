import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';

class DiceTest extends StatefulWidget {
  const DiceTest({super.key});

  @override
  State<DiceTest> createState() => _DiceTestState();
}

class _DiceTestState extends State<DiceTest> {
  int leftDice = 1;
  int rightDice = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Dice Test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(32.0),
              child: Row(
                children: <Widget>[
                  Expanded(child: Image.asset('assets/test$leftDice.PNG')),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(child: Image.asset('assets/test$rightDice.PNG')),
                ],
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            ButtonTheme(
              minWidth: 100.0,
              height: 60.0,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent),
                  onPressed: () {
                    setState(() {
                      leftDice = Random().nextInt(3) + 1;
                      rightDice = Random().nextInt(3) + 1;
                    });
                    showToast("LeftDice: {$leftDice}, RightDice: {$rightDice}");
                  },
                  child:
                      Icon(Icons.play_arrow, size: 50.0, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM);
  print("toast msg : "+ message);
}
