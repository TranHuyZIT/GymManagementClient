import 'package:frontend/request.dart';
import 'package:http/http.dart';
import "dart:convert" as convert;
class NhanVienService{
  static Future<Map<String, dynamic>> getAll({queries}) async{
    try{
      Response response = await RequestUtil.request("get", "/nhanvien");
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse;
    }
    catch(e){
      print("Có lỗi xảy ra khi lấy thông tin nhân viên");
      return <String, dynamic>{};
    }
  }
}