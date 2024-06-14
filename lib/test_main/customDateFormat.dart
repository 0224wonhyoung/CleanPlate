import 'package:intl/intl.dart';

String dateFromString(String date){
  return DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
}

String dateFromDateTime(DateTime date){
  return DateFormat('yyyy-MM-dd').format(date);
}