import 'package:frontend/request.dart';
import 'package:http/http.dart';
import "dart:convert" as convert;
class LogService{
  static Future<Map<String, dynamic>> checkIn(id) async{
    try{
      Response response = await RequestUtil.request("post", "/entrance/$id");
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse;
    }
    catch(e){
      return <String, dynamic>{};
    }
  }
  static Future<Map<String, dynamic>> getCustomerStats({queries}) async{
    try{
      Response response = await RequestUtil.request("get", "/entrance/stats", queries: queries);
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse;
    }
    catch(e){
      print(e);
      return <String, dynamic>{};
    }
  }

  static Future<Map<String, dynamic>> getDoanhThuStats({queries}) async{
    try{
      Response response = await RequestUtil.request("get", "/doanhthu", queries: queries);
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse;
    }
    catch(e){
      return <String, dynamic>{};
    }
  }
}