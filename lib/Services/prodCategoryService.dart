import 'package:flutter/material.dart';
import 'package:frontend/Services/CommonService.dart';
import 'package:frontend/request.dart';
import 'package:http/http.dart';
import "dart:convert" as convert;
class ProductCategoryService{
   static Future<Map<String, dynamic>> getAll({queries}) async{
    try{
      Response response = await RequestUtil.request("get", "/loaithietbi", queries: queries);
      Map<String, dynamic> jsonResponse =  convert.jsonDecode(response.body) as Map<String, dynamic>;

      return jsonResponse;
    }
    catch(e){
      print("Có lỗi xảy ra trong product category service");
      return {};
    }

  }
   static Future<Map<String, dynamic>> delete(id , context) async {
     try {
       Response response = await RequestUtil.request(
           "delete", "/loaithietbi/${id}");
       Map<String, dynamic> jsonResponse = convert.jsonDecode(
           response.body) as Map<String, dynamic>;
       CommonService.popUpMessage("Xóa thành công loại thiết bị", context);
       return jsonResponse;
     }
     catch (e) {
       print("Có lỗi xảy ra trong product category service");
       CommonService.popUpMessage(
           "Có lỗi xảy ra trong LoaiThietBi service", context);
       return {};
     }
   }

   static Future<Map<String, dynamic>> add (newCate, context) async{
     try{
       Response response = await RequestUtil.request("post", "loaithietbi", body: newCate);
       Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
       CommonService.popUpMessage("Thêm thành công loại thiết bị", context);
       return jsonResponse;
     }
     catch(e){
       print("Có lỗi xảy ra trong product category service");
       CommonService.popUpMessage("Thêm thất bại loại thiết bị", context);
       return <String, dynamic>{};
     }
   }
   static Future<Map<String, dynamic>> update (newCate, id, context) async{
     try{
       Response response = await RequestUtil.request("put", "loaithietbi/" + id, body: newCate);
       Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
       CommonService.popUpMessage("Cập nhật thành công loại thiết bị", context);
       return jsonResponse;
     }
     catch(e){
       print("Có lỗi xảy ra trong product category service");
       CommonService.popUpMessage("Cập nhật thất bại loại thiết bị", context);
       return <String, dynamic>{};
     }
   }
}