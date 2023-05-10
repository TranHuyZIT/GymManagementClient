import 'package:frontend/request.dart';
import 'package:http/http.dart';
import "dart:convert" as convert;
class NhanVienService{
  static Future<Map<String, dynamic>> getAll({queries}) async{
    try{
      Response response = await RequestUtil.request("get", "/nhanvien", queries: queries);
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse;
    }
    catch(e){
      print("Có lỗi xảy ra khi lấy thông tin nhân viên");
      return <String, dynamic>{};
    }
  }
  static Future<Map<String, dynamic>> add(body) async{
    try{
      Response response = await RequestUtil.request("post", "/nhanvien", body: convert.jsonEncode(body), encoded:true);
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse;
    }
    catch(e){
      print(e);
      print("Có lỗi xảy ra khi đăng ký thông tin nhân viên");
      return <String, dynamic>{};
    }
  }
  static Future<Map<String, dynamic>> update(id, body) async{
    try{
      Response response = await RequestUtil.request("put", "/nhanvien/${id.toString()}", body: convert.jsonEncode(body), encoded:true);
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse;
    }
    catch(e){
      print(e);
      return <String, dynamic>{};
    }
  }
}
