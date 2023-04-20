import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/Authentication/Login.dart';
import 'package:frontend/pages/Authentication/RegisterNhanVien.dart';
import 'package:frontend/pages/Authentication/RegisterPT.dart';

import '../../core/Colors.Hex_Color.dart';

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
    return
       Scaffold(
         appBar: AppBar(title: Text("Trần Huy Gym")),
         body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.1, 0.4, 0.7, 0.9],
              colors: [
                HexColor("#4b4293").withOpacity(0.8),
                HexColor("#4b4293"),
                HexColor("#08418e"),
                HexColor("#08418e")
              ],
            ),
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  HexColor("#fff").withOpacity(0.2), BlendMode.dstATop),
              image: const NetworkImage(
                'https://mir-s3-cdn-cf.behance.net/project_modules/fs/01b4bd84253993.5d56acc35e143.jpg',
              ),
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [Card(
                      elevation: 5,
                      color:
                  const Color.fromARGB(255, 171, 211, 250).withOpacity(0.4),
                  child: Container(
                  width: 400,
                  padding: const EdgeInsets.all(40.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: const Center(child:
                        Text("Chọn loại người dùng để đăng ký tài khoản", style: TextStyle(fontFamily: "BeVietnamPro", fontSize: 25, color: Colors.white),))),
                    Container(
                      height: 50,
                      child: ListTile(
                        title: const Text('Nhân viên', style: TextStyle(color: Colors.white, fontSize: 20),),
                        leading: Radio<UserTypes>(
                          fillColor: MaterialStatePropertyAll(Colors.grey),
                          value: UserTypes.NhanVien,
                          groupValue: _userTypeSelected,
                          onChanged: (UserTypes? value) {
                            setState(() {
                              _userTypeSelected = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: ListTile(
                        title: const Text('Huấn luyện viên PT', style: TextStyle(color: Colors.white, fontSize: 20),),
                        leading: Radio<UserTypes>(
                          fillColor: MaterialStatePropertyAll(Colors.grey),
                          value: UserTypes.PT,
                          groupValue: _userTypeSelected,
                          onChanged: (UserTypes? value) {
                            setState(() {
                              _userTypeSelected = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(onPressed: (){
                            navigateToLogin();
                          }, child: const Text("Đăng nhập", style: TextStyle(color:  Colors.grey,),)),
                          FilledButton(onPressed: (){
                              if (_userTypeSelected == UserTypes.NhanVien){
                                navigateToStaffRegister();
                              }
                              else{
                                navigateToPTRegister();
                              }
                            },
                              child: const Text("Đăng ký",
                                  style: TextStyle(color: Colors.white, fontSize: 20))),
                        ],
                      ),
                    )],
                    ),
                ),
      )],
              ),
            ),
          ),
    ),
       );
  }

  void navigateToLogin(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void navigateToStaffRegister(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupNhanVienScreen()));
  }
  void navigateToPTRegister(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupPTScreen()));
  }

}
