import 'dart:io';

void main() {
  print(int.parse('87720330'));
  showData();
}

void showData() async{
  startTask();
  String account = await accessData();
  fetchData(account);
}

void startTask() {
  String info1 = '시작';
  print(info1);
}

Future<String> accessData() async{
  String account = '';
  Duration time = Duration(seconds: 3);
  if (time.inSeconds > 2) {
    await Future.delayed(time, () {
      account = '500';
      print(account);
    });
  } else {
    account = '1000';
    print(account);
  }
  return account;
}

void fetchData(String account) {
  String info3 = '잔액 '+account+'원';
  print(info3);
}
