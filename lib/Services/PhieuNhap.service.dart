import 'package:frontend/Services/CommonService.dart';
import 'package:frontend/request.dart';
import 'package:http/http.dart';
import "dart:convert" as convert;
class PhieuNhapService {
  static Future<Map<String, dynamic>> getAll({queries}) async{
      try{
        Response response = await RequestUtil.request("get", "/phieunhap", queries: queries);
        var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
        return jsonResponse;
      }
      catch(e){
        return <String, dynamic>{};
      }

  }
  static Future<Map<String, dynamic>> add(body)async {
    try{
      
      Response response = await RequestUtil.request("post", "/phieunhap", body: convert.jsonEncode(body), encoded:true);
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    }
    catch(e){
      print(e);
      return <String, dynamic>{};
    }
  }
  static Future<Map<String, dynamic>> delete(String id, context)async {
    try{

      Response response = await RequestUtil.request("delete", "/phieunhap/$id");
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      CommonService.popUpMessage("Xóa thành công", context);
      return jsonResponse;
    }
    catch(e){
      CommonService.popUpMessage("Có lỗi xảy ra, vui lòng thử lại sau", context);
      return <String, dynamic>{};
    }
  }
}