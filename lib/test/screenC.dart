import 'package:flutter/material.dart';

class ScreenC extends StatelessWidget {
  const ScreenC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ScreenC"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.red
                ),
                onPressed: (){
                  Navigator.pushNamed(context, '/');
                },
                child: Text("Goto ScreenA")),
            TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.red
                ),
                onPressed: (){
                  Navigator.pushNamed(context, '/b');
                },
                child: Text("Goto ScreenB"))
          ],
        ),
      ),
    );
  }
}
