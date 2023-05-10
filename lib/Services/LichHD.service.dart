import 'package:http/http.dart';
import 'dart:convert' as convert;
import '../request.dart';

class LichHDService{
  static Future<Map<String, dynamic>> getOne(id) async {
    try {
      Response response = await RequestUtil.request("get", "/lichhd/$id");
      var jsonResponse = convert.jsonDecode(response.body) as Map<
          String,
          dynamic>;
      return jsonResponse;
    }
    catch (e) {
      print(e);
      return <String, dynamic>{};
    }
  }
  static Future<Map<String, dynamic>> getOneForPT() async {
    try{
      Response response = await RequestUtil.request("get", "/lichhd/pt");
      var jsonResponse = convert.jsonDecode(response.body) as Map<
          String,
          dynamic>;
      return jsonResponse;
    }
    catch(e){
      print(e);
      return <String, dynamic>{};
    }
  }
  static Future<Map<String, dynamic>> getAll({queries}) async{
    try{
      Response response = await RequestUtil.request("get", "/lichhd", queries: queries);
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    }
    catch(e){
      print(e);
      return <String, dynamic>{};
    }


  }
  static Future<Map<String, dynamic>> add(body)async {
    try{

      Response response = await RequestUtil.request("post", "/lichhd", body: convert.jsonEncode(body), encoded:true);
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonResponse);
      return jsonResponse;
    }
    catch(e){
      print(e);
      return <String, dynamic>{};
    }
  }

  static Future<Map<String, dynamic>> delete(id)async {
    try{

      Response response = await RequestUtil.request("delete", "/lichhd/$id");
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    }
    catch(e){
      print(e);
      return <String, dynamic>{};
    }
  }
}