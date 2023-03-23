import 'package:flutter/material.dart';
import 'package:frontend/Services/CommonService.dart';
import 'package:frontend/request.dart';
import 'package:http/http.dart';
import "dart:convert" as convert;
class ThietBiPhongService{
  // Unimplemented
  static Future<Map<String,dynamic>> getAll() async{
    try{
      Response response = await RequestUtil.request("get", "/thietbiphong");
      var jsonResponse =  convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    }
    catch(e){
      print("Có lỗi xảy ra trong ThietBi service");
      return <String, dynamic>{};
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
  static Future<dynamic> update(newThietBi, context) async{
    try{
      Response response = await RequestUtil.request("put", "/thietbi/${newThietBi["_id"]}" , body: newThietBi);
      dynamic jsonResponse = convert.jsonDecode(response.body);
      CommonService.popUpMessage("Cập nhật thành công thiết bị", context);
      return jsonResponse;
    }
    catch(e){
      CommonService.popUpMessage("Có lỗi xảy ra trong ThietBi service", context);
      return {};
    }
  }
  static Future <dynamic> delete(id, context) async {
    try{
      Response response = await RequestUtil.request("delete", "/thietbi/${id}");
      dynamic jsonResponse = convert.jsonDecode(response.body);
      CommonService.popUpMessage("Xóa thành công thiết bị", context);
      return jsonResponse;
    }
    catch(e){
      CommonService.popUpMessage("Có lỗi xảy ra trong ThietBi service", context);
      return {};
    }
  }
}