import 'package:http/http.dart';
import 'dart:convert' as convert;
import '../request.dart';

class HoaDonService{
  static Future<Map<String, dynamic>> getAll({queries}) async{
    try{
      Response response = await RequestUtil.request("get", "/hoadon", queries: queries);
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    }
    catch(e){
      return <String, dynamic>{};
    }


  }
  static Future<Map<String, dynamic>> add(body)async {
    try{

      Response response = await RequestUtil.request("post", "/hoadon", body: convert.jsonEncode(body), encoded:true);
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    }
    catch(e){
      print(e);
      return <String, dynamic>{};
    }
  }
  static Future<Map<String, dynamic>> delete(id)async {
    try{

      Response response = await RequestUtil.request("post", "/hoadon/$id");
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    }
    catch(e){
      print(e);
      return <String, dynamic>{};
    }
  }
}