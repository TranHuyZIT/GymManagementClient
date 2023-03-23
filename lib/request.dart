import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';


class RequestUtil {
  static request(method, url, {body, queries, encoded}) async {
    var uri = Uri.http("10.0.2.2:5000", url, queries);
    final LocalStorage localStorage =  LocalStorage("app");
    String token = localStorage.getItem("token") ?? "";
    var headers = {
      "Authorization": "Bearer $token",
    };
    if(encoded == true){
      headers["Content-Type"] = "application/json";
    }
    switch (method.toString().toLowerCase()) {
      case "get":
        return await get(uri, headers: headers, );
      case "post":
        return await post(uri, headers: headers, body: body);
      case "put":
        return await put(uri, headers: headers, body: body);
      case "delete":
        return await delete(uri, headers: headers);
    }
    throw ErrorDescription("Sai phương thức http");
  }
}
