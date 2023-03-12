import 'package:flutter/material.dart';
import 'package:frontend/Services/CommonService.dart';
import 'package:frontend/request.dart';
import 'package:http/http.dart';
import "dart:convert" as convert;
class ProductCategoryService{
   static Future<List> getAll() async{
    try{
      Response response = await RequestUtil.request("get", "/loaithietbi");
      List jsonResponse =  convert.jsonDecode(response.body) as List<dynamic>;
      return jsonResponse;
    }
    catch(e){
      print("Có lỗi xảy ra trong product category service");
      return [];
    }
  }

}