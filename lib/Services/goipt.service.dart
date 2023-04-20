import 'package:http/http.dart';

import '../request.dart';
import "dart:convert" as convert;

import 'CommonService.dart';
class GoiPTService{
  static Future<Map<String, dynamic>> getAll({queries}) async{
    try{
      Response response = await RequestUtil.request("get", "/goipt", queries: queries);
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    }
    catch(e){
      return <String, dynamic>{};
    }
  }
  static Future<Map<String, dynamic>> add(body, context)async {
    try{
      Response response = await RequestUtil.request("post", "/goipt", body: convert.jsonEncode(body), encoded:true);
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    }
    catch(e){
      CommonService.popUpMessage("Có lỗi xảy ra", context);
      return <String, dynamic>{};
    }
  }
  static Future<dynamic> update(newThietBi, context) async{
    try{
      Response response = await RequestUtil.request("put", "/goitap/${newThietBi["_id"]}" , body: newThietBi);
      dynamic jsonResponse = convert.jsonDecode(response.body);
      CommonService.popUpMessage("Cập nhật thành công thiết bị", context);
      return jsonResponse;
    }
    catch(e){
      CommonService.popUpMessage("Có lỗi xảy ra trong ThietBi service", context);
      return {};
    }
  }
}






