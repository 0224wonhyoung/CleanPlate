import 'package:flutter/material.dart';

class ScreenB extends StatelessWidget {
  const ScreenB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ScreenB"),
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
                  Navigator.pushNamed(context, '/c');
                },
                child: Text("Goto ScreenC"))
          ],
        ),
      ),
    );
  }
}
