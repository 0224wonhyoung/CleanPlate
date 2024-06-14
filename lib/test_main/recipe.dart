import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test1/test_main/addRequest.dart';

class Recipe extends StatefulWidget {
  List<String> foodList;
  String authorization;

  Recipe({super.key, required this.foodList, required this.authorization});

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {

  final type = ['한식', '중식', '일식', '양식',];
  String selectedType = '';
  List<String> conditionList = [];
  String recipe = "";
  bool loading = false;
  TextEditingController editingController = TextEditingController();

  void initState() {
    // TODO: implement initState
    super.initState();
    selectedType = type[0];
    loading = false;
  }

  String foodListString(){
    String result = "";
    for (String s in widget.foodList){
      result = result + s;
    }
    return result;
  }

  void addCondition(String s){
    setState(() {
      conditionList.add(s);
    });
  }

  void setRecipe(String s){
    setState(() {
      recipe = s;
    });
  }

  void removeCondition(int i){
    setState(() {
      conditionList.removeAt(i);
    });
  }

  void setLoading(){
    setState(() {
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showFAB = MediaQuery.of(context).viewInsets.bottom==0.0;
    return Scaffold(
        appBar: AppBar(
          title: Text('레시피 추천'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10,10,10,20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("음식", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              SizedBox(height:7),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.foodList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    visualDensity: VisualDensity(vertical: -3),
                    leading: Icon(Icons.check),
                    title: Text(widget.foodList[index], style: TextStyle(fontSize: 18)),
                  );
                },
              ),
              SizedBox(height:12),
              Text("종류", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              SizedBox(height:7),
              Row(
                children: [
                  SizedBox(width: 25),
                  DropdownButton(
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    value: selectedType,
                    items: type.map((e) => DropdownMenuItem(
                      value: e, // 선택 시 onChanged 를 통해 반환할 value
                      child: Text(e),
                    )).toList(),
                    onChanged: (value) { // items 의 DropdownMenuItem 의 value 반환
                      setState(() {
                        selectedType = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height:12),
              Text("제한사항", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              SizedBox(height:7),
              ListView.builder(
                shrinkWrap: true,
                itemCount: conditionList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    visualDensity: VisualDensity(vertical: -3),
                    leading: FaIcon(FontAwesomeIcons.circleExclamation,size : 20),
                    title: Text(conditionList[index], style: TextStyle(fontSize: 18)),
                    trailing: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.circleMinus,
                        color: Colors.black,
                        size : 20
                      ),
                      onPressed: (){
                        removeCondition(index);
                      },
                    ),
                  );
                },
              ),
              Container(
                margin: EdgeInsets.fromLTRB(18, 1, 37, 1),
                child: TextField(
                  autocorrect: false,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.add),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                      isDense: true,
                      suffixIconConstraints: BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                      suffixIcon: InkWell(
                          child: Icon(Icons.check_circle, size: 22),
                          onTap: () {
                            addCondition(editingController.text);
                            editingController.text = "";
                            FocusManager.instance.primaryFocus?.unfocus();
                      })
                  ),
                  onSubmitted: (value){
                    addCondition(editingController.text);
                    editingController.text = "";
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  controller: editingController,
                  keyboardType: TextInputType.text,
                ),
              ),
              SizedBox(height:12),
              Text("레시피", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
              Text(loading ? "로딩중..." : recipe, style: TextStyle(fontSize: 18)),
            ],
          ),


        ),
      bottomNavigationBar: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[300],
        ),

        child: Text("확인", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        onPressed: () async{
          setLoading();
          final result = await recipeRequest(widget.foodList, selectedType, conditionList, widget.authorization);
          if(result.statusCode == 200){
            final data = jsonDecode(utf8.decode(result.bodyBytes));
            loading = false;
            setRecipe(data["recipe"]);
          }
          else{
            setRecipe("서버 응답 에러");
          }
          loading = false;
        },
      )
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: showFAB ? Container(
      //   height: 35,
      //   margin: const EdgeInsets.all(10),
      //   child: ElevatedButton(
      //     onPressed: () async{
      //       final result = await recipeRequest(widget.foodList, selectedType, conditionList, widget.authorization);
      //       if(result.statusCode == 200){
      //         final data = jsonDecode(utf8.decode(result.bodyBytes));
      //         print(data);
      //         setRecipe(data["recipe"]);
      //       }
      //     },
      //     child: const Center(
      //       child: Text("확인", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      //     ),
      //   ),
      // ) : null,
    );
  }
}

