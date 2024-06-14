import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () => checkAutoLogin());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(
          Icons.stream,
          size: 60,
          color:  Colors.blue,
        )
      )
    );
  }
  void checkAutoLogin() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool? autoLogin = _prefs.getBool("autoLogin");
    if(autoLogin != null && autoLogin){
      final storage = new FlutterSecureStorage();
      String? authorization = await storage.read(key: "cplogin");
      if(authorization != null){
        print("Auto Login Successed!!!");
        Navigator.pushNamed(context, '/list', arguments: authorization);
      }
      else{
        print("Auto Login Failed....");
        Navigator.pushNamed(context, '/login');
      }
    }
    else{
      print("Auto Login Failed....");
      Navigator.pushNamed(context, '/login');
    }
  }

}
