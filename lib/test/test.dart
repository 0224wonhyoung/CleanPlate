import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessgeTest extends StatelessWidget {
  const ToastMessgeTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Snack Bar"),
        centerTitle: true,
      ),
      body: Center(
        child: TextButton(
          child: Text("Toast"),
          onPressed: () {
            print("Toast Button Clicked");
            myToast();
          },
          style: TextButton.styleFrom(
              backgroundColor: Colors.green
          ),
        ),
      ),
    );
  }
}
void myToast(){
  Fluttertoast.showToast(
    msg: "Toast Msg Test",
    gravity: ToastGravity.BOTTOM_RIGHT,
    fontSize: 20.0,
    textColor: Colors.blue,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor: Colors.redAccent,

  );
}

// SacffoldMessenger.of(context) 로 구현하기
class SnackBarTest extends StatelessWidget {
  const SnackBarTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("Snack Bar"),
          centerTitle: true,
        ),
        body: Center(
          child: TextButton(
            child: Text(
              "Show me",
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Hello")));
            },
          ),
        ));
  }
}

// 따로 MySnackBar 빼서 구현하기
class SnackBarTest2 extends StatelessWidget {
  const SnackBarTest2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Snack Bar"),
        centerTitle: true,
      ),
      body: MySnackBar(),
    );
  }
}

class MySnackBar extends StatelessWidget {
  const MySnackBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
          child: Text("Show me"),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Hello",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.teal,
              duration: Duration(milliseconds: 1000),
            ));
          },
        ));
  }
}

class AppbarTest extends StatelessWidget {
  const AppbarTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appbar Icon Menu'),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              print('shopping_cart button is clicked');
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print('search button is clicked');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture:
              CircleAvatar(backgroundImage: AssetImage('assets/test.PNG')),
              accountName: Text("NameTest"),
              accountEmail: Text("Email@test.com"),
              onDetailsPressed: () {
                print("arrow is clicked");
              },
              decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0))),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.grey[850]),
              title: Text('Home'),
              onTap: () {
                print("Home is clicked");
              },
              trailing: Icon(Icons.add),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.grey[850]),
              title: Text('Setting'),
              onTap: () {
                print("Setting is clicked");
              },
              trailing: Icon(Icons.add),
            ),
            ListTile(
              leading: Icon(Icons.question_answer, color: Colors.grey[850]),
              title: Text('Q&A'),
              onTap: () {
                print("Q&A is clicked");
              },
              trailing: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

// 평범한 화면
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[800],
        appBar: AppBar(
          title: Text("Clean Plate"),
          centerTitle: true,
          backgroundColor: Colors.amber[700],
          elevation: 0.0,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 40.0, 0.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/flying.gif"),
                  radius: 60.0,
                ),
              ),
              Divider(
                height: 60.0,
                color: Colors.grey[850],
                thickness: 1.5,
                endIndent: 30.0,
              ),
              Text(
                "NAME",
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "BBRANTO",
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.0),
              Text(
                "BBRANTO POWER LEVEL",
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "14",
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Icon(Icons.check_circle_outline),
                  SizedBox(width: 10.0),
                  Text("using lightsaber",
                      style: TextStyle(
                        fontSize: 16.0,
                        letterSpacing: 1.0,
                      )),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.check_circle_outline),
                  SizedBox(width: 10.0),
                  Text("face hero tattoo",
                      style: TextStyle(
                        fontSize: 16.0,
                        letterSpacing: 1.0,
                      )),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.check_circle_outline),
                  SizedBox(width: 10.0),
                  Text("fire flames",
                      style: TextStyle(
                        fontSize: 16.0,
                        letterSpacing: 1.0,
                      )),
                ],
              ),
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/bbanto.png"),
                  radius: 40.0,
                  backgroundColor: Colors.amber[500],
                ),
              )
            ],
          ),
        ));
  }
}
