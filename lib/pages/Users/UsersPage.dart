import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Services/NhanVien.service.dart';
import 'package:frontend/pages/Shared/BottomNavigationBar.dart';
import 'package:frontend/pages/Users/Section/Customer.section.dart';
import 'package:frontend/pages/Users/Section/NhanVien.section.dart';
import 'package:frontend/pages/Users/Section/PT.section.dart';
import 'package:localstorage/localstorage.dart';

import '../../Services/Auth.service.dart';
import '../../Services/CommonService.dart';
import '../Authentication/Login.dart';
import '../Home/MyHomepage.dart';
import '../Invoices/InvoicesPage.dart';

class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  Map<String, dynamic> identity = {

  };
  bool loading = true;
  @override
  void initState() {
    getIdentity() async {
      var jsonResponse = await AuthService.getIdentity();
      if (!jsonResponse.keys.contains("message")) {
        setState(() {
           identity = jsonResponse["info"];
        });
        print(identity);
      }
    }
    getIdentity();
    setState(() {
      loading = false;
    });
    super.initState();
  }
  void _saveProfile() async{
    var jsonResponse = await NhanVienService.update(identity["_id"], identity);
    if (jsonResponse.containsKey("message")){
      CommonService.popUpMessage(jsonResponse["message"], context);
      return;
    }
    Navigator.pop(context);
    CommonService.popUpMessage("Cập nhật thành công", context);
    initState();
  }
  @override
  Widget build(BuildContext context) {
    if (!loading) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Trần Huy Gym"),
        ),
        body: Container(
          width: 400,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(identity?["ten"] ?? ""),
                  Text("Nhân viên"),
                ],
              ),
              const Divider(
                height: 10,
                thickness: 2,
                indent: 20,
                endIndent: 0,
                color: Colors.black,
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: ListTile(
                        onTap: (){
                          showDialog(context: context, builder: (context) =>
                              AlertDialog(
                                title: const Text("Cập Nhật Thông Tin"),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      TextFormField(
                                        initialValue: identity["ten"],
                                        decoration: const InputDecoration(
                                            labelText: "Tên",
                                            icon: Icon(Icons.tag),
                                            helperText: 'VD: Trần Gia Huy'
                                        ),
                                        onChanged: (value){
                                          setState(() {
                                            identity["ten"] = value;
                                          });
                                        },
                                      ),
                                      TextFormField(
                                        keyboardType: const TextInputType.numberWithOptions(),
                                        initialValue: identity["sdt"],
                                        decoration: const InputDecoration(
                                            labelText: "SĐT",
                                            icon: Icon(Icons.phone),
                                            helperText: 'VD: 0939067106'
                                        ),
                                        onChanged: (value){
                                          setState(() {
                                            identity["sdt"] = value;
                                          });
                                        },
                                      ),
                                      ElevatedButton(onPressed: (){
                                        _saveProfile();
                                      },
                                          style:
                                          const ButtonStyle(
                                              backgroundColor:
                                              MaterialStatePropertyAll
                                                (Colors.indigo)),
                                          child: const Text("Lưu"))
                                    ],
                                  ),
                                ),
                              )
                          );
                        },
                        leading: Icon(Icons.edit),
                        title: Text("Cập nhật thông tin cá nhân"),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children:  [
                  Expanded(
                    child: Card(
                      child: ListTile(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomerSection()));
                        },
                        leading: Icon(Icons.person),
                        title: Text("Khách Hàng"),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children:  [
                  Expanded(
                    child: Card(
                      child: ListTile(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => NhanVienSection()));
                        },
                        leading: Icon(Icons.verified_user),
                        title: Text("Nhân Viên"),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children:  [
                  Expanded(
                    child: Card(
                      child: ListTile(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PTSection()));

                        },
                        leading: Icon(Icons.line_weight),
                        title: Text("Huấn luyện viên"),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children:  [
                  Expanded(
                    child: Card(
                      child: ListTile(
                        onTap: (){signOut();},
                        leading: const Icon(Icons.settings),
                        title: const Text("Đăng xuất"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationShared(currentIndex: 3,),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Trần Huy Gym"),),
    );
  }
  void signOut(){
    LocalStorage localStorage = LocalStorage("app");
    localStorage.deleteItem("token");
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), ModalRoute.withName("/login"));
  }
}
