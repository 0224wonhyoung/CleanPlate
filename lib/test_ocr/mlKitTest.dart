import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

// class CustomBlock extends TextBlock implements Comparable<CustomBlock>{
//   CustomBlock({required super.text, required super.lines, required super.boundingBox, required super.recognizedLanguages, required super.cornerPoints});
//
//   @override
//   int compareTo(CustomBlock other) {
//     // TODO: implement compareTo
//     if(this.cornerPoints[0]<other.cornerPoints){
//
//     }
//     throw UnimplementedError();
//   }
//
// }
class CustomPack{
  final String name;
  final int quantity;
  CustomPack({required this.name, required this.quantity});
  @override
  String toString() {
    // TODO: implement toString
    return "name: " + name +  ", " + "수량: " + quantity.toString();
  }
}

class MLKitTest extends StatefulWidget {
  const MLKitTest({Key? key}) : super(key: key);

  @override
  State<MLKitTest> createState() => _MLKitTestState();
}

class _MLKitTestState extends State<MLKitTest> {
  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  String scannedText = "";  // textRecognizer로 인식된 텍스트를 담을 String
  List<CustomPack> packList = [];

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    print("DEBUG :: getImage start");
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
      getRecognizedText(_image!); // 이미지를 가져온 뒤 텍스트 인식 실행
    }
  }

  void getRecognizedText(XFile image) async {
    // XFile 이미지를 InputImage 이미지로 변환
    print("test1");
    final InputImage inputImage = InputImage.fromFilePath(image.path);

    // textRecognizer 초기화, 이때 script에 인식하고자하는 언어를 인자로 넘겨줌
    // ex) 영어는 script: TextRecognitionScript.latin, 한국어는 script: TextRecognitionScript.korean
    TextRecognizer textRecognizer =
    GoogleMlKit.vision.textRecognizer(script: TextRecognitionScript.korean);
    print("test2");

    // 이미지의 텍스트 인식해서 recognizedText에 저장
    RecognizedText recognizedText =
    await textRecognizer.processImage(inputImage);

    // Release resources
    await textRecognizer.close();
    print("test3");

    // 인식한 텍스트 정보를 scannedText에 저장
    scannedText = "";
    int startY = 0;
    int endY = 0;
    int qStartX = 0;  // 수량 왼쪽 x축
    int qEndX = 0;  // 수량 오른쪽 x축
    int orderX = 0; // 순번 오른쪽 x축
    int alpha = 7;

    // 기준 축 찾기
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        for(TextElement element in line.elements){
          if(element.text == "수량"){
             startY = element.cornerPoints[3].y;
             qStartX = element.cornerPoints[0].x;
             qEndX = element.cornerPoints[1].x;
          }
          else if(element.text == "순번"){
            orderX = element.cornerPoints[1].x;
          }
          else if (element.text == "과세물품"){
            endY = element.cornerPoints[0].y;
          }
        }
      }
    }

    List<TextBlock> blockList = [];
    //List<CustomPack> packList = [];

    for (TextBlock block in recognizedText.blocks) {
      if( upY(block) < startY || downY(block) > endY)
        continue;
      //print( block.cornerPoints.toString() + " 에 " + block.text + " .. " + rightX(block).toString());
      if(qStartX < rightX(block) && rightX(block) < qEndX){
        blockList.add(block);
        print("DEBUG ::: qblocks : " + block.cornerPoints.toString() + ", text: " + block.text);
      }
    }


    for(TextBlock qBlock in blockList){
      print("now checking qblocks : " + qBlock.cornerPoints.toString() + ", text: " + qBlock.text);
      for (TextBlock block in recognizedText.blocks) {
        int up = upY(block);
        int down = downY(block);

        print( block.cornerPoints.toString() + " 에 " + block.text );
        if(up > (upY(qBlock)- alpha) && down < (downY(qBlock) + alpha)){
          print( "안쪽 성공");
          // 1. 순번 축에 안걸치는게 존재 => 그대로 사용
          if(leftX(block) > orderX && leftX(block) < qStartX && rightX(block) > orderX && rightX(block) < qStartX){
            print("type1");
            packList.add(CustomPack(name: checkString(block.text), quantity: int.parse(qBlock.text)));
          }
          else if(leftX(block) < orderX && rightX(block) > qStartX){
            print("type3");
            String first = block.lines.first.elements.first.text;
            String last = block.lines.last.elements.last.text;
            String name = block.text.substring(first.length, block.text.length-last.length);
            packList.add(CustomPack(name: checkString(name), quantity: int.parse(last)));
          }
          else if (leftX(block) < orderX && rightX(block) > orderX && rightX(block) < qStartX){
            print("type2");
            String first = block.lines.first.elements.first.text;
            String name = block.text.substring(first.length, block.text.length);
            packList.add(CustomPack(name: checkString(name), quantity: int.parse(qBlock.text)));
          }

        }
      }
    }
    print("DEBUG ::: ALL PACKS : " + packList.toString());


    // for (TextBlock block in recognizedText.blocks) {
    //   if(block.cornerPoints[0].y < startY || block.cornerPoints[3].y > endY)
    //     continue;
    //
    //   if(qStartX < block.cornerPoints[3].x && block.cornerPoints[3].x < qEndX){
    //   }
    //
    //   //print( block.cornerPoints.toString() + " 에 " + block.text + " .. " + block.cornerPoints[3].y.toString());
    //   for (TextLine line in block.lines) {
    //     for(TextElement element in line.elements){
    //       //print( element.cornerPoints.toString() + " 에 " + element.text + " .. " + element.cornerPoints[3].y.toString());
    //     }
    //     //scannedText = scannedText + line.text + "\n";
    //   }
    // }

    print("test4 " + scannedText);
    setState(() {});
  }

  int rightX(TextBlock block){
    int max = 0;
    for (Point<int> p in block.cornerPoints){
      if (p.x > max) max = p.x;
    }
    return max;
  }

  int leftX(TextBlock block){
    int min = 10000;
    for (Point<int> p in block.cornerPoints){
      if (p.x < min) min = p.x;
    }
    return min;
  }

  int downY(TextBlock block){
    int max = 0;
    for (Point<int> p in block.cornerPoints){
      if (p.y > max) max = p.y;
    }
    return max;
  }

  int upY(TextBlock block){
    int min = 10000;
    for (Point<int> p in block.cornerPoints){
      if (p.y < min) min = p.y;
    }
    return min;
  }

  String checkString(String s){
    String result = s.replaceAll(RegExp('[^a-zA-Z0-9가-힣\\s]'), "").replaceAll("\n", " ");
    return result;
  }


  // int findStartY(RecognizedText recognizedText){
  //   for (TextBlock block in recognizedText.blocks) {
  //     for (TextLine line in block.lines) {
  //       for(TextElement element in line.elements){
  //         if(element.text == "순번" || element.text == "상품명" || element.text == "수량"){
  //           return element.cornerPoints[3].y;
  //         }
  //       }
  //     }
  //   }
  //   return 0;
  // }
  //
  // int findEndY(RecognizedText recognizedText){
  //   int max = 0;
  //   for (TextBlock block in recognizedText.blocks) {
  //     for (TextLine line in block.lines) {
  //       for(TextElement element in line.elements){
  //         if(element.cornerPoints[3].y > max){
  //           max = element.cornerPoints[3].y;
  //         }
  //         if(element.text == "과세물품" || element.text == "면세품가액"){
  //           return element.cornerPoints[0].y;
  //         }
  //       }
  //     }
  //   }
  //   return max;
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Camera Test")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30, width: double.infinity),
            _buildPhotoArea(),
            _buildRecognizedText(),
            SizedBox(height: 20),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? Container(
      width: 300,
      height: 300,
      child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄워주는 코드
    )
        : Container(
      width: 300,
      height: 300,
      color: Colors.grey,
    );
  }

  Widget _buildRecognizedText() {
    return Text(scannedText); //getRecognizedText()에서 얻은 scannedText 값 출력
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
          },
          child: Text("카메라"),
        ),
        SizedBox(width: 30),
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
          child: Text("갤러리"),
        ),
        SizedBox(width: 30),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, packList); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
          child: Text("확인"),
        ),
        SizedBox(width: 30),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
          child: Text("취소"),
        ),
      ],
    );
  }
}