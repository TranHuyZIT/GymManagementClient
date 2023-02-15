import 'package:flutter/material.dart';

final _formKey = GlobalKey<FormState>();

class Login extends StatelessWidget {
  const Login({super.key});

  @override
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
            width: 200,
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
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nhập vào mật khẩu";
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Đăng nhập thành công")));
                            }
                          },
                          child: const Text("Đăng Nhập"))
                    ]),
                  )
                ]),
          ),
        ));
  }
}
