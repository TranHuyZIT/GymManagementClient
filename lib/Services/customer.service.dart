import 'package:http/http.dart';

import '../request.dart';
import "dart:convert" as convert;

import 'CommonService.dart';
class CustomerService{
  static Future<Map<String, dynamic>> getOne(id, {queries}) async{
    try{
      Response response = await RequestUtil.request("get", "/khach/${id.toString()}", queries: queries);
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    }
    catch(e){
      return <String, dynamic>{};
    }
  }
  static Future<Map<String, dynamic>> getAll({queries}) async{
    try{
      Response response = await RequestUtil.request("get", "/khach", queries: queries);
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    }
    catch(e){
      return <String, dynamic>{};
    }


  }
  static Future<Map<String, dynamic>> add(body, context)async {
    try{

      Response response = await RequestUtil.request("post", "/khach", body: convert.jsonEncode(body), encoded:true);
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    }
    catch(e){
      CommonService.popUpMessage("Có lỗi xảy ra", context);
      return <String, dynamic>{};
    }
  }
  static Future<dynamic> update(body, context) async{
    try{
      Response response = await RequestUtil.request("put", "/goitap/${body["_id"]}" , body: convert.jsonEncode(body), encoded:true);
      dynamic jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse;
    }
    catch(e){
      print(e);
      return {};
    }
  }
}






