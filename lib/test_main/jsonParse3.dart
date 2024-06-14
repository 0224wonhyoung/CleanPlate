import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/test_main/addRequest.dart';
import 'package:test1/test_main/alarmService.dart';
import 'package:test1/test_main/assetImage.dart';
import 'package:test1/test_main/customDateFormat.dart';
import 'package:test1/test_main/service2.dart';
import 'package:test1/test_main/food.dart';
import 'package:test1/test_main/postTest.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:test1/test_ocr/mlKitTest.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test1/test_ocr/mlKitTestMini.dart';


class JsonParse3 extends StatefulWidget {
  String authorization;

  JsonParse3({super.key, required this.authorization});

  @override
  State<JsonParse3> createState() => _JsonParseState3();
}

class _JsonParseState3 extends State<JsonParse3> {

  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();
  late SharedPreferences _prefs;
  FlutterSecureStorage storage = FlutterSecureStorage();

  List<Food> foodList = <Food>[];
  bool loading = false;
  bool multiSelectMode = false;
  bool alarm = false;
  String userName = "";

  late TextEditingController textControllerName;
  late TextEditingController textControllerDate;

  void printList(){
    print("현재 Food List 상태");
    for(int i=0; i<foodList.length; i++) {
      print('[' + foodList[i].id.toString()  + ']번 음식 이름: ' + foodList[i].foodName + ', 분류: '+ foodList[i].category + ', 소비기한: ' +
          foodList[i].expiration.toString() + ', 수량: ' + foodList[i].quantity.toString() + ', Strorage: ' + foodList[i].storage );
    }
  }

