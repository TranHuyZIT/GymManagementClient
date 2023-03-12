import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum UserTypes { NhanVien, PT }

class UserTypeSelection extends StatefulWidget{
  const UserTypeSelection({super.key});
  @override
  State<StatefulWidget> createState() => UserTypeState();
}
class UserTypeState extends State<UserTypeSelection>{
  UserTypes? _userTypeSelected = UserTypes.NhanVien;
  @override
  Widget build(BuildContext context) {
    print(_userTypeSelected);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Trần Huy Gym",
            style: TextStyle(fontFamily: "BeVietnamPro", fontSize: 35),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(child: const Center(child:
            Text("Vui lòng chọn loại người dùng để đăng ký tài khoản", style: TextStyle(fontFamily: "BeVietnamPro", fontSize: 35),))),
          Container(
            child:  Column(
              children: <Widget>[
                ListTile(
                  title: const Text('Nhân viên'),
                  leading: Radio<UserTypes>(
                    value: UserTypes.NhanVien,
                    groupValue: _userTypeSelected,
                    onChanged: (UserTypes? value) {
                      setState(() {
                        _userTypeSelected = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Huấn luyện viên PT'),
                  leading: Radio<UserTypes>(
                    value: UserTypes.PT,
                    groupValue: _userTypeSelected,
                    onChanged: (UserTypes? value) {
                      setState(() {
                        _userTypeSelected = value;
                      });
                    },
                  ),
                ),
                FilledButton(onPressed: (){
                  if (_userTypeSelected == UserTypes.NhanVien){

                  }

                },
                              child: const Text("Đăng ký",
                                style: TextStyle(color: Colors.white, fontSize: 20)))
              ],
            ),
      )],
      ),
    );
  }
  
}