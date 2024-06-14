import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:test1/test_json/service.dart';
import 'package:test1/test_json/user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test1/test_ocr/mlKitTest.dart';

class JsonParse2 extends StatefulWidget {
  const JsonParse2({super.key});

  @override
  State<JsonParse2> createState() => _JsonParseState2();
}

class _JsonParseState2 extends State<JsonParse2> {
  List<User> userList = <User>[];
  bool loading = false;
  late TextEditingController textControllerName;
  late TextEditingController textControllerDate;

  @override
  void initState() {
    super.initState();
    Services.getInfo().then((value) {
      setState(() {
        userList = value;
        loading = true;
      });
    });
    textControllerName = TextEditingController();
    textControllerDate = TextEditingController();
  }

  void dispose() {
    textControllerName.dispose();
    textControllerDate.dispose();
    super.dispose();
  }

  void _addFood(String name, String date, int count) {
    //TODO send json
    setState(() {
      User newUser = User.clone(userList[0]);
      newUser.name = name;
      newUser.email = date;
      newUser.id = count;
      userList.add(newUser);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loading ? '냉장고' : 'Loading...'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        color: Colors.grey[600],
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 15.0,
                childAspectRatio: 4/4.4 ),
            itemCount: userList.length,
            itemBuilder: (context, index) {
              User user = userList[index];
              return MyFoodContainer(
                userList: userList,
                index: index,
              );
            }),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        visible: true,
        curve: Curves.bounceIn,
        backgroundColor: Colors.indigo.shade700,
        children: [
          SpeedDialChild(
            child: Icon(FontAwesomeIcons.penToSquare),
            label: "입력",
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 14.0,
            ),
            backgroundColor: Colors.indigo.shade700,
            labelBackgroundColor: Colors.indigo.shade700,
            onTap: () async{
              // TODO not userList[0], default
              final result = await _showCustomDialog(context, userList[0] , textControllerName, textControllerDate, true, 0);
              if (result["type"] == "ok"){
                setState(() {
                  print("Get message type OK");
                  _addFood(result["name"], result["date"], result["count"]);
                });
              }
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.photo_camera),
            label: "카메라",
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 14.0,
            ),
            backgroundColor: Colors.indigo.shade700,
            labelBackgroundColor: Colors.indigo.shade700,
            onTap: () async{
              // TODO not userList[0], default
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MLKitTest()),
              );
              if (result != null){
                print("Get Message From ML KIT (CAMERA)");
                setState(() {
                  List<CustomPack> c = result;
                  for (CustomPack elements in c){
                    _addFood(elements.name, "20240524", elements.quantity);
                  }
                });
              }
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.refresh),
            label: "레시피추천",
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 14.0,
            ),
            backgroundColor: Colors.indigo.shade700,
            labelBackgroundColor: Colors.indigo.shade700,
            onTap: () async{
              setState(() {
              });
            },
          ),

        ],

      )

    );
  }
}

class MyFoodContainer extends StatefulWidget {
  List<User> userList;
  int index;

  MyFoodContainer({super.key, required this.userList, required this.index});

  @override
  State<MyFoodContainer> createState() => _MyFoodContainerState();
}

class _MyFoodContainerState extends State<MyFoodContainer> {
  late TextEditingController textControllerName;
  late TextEditingController textControllerDate;

  @override
  void initState() {
    super.initState();
    print('user name is ' + widget.userList[widget.index].name);
    textControllerName =
        TextEditingController(text: widget.userList[widget.index].name);
    textControllerDate =
        TextEditingController(text: widget.userList[widget.index].email);

  }

  @override
  void dispose() {
    textControllerName.dispose();
    textControllerDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.userList[widget.index];

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(60, 200),
          padding: const EdgeInsets.all(3),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Column(
        children: [
          Image.asset(
            'assets/food${(user.phone.length % 4) + 1}.png',
            width: 50.0,
            height: 50.0,
          ),
          Text(
            user.name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ],
      ),
      onPressed: () async {
        print('${widget.index} is clicked, '+ widget.userList[widget.index].name);
        textControllerName.text = widget.userList[widget.index].name;
        textControllerDate.text = widget.userList[widget.index].email;
        final result = await _showCustomDialog(context, user,
            textControllerName, textControllerDate, false, widget.index);
        if (result["type"] == "ok") {
          setState(() {
            _modifyFood(result['name'], result['date'], result['count']);
          });
        }
        else if(result["type"] == "delete"){
          int i = result["index"];
          print("Get message type DELETE, $i");
          setState(() {
            _deleteFood(context, result["index"]);
          });
        }
        print(result['name']);
      },
    );
  }

  void _deleteFood(BuildContext context, int index){
    //TODO send json
    _JsonParseState2? p = context.findAncestorStateOfType<_JsonParseState2>();
    if(p!=null){
      p.setState(() {
        print ("_deleteFood, $index");
        widget.userList.removeAt(index);
      });
    }
  }

  void _modifyFood(String name, String date, int count) {
    //TODO send json

    widget.userList[widget.index].name = name;
    widget.userList[widget.index].email = date;
    widget.userList[widget.index].id = count;

  }
}

Future _showCustomDialog(
    BuildContext context,
    User user,
    TextEditingController textControllerName,
    TextEditingController textControllerDate,
    bool add,
    int index) async {
  int count = user.id;
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),

              title: Text(
                (add? "음식 추가" : user.name),
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Image.asset(
                          'assets/food${(user.phone.length % 4) + 1}.png',
                          width: 80.0,
                          height: 80.0,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextField(
                                controller: textControllerName,
                                autofocus: false,
                                decoration: InputDecoration(
                                    enabledBorder: myInputBorder(),
                                    focusedBorder: myFocusBorder(),
                                    labelText: "이름"),
                              ),
                              //Text(user.name, style: TextStyle(backgroundColor: Colors.yellowAccent[100]),),
                              const SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  const Text("수량"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (count > 0) count--;
                                        });
                                      },
                                      child: FaIcon(
                                        FontAwesomeIcons.minus,
                                        color: Colors.white,
                                        size: 13,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          fixedSize: Size(10, 10),
                                          shape: CircleBorder(),
                                          backgroundColor: Colors.blue)),
                                  Text(
                                    "$count",
                                    style: TextStyle(
                                        fontSize: 20, wordSpacing: 0.9),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (count < 99) count++;
                                        });
                                      },
                                      child: FaIcon(
                                        FontAwesomeIcons.plus,
                                        color: Colors.white,
                                        size: 13,
                                      ),
                                      //FaIcon(FontAwesomeIcons.minus,  color: Colors.white, size:15),
                                      style: ElevatedButton.styleFrom(
                                          fixedSize: Size(10, 10),
                                          shape: CircleBorder(),
                                          backgroundColor: Colors.blue)),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: textControllerDate,
                    autofocus: false,
                    decoration: InputDecoration(
                        enabledBorder: myInputBorder(),
                        focusedBorder: myFocusBorder(),
                        prefixIcon: Icon(Icons.date_range),
                        labelText: "소비기한"),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          //TODO 수정 구현
                          print('적용 is clicked');
                          Navigator.pop(context, {
                            "name": textControllerName.text,
                            "date": textControllerDate.text,
                            "count": count,
                            "type": "ok"
                          });
                        },
                        child: const Text('적용'),
                      ),
                      TextButton(
                        onPressed: () {
                          print('취소 is clicked');
                          Navigator.pop(context, {"type": "cancel"});
                        },
                        child: const Text('취소'),
                      ),
                      if(!add)...{
                        TextButton(
                          onPressed: () {
                            print('삭제 is clicked, $index');
                            Navigator.pop(context, {
                              "type": "delete",
                              "index": index});
                          },
                          child: const Text('삭제'),
                        )
                      }

                    ],
                  ),
                ],
              ),
            );
          },
        );
      });
}

OutlineInputBorder myInputBorder() {
  //return type is OutlineInputBorder
  return const OutlineInputBorder(
      //Outline border type for TextFeild
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        color: Colors.redAccent,
        width: 3,
      ));
}

OutlineInputBorder myFocusBorder() {
  return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        color: Colors.greenAccent,
        width: 3,
      ));
}
