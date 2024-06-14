import 'package:flutter/material.dart';

class ScreenA extends StatelessWidget {
  const ScreenA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ScreenA"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red
                ),
                onPressed: (){
                  Navigator.pushNamed(context, '/b');
                },
                child: Text("Goto ScreenB")),
            TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.red
                ),
                onPressed: (){
                  Navigator.pushNamed(context, '/c');
                },
                child: Text("Goto ScreenC"))
          ],
        ),
      ),
    );
  }
}
