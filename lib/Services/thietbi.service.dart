import 'package:flutter/material.dart';
import 'package:frontend/Services/CommonService.dart';
import 'package:frontend/request.dart';
import 'package:http/http.dart';
import "dart:convert" as convert;
class ThietBiService{
  static Future<List> getAll() async{
    try{
      Response response = await RequestUtil.request("get", "/thietbi");
      List jsonResponse =  convert.jsonDecode(response.body) as List<dynamic>;
      return jsonResponse;
    }
    catch(e){
      print("Có lỗi xảy ra trong ThietBi service");
      return [];
    }}
  static Future<dynamic> add(thietbi, context) async{
    try{
      Response response = await RequestUtil.request("post", "/thietbi", body: thietbi);
      dynamic jsonResponse = convert.jsonDecode(response.body);
      CommonService.popUpMessage("Thêm thiết bị mới thành công", context);
      return jsonResponse;
    }
    catch(e){
      CommonService.popUpMessage("Có lỗi xảy ra trong ThietBi service", context);
      return {};
    }
  }
}