  @override
  void initState() {
    super.initState();
    print("JsonParse3 with 인증키 : " + widget.authorization);

    Services.getInfo(widget.authorization).then((value){
      setState(() {
        foodList = value;
        loading = true;
        printList();
      });
    });
    textControllerName = TextEditingController();
    textControllerDate = TextEditingController();
    multiSelectMode = false;
    resetSelect();

    _permissionWithNotification();
    _permissionInitialization();
    _initSharedPreferences();
    _getUserName();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      alarm = _prefs.getBool('alarm') ?? false;
    });
  }

  void dispose() {
    textControllerName.dispose();
    textControllerDate.dispose();
    super.dispose();
  }

  void reset(){
    Services.getInfo(widget.authorization).then((value){
      setState(() {
        foodList = value;
        loading = true;
        printList();
      });
    });
  }

  void resetSelect(){
    for (Food a in foodList){
      a.selected = false;
    }
  }

  void _addFood(String name, String date, int count, String category ) {
    //TODO send json
    print("_addFood start");
    // Food newFood = Food.clone(foodList[0]);
    // newFood.foodName = name;
    // newFood.expiration = DateTime.parse(date);
    // newFood.quantity = count;

    addRequest(name, count, category, date, widget.authorization).then((value)
    {
      reset();
    });
  }

  void _permissionWithNotification() async {
    if (await Permission.notification.isDenied &&
        !await Permission.notification.isPermanentlyDenied) {
      await [Permission.notification].request();
    }
  }

  void _permissionInitialization() async {
    AndroidInitializationSettings android =
    const AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings ios = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings settings =
    InitializationSettings(android: android, iOS: ios);
    await _local.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        if (details.payload != null) {
          print("Alarm Clicked PayLoad: "  + details.payload.toString());
          Navigator.pushNamed(context, '/alarm',arguments: widget.authorization);
        }
      },
    );

  }

  void _getUserName() async{
    print("start getUserName");
    String? name = await storage.read(key: "cpName");
    if(name != null){
      print("user name : " + name);
    }
    else{
      print("user name NULL");
    }
    userName = (name!= null) ? name : "로딩중..";
  }

  @override
  Widget build(BuildContext context) {
    // final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    // print("화면 넘어서 받은 인증키 : " + arguments['authorization'].toString());
    // widget.authorization = arguments['authorization'].toString();

    return Scaffold(
        appBar: AppBar(
          title: Text(loading ? '보관함' : 'Loading...'),
          centerTitle: true,

          actions: <Widget>[
            IconButton(
              icon: alarm ? Icon(FontAwesomeIcons.bell) : Icon(FontAwesomeIcons.bellSlash),
              onPressed: () {
                setState(() {
                  print("Alarm was : " + alarm.toString());
                  if(alarm){
                    alarm = false;
                    _prefs.setBool("alarm", alarm);
                  }
                  else{
                    alarm = true;
                    _prefs.setBool("alarm", alarm);
                    _permissionWithNotification();
                    alarmRequest(widget.authorization, _local, _prefs);
                  }
                });

              },
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          color: Colors.grey[600],
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 15.0,
                  childAspectRatio: 4/5.5 ),
              itemCount: foodList.length,
              itemBuilder: (context, index) {
                Food food = foodList[index];
                return MyFoodContainer(
                  foodList: foodList,
                  index: index,
                  authorization : widget.authorization,

                );
              }),
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          visible: !multiSelectMode,

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
                // TODO not foodList[0], default
                Food newFood = new Food(id: 0, foodName: "", quantity: 1, category: "육류", storage: "냉장", expiration: DateTime.now(), createdAt: DateTime.now(), createdBy: "", modifiedAt: DateTime.now(), modifiedBy: "");
                final result = await _showCustomDialog(context, newFood, textControllerName, textControllerDate, true, 0);
                if (result["type"] == "ok"){
                  setState(() {
                    print("Get message type OK");
                    print(result["name"]);
                    print(result["date"]);
                    print(result["count"]);
                    print(result["category"]);

                    _addFood(result["name"], result["date"], result["count"], result["category"]);
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
                // TODO not foodList[0], default
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MLKitTest2()),
                );
                if (result != null){
                  print("Get Message From ML KIT (CAMERA)");
                  setState(() {
                    List<CustomPack> c = result;
                    for (CustomPack elements in c){
                      _addFood(elements.name, dateFromDateTime(DateTime.now().add(Duration(days:90))), elements.quantity, "기타");
                    }
                  });
                }
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.search),
              label: "레시피검색",
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 14.0,
              ),
              backgroundColor: Colors.indigo.shade700,
              labelBackgroundColor: Colors.indigo.shade700,
              onTap: () async{
                setState(() {
                  print("hereeeeeeee55");
                  multiSelectMode = true;
                  resetSelect();
                });
              },
            ),
            SpeedDialChild(
              child: FaIcon(FontAwesomeIcons.exclamation),
              label: "알람",
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 14.0,
              ),
              backgroundColor: Colors.indigo.shade700,
              labelBackgroundColor: Colors.indigo.shade700,
              onTap: () async{
                Navigator.pushNamed(context, '/alarm', arguments: widget.authorization);
              },
            ),
          ],
        ),
      bottomNavigationBar: Visibility(
        visible: multiSelectMode,
        child: SizedBox(
          width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("음식을 선택해 주세요",),
                TextButton(
                    onPressed: (){
                      //print(selectedFood);
                      setState(() {
                        List<String> selectedFoodList = [];
                        for(Food a in foodList){
                          if (a.selected){
                            selectedFoodList.add(a.foodName);
                          }
                        }
                        Navigator.pushNamed(
                            context, '/recipe', arguments: {
                              "foodList" : selectedFoodList,
                              "authorization" : widget.authorization
                        });
                        multiSelectMode = false;
                        resetSelect();
                      });
                    },
                    child: Text("확인"),
                ),
                TextButton(
                    onPressed: (){
                      //print(selectedFood);
                      setState(() {
                        multiSelectMode = false;
                        resetSelect();
                      });
                    },
                    child: Text("취소"),
                ),
              ],
            )
        ),
      ),
      drawer: Container(
        padding: EdgeInsets.all(5),
        width: 220,
        child: Drawer(
          child: ListView(
            children: [
              SizedBox(height: 30),
              Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.account_circle, size: 30),
                  SizedBox(width: 10),
                  Text(userName, style: TextStyle(fontSize: 20),),
                ],
              ),
              TextButton(
                child: Text("로그아웃"),
                onPressed: (){
                  storage.delete(key: 'cplogin');
                  storage.delete(key: 'cpName');
                  Navigator.pushNamed(context, '/login');
                },
              )
            ],
          ),
        ),

      ),
    );
  }
}


