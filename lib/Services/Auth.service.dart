import 'package:frontend/request.dart';
import 'package:http/http.dart';
import "dart:convert" as convert;
class AuthService {
  static Future<Map<String, dynamic>> getIdentity() async{
    try{
      Response response = await RequestUtil.request("get", "/auth");
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse;
    }
    catch(e){
      print("Có lỗi xảy ra khi lấy thông tin người dùng hiện tại");
      return <String, dynamic>{};
    }
  }
}