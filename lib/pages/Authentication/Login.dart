import 'package:flutter/material.dart';
import 'package:frontend/pages/Authentication/UserTypeSelection.dart';
import 'package:frontend/pages/Home/MyHomepage.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert' as convert;
import '../../request.dart';

final _formKey = GlobalKey<FormState>();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String tk = "";
  String mk = "";
  final LocalStorage storage = new LocalStorage('app');
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              "Trần Huy Gym",
              style: TextStyle(fontFamily: "BeVietnamPro", fontSize: 35),
            ),
          ),
        ),
        body: Container(
          height: 500,
          width: double.infinity,
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 250,
            color: Colors.grey[350],
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: const Text("Đăng Nhập"),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Nhập vào tài khoản";
                            }
                            return null;
                          },
                          onChanged: (value) => setState(() {
                                tk = value;
                              })),
                      TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Nhập vào mật khẩu";
                            }
                            return null;
                          },
                          obscureText: true,
                          onChanged: (value) => setState(() {
                                mk = value;
                              })),
                      ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              var response = await RequestUtil.request(
                                  "post", "/auth/login",
                                  body: {"tk": tk, "mk": mk},);
                              if (response.statusCode == 200){
                                String token = convert.jsonDecode(response.body);
                                storage.setItem('token', token);
                                popUpMessage("Đăng nhập thành công");
                                navigateToHomepage();
                              }
                              else{
                                var jsonResponse =
                                convert.jsonDecode(response.body) as Map<String, dynamic>;
                                popUpMessage(jsonResponse["msg"]);
                              }
                            }
                          },
                          child: const Text("Đăng Nhập"))
                    ]),
                  ),
                  TextButton(onPressed: (){
                    navigateToUserSelection();
                  }, child: const Text("Hoặc đăng ký"))
                ]),
          ),
        ));
  }
  void popUpMessage(String msg){
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(msg)));
  }
  void navigateToHomepage(){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MyHomePage(title: "Trần Huy Gym"))
        , ModalRoute.withName("/Home"));
  }
  void navigateToUserSelection(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserTypeSelection()));
  }
}