// =============================================================================================================================================
// =============================================================================================================================================
// =============================================================================================================================================


class MyFoodContainer extends StatefulWidget {
  List<Food> foodList;
  int index;
  String authorization;

  MyFoodContainer({super.key, required this.foodList, required this.index, required this.authorization,});

  @override
  State<MyFoodContainer> createState() => _MyFoodContainerState();
}

class _MyFoodContainerState extends State<MyFoodContainer> {
  late TextEditingController textControllerName;
  late TextEditingController textControllerDate;
  int dday = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print('food name is ' + widget.foodList[widget.index].foodName);
    Food food = widget.foodList[widget.index];
    textControllerName =
        TextEditingController(text:food.foodName);
    textControllerDate =
        TextEditingController(text: dateFromDateTime(food.expiration));
    dday = dDayCalc(food.expiration);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textControllerName.dispose();
    textControllerDate.dispose();
    super.dispose();
  }

  int dDayCalc(DateTime to) {
    DateTime now = DateTime.now();
    DateTime n = DateTime(now.year, now.month, now.day);

    return to.difference(n).inDays;
  }

  @override
  Widget build(BuildContext context) {
    Food food = widget.foodList[widget.index];

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          minimumSize: Size(60, 200),
          padding: const EdgeInsets.all(3),
          backgroundColor: Colors.white,
          side: BorderSide(
            color: widget.foodList[widget.index].selected ? (Colors.orange) : (Colors.white),
            width : widget.foodList[widget.index].selected ? 3.0 : 1.0,
          ),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Column(
        children: [
          Image.asset(
            // TODO have to use category String -> image matching
            CustomAssetImage.imagePath[food.category],
            //'assets/food${(food.createdAt.hour % 4) + 1}.png',
            width: 50.0,
            height: 50.0,
          ),
          Text(
            food.foodName,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          Text(
            "D-" + dday.toString(),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
              color: dday < 0 ? Colors.red : ( dday < 3 ? Colors.orange : Colors.black)
            ),
          ),

        ],
      ),
      onPressed: () async {
        print('${widget.index} is clicked, '+ widget.foodList[widget.index].foodName);

        _JsonParseState3? p = context.findAncestorStateOfType<_JsonParseState3>();
        if(p is _JsonParseState3){
          print("hereeeee 1");
          // MultiSelcetMode
          if(p.multiSelectMode == true){
            print("hereeeee 2");
            //Todo add at list + some changes
            setState(() {
              widget.foodList[widget.index].selected = !widget.foodList[widget.index].selected;
            });
          }

          // MultiSelcetMode가 아니라 평범한 1개의 선택된 음식 수정모드
          else{
            print("hereeeee 3");
            textControllerName.text = widget.foodList[widget.index].foodName;
            textControllerDate.text = dateFromDateTime(widget.foodList[widget.index].expiration);
            final result = await _showCustomDialog(context, food,
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
          }
        }

      },
    );
  }

  void _deleteFood(BuildContext context, int index){
    //TODO send json
    deleteRequest(widget.foodList[widget.index].id, widget.authorization).then((value){
      _JsonParseState3? p = context.findAncestorStateOfType<_JsonParseState3>();
      p?.reset();
    });

    // _JsonParseState3? p = context.findAncestorStateOfType<_JsonParseState3>();
    // if(p!=null){
    //   p.setState(() {
    //     print ("_deleteFood, $index");
    //     widget.foodList.removeAt(index);
    //   });
    // }
  }

  void _modifyFood(String name, String date, int count) {
    //TODO send json
    // print('기존 : ' +
    //     widget.foodList[widget.index].name +
    //     ', ' +
    //     widget.foodList[widget.index].email +
    //     ', ' +
    //     widget.foodList[widget.index].id.toString());
    modifyRequest(name, date, "채소", count, widget.foodList[widget.index].id, widget.authorization).then((value){
      _JsonParseState3? p = context.findAncestorStateOfType<_JsonParseState3>();
      p?.reset();
    });
    // widget.foodList[widget.index].foodName = name;
    // widget.foodList[widget.index].expiration = DateTime.parse(date);
    // widget.foodList[widget.index].quantity = count;
    // print('수정후 : ' +
    //     widget.foodList[widget.index].name +
    //     ', ' +
    //     widget.foodList[widget.index].email +
    //     ', ' +
    //     widget.foodList[widget.index].id.toString());
  }
  // void setMultiSelectMode(bool b){
  //   _JsonParseState3? p = context.findAncestorStateOfType<_JsonParseState3>();
  //   if(p is _JsonParseState3){
  //     p.setMultiSelectMode(b);
  //   }
  // }
  //
  // void revMultiSelectMode(){
  //   _JsonParseState3? p = context.findAncestorStateOfType<_JsonParseState3>();
  //   if(p is _JsonParseState3){
  //     p.revMultiSelectMode();
  //   }
  // }

}


//==============================================================================================================================
//==============================================================================================================================

Future _showCustomDialog(
    BuildContext context,
    Food food,
    TextEditingController textControllerName,
    TextEditingController textControllerDate,
    bool add,
    int index) async {
  String currentDatetime = "";
  int count = food.quantity;
  String currentCategory = food.category;
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              title: Text(
                (add? "음식 추가" : food.foodName),
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
                        child: GestureDetector(
                          child: Image.asset(
                            // TODO have to use category String -> image matching
                            CustomAssetImage.imagePath[currentCategory],
                            width: 80.0,
                            height: 80.0,
                          ),
                          onTap: () async{
                            final result = await showDialog(
                                context: context,
                                builder: (context) {
                                  print("총 이미지 개수 : " + CustomAssetImage.imagePath.length.toString());
                                  return AlertDialog(
                                    content: SizedBox(
                                      width: 350,
                                      height: 150,
                                      child: GridView.builder(
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                              mainAxisSpacing: 10.0,
                                              //crossAxisSpacing: 10.0
                                              ),
                                          itemCount: CustomAssetImage.imagePath.length,
                                          itemBuilder: (context, index) {
                                            return  GestureDetector(
                                                child: SizedBox(
                                                  width: 50,
                                                  height: 200,
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        CustomAssetImage.pathFromInt(index+1),
                                                        width: 40.0,
                                                        height: 40.0,
                                                      ),
                                                      Text(CustomAssetImage.categoryName[index],),
                                                    ],
                                                  ),
                                                ),
                                                onTap: (){
                                                  Navigator.pop(context, {"category": CustomAssetImage.categoryName[index], });
                                                }
                                            );
                                          }),
                                    ),
                                  );
                            });
                            if(result != null){
                              setState(() {
                                currentCategory = result["category"];
                              });
                            }
                          },
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
                              //Text(food.name, style: TextStyle(backgroundColor: Colors.yellowAccent[100]),),
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
                    readOnly: true,
                    onTap: () async{
                      print("Today : " + DateTime.now().toString());
                      print(textControllerDate.text);
                      //print(DateTime.parse(textControllerDate.text));
                      final selectedDate = await showDatePicker(
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          context: context,
                          initialDate: add ? (DateTime.now()) : (DateTime.parse(textControllerDate.text)),
                          firstDate: DateTime(DateTime.now().year - 1),
                          lastDate: DateTime(DateTime.now().year + 2),
                        locale: const Locale('ko', 'KR'),
                      );
                      if(selectedDate != null){
                        textControllerDate.text = dateFromDateTime(selectedDate);
                      }
                    }
                    ,
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
                            "category": currentCategory,
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


class MultiSelectItem<T> {
  T value;
  bool selected = false;
  MultiSelectItem(this.value);
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