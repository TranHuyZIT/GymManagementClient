import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommonService {
  static void popUpMessage(String msg, context){
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(msg)));
  }
  static String convertISOToDate(String isoString){
    return DateFormat('dd/MM/yyyy-hh:mm').format(DateTime.parse(isoString));
  }
  static String convertISOToDateOnly(String isoString){
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(isoString));
  }
  static String convertISOToDateWithoutYear(String isoString){
    return DateFormat('dd/MM').format(DateTime.parse(isoString));
  }
  static String convertISOToTimeOnly(String isoString){
    return DateFormat('hh:mm - EEEE').format(DateTime.parse(isoString));
  }
  static String convertISOToTime(String isoString){
    return DateFormat('hh:mm').format(DateTime.parse(isoString));
  }
  static String formatVND(String money){
    return NumberFormat("#,##0đ", "vi_VN").format(int.parse(money));
  }
}
