import 'package:intl/intl.dart';

extension DateTimeEx on DateTime{
  String get getFormattedDate=>
    DateFormat('dd-MM-yyy').format(this);
  String get getFormattedTime{
   return DateFormat('hh:mm').format(this);
  }
  String get getMonth=>
      DateFormat('dd-MMM').format(this);

}