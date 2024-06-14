import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test1/test_main/addRequest.dart';
import 'package:test1/test_main/alarmService.dart';

class AlarmRecipe extends StatefulWidget {
  String authorization;
  AlarmRecipe({super.key, required this.authorization});

  @override
  State<AlarmRecipe> createState() => _AlarmRecipeState();
}

class _AlarmRecipeState extends State<AlarmRecipe> {
  List<String> foodList = [];
  String recipe = "";
  bool loading = false;

  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    foodList = [""];
    recipe = "";
    alarmRequest2(widget.authorization).then((CustomData value){
      setState(() {
        loading = false;
        foodList = value.foodList;
        recipe = value.recipe;
        print("=======foodList========");
        print(foodList);
        print("=======recipe========");
        print(recipe);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('레시피 추천'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10,10,10,20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("알람", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              SizedBox(height:7),
              ListView.builder(
                shrinkWrap: true,
                //TODO 임시로 max 지정해놓은거 풀어아햠.
                itemCount: min(foodList.length, 2),
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    visualDensity: VisualDensity(vertical: -3),
                    leading: FaIcon(FontAwesomeIcons.circleExclamation),
                    title: Text(foodList[index], style: TextStyle(fontSize: 18)),
                  );
                },
              ),
              SizedBox(height:12),
              Text("레시피", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              SizedBox(height:7),
              Text(loading ? "로딩중..." : recipe, style: TextStyle(fontSize: 18)),
            ],
          ),

        ),

    );
  }
}

