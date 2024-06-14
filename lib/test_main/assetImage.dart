class CustomAssetImage{
  static const Map imagePath = {
    "육류" : "assets/category1.png",
    "채소" : "assets/category2.png",
    "과일" : "assets/category3.png",
    "수산물" : "assets/category4.png",
    "유제품" : "assets/category5.png",
    "빵" : "assets/category6.png",
    "디저트" : "assets/category7.png",
    "기타" : "assets/category8.png",
  };
  static String pathFromInt(int i){
    return "assets/category" + i.toString() + ".png";
  }
  static const List<String> categoryName = ["육류", "채소", "과일", "수산물", "유제품", "빵", "디저트", "기타"];
}
