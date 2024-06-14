import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';


Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: '9inp5rekt3',
      onAuthFailed: (ex) {
        print("********* 네이버맵 인증오류 : $ex *********");
      });
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text('Clean Plate 테스트중')),
            body: NaverMap(
              options: const NaverMapViewOptions(
                locationButtonEnable: false,
                consumeSymbolTapEvents: false,
              ),
              onMapReady: (controller) {
                print("네이버 맵 로딩됨!");
              },
            )));
  }
}