import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Services/CommonService.dart';
import 'package:frontend/Services/Log.service.dart';
import 'package:frontend/Services/customer.service.dart';
import 'dart:core';

import '../../Shared/BottomNavigationBar.dart';

final _formKey = GlobalKey<FormState>();
class CheckInView extends StatefulWidget{
  CheckInView({super.key, required this.customerId});
  String? customerId ;
  @override
  State<CheckInView> createState() => _CheckInViewState(customerId: customerId);
}
enum Gender { MALE, FEMALE }

class _CheckInViewState extends State<CheckInView> with TickerProviderStateMixin  {
  _CheckInViewState({required this.customerId });
  String? customerId;
  dynamic customer;
  bool loading = true;
  Gender gioitinh = Gender.MALE;

  int heightTabTrain = 0;
  int heightTabPT = 0;
  int heightTabView = 0;
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState


    getCustomer() async{
      var jsonResponse = await CustomerService.getOne(customerId);
      if (!jsonResponse.keys.contains("message")){
        print(jsonResponse);
        setState(() {
          customer = jsonResponse;
          heightTabTrain = jsonResponse["dkytap"].length * 58;
          heightTabPT = jsonResponse["dkypt"].length * 58;
          heightTabView = max(heightTabTrain, heightTabPT) + 40;
          _tabController = TabController(length: 2, vsync: this);
          loading = false;
        });
      }
    }
    super.initState();
    getCustomer();
  }

  void save(context) async{
    if (_formKey.currentState!.validate()){
      var response;
      if (response.keys.contains("message")){
        CommonService.popUpMessage(response["message"], context);
        return;
      }
      CommonService.popUpMessage("Lưu thành công", context);
      Navigator.pop(context);
      return;

    }
    CommonService.popUpMessage("Vui lòng kiểm tra lại thông tin phiếu nhập", context);
  }
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBarShared(),
        body: Column(children: [],),
      );
    }
    return (
        Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(title: const Text("Trần Huy Gym"),),
          body: Container(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
            child: SingleChildScrollView(
              child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(flex: 2,child: const Text("Khách Hàng", style: TextStyle(fontSize: 30))),
                                  Expanded(flex: 1, child: ElevatedButton(onPressed: () async {
                                    var jsonResponse = await LogService.checkIn(customerId);
                                    CommonService.popUpMessage("Khách ${jsonResponse['tenKhach']} ${jsonResponse['isExpired'] ? 'đã hết hạn' : 'còn hạn đến ${CommonService.convertISOToDateOnly(customer["ngayHetHanTap"])}'}", context);
                                  }, child: const Text("Check in tập"),))
                                ]
                              ),
                              TextFormField(
                                decoration: const InputDecoration(icon: Icon(Icons.verified_user), labelText: "Tên Khách Hàng"),
                                enabled: false,
                                readOnly: true,
                                initialValue: customer["ten"], ),
                              TextFormField(
                                decoration: const InputDecoration(icon: Icon(Icons.phone), labelText: "Số điện thoại"),
                                enabled: false,
                                readOnly: true,
                                initialValue: customer["sdt"], ),
                              TextFormField(
                                decoration: const InputDecoration(icon: Icon(Icons.date_range), labelText: "Ngày Sinh"),
                                enabled: false,
                                readOnly: true,
                                initialValue: CommonService.convertISOToDateOnly(customer["ngaysinh"]), ),
                              Row(
                                children: [
                                  const Expanded(flex: 1, child: Text("Giới tính")),
                                  Expanded(
                                    flex: 2,
                                    child: ListTile(
                                      title: const Text('Nam'),
                                      leading: Radio<Gender>(
                                        value: Gender.MALE,
                                        groupValue: gioitinh,
                                        onChanged: (Gender? value) {
                                        },

                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: ListTile(
                                      title: const Text('Nữ'),
                                      leading: Radio<Gender>(
                                        value: Gender.FEMALE,
                                        groupValue: gioitinh,
                                        onChanged: (Gender? value) {
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child: TextFormField(
                                    decoration: const InputDecoration(icon: Icon(Icons.date_range), labelText: "Hạn Tập"),
                                    enabled: false,
                                    readOnly: true,
                                    initialValue: customer["ngayHetHanTap"] != ""? CommonService.convertISOToDateOnly(customer["ngayHetHanTap"]) : "" )),
                                  Expanded(child: TextFormField(
                                    decoration: const InputDecoration(icon: Icon(Icons.date_range), labelText: "Hạn PT"),
                                    enabled: false,
                                    readOnly: true,
                                    initialValue: customer["ngayHetHanPT"] != ""? CommonService.convertISOToDateOnly(customer["ngayHetHanPT"]) : "" ))
                                ],
                              ),

                              DefaultTabController(
                                length: 2,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [SizedBox(
                                        height: 50,
                                        width: 350,
                                        child:
                                        TabBar(
                                            labelColor: Colors.black,
                                            tabs: [
                                              Tab(child: Text("Đăng Ký Tập"),),
                                              Tab(child: Text("Đăng Ký PT"),),
                                            ]),
                                      ),
                                      ],
                                    ),
                                    Container(
                                      width: 400,
                                      height: heightTabView.toDouble(),
                                      child: TabBarView(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 390,
                                                height: heightTabTrain.toDouble(),
                                                margin: EdgeInsets.symmetric(vertical: 20),
                                                child: Table(
                                                  children: [
                                                    const TableRow(
                                                        decoration: BoxDecoration(
                                                            color: Colors.blueAccent
                                                        ),
                                                        children: [
                                                          Padding(padding: EdgeInsets.all(5),child: Center(child: Text("Gói PT", style: TextStyle(color: Colors.white),))),
                                                          Padding(padding: EdgeInsets.all(5),child: Center(child: Text("Ngày đăng ký", style: TextStyle(color: Colors.white),))),
                                                          Padding(padding: EdgeInsets.all(5),child: Center(child: Text("Ngày hết hạn", style: TextStyle(color: Colors.white),))),
                                                        ]
                                                    ),
                                                    for(var chitiet in customer["dkytap"])
                                                      (
                                                        TableRow(
                                                          children: [
                                                            Container(margin: const EdgeInsets.symmetric(vertical: 5), child: Center(child: Text(chitiet["goitap"]["ten"]))),
                                                            Container(margin: const EdgeInsets.symmetric(vertical: 5),child: Center(child: Text(CommonService.convertISOToDateOnly(chitiet["ngaydk"])))),
                                                            Container(margin: const EdgeInsets.symmetric(vertical: 5),child: Center(child: Text(CommonService.convertISOToDateOnly(chitiet["ngayhethan"])))),
                                                          ]
                                                        )
                                                      )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 390,
                                                height: heightTabPT.toDouble(),
                                                margin: EdgeInsets.symmetric(vertical: 20),
                                                child: Table(
                                                  children:  [
                                                    const TableRow(
                                                        decoration: BoxDecoration(
                                                        color: Colors.blueAccent
                                                        ),
                                                        children: [
                                                          Padding(padding: EdgeInsets.all(5),child: Center(child: Text("Gói PT", style: TextStyle(color: Colors.white),))),
                                                          Padding(padding: EdgeInsets.all(5),child: Center(child: Text("Ngày đăng ký", style: TextStyle(color: Colors.white),))),
                                                          Padding(padding: EdgeInsets.all(5),child: Center(child: Text("Ngày hết hạn", style: TextStyle(color: Colors.white),))),
                                                        ]
                                                    ),
                                                    for(var chitiet in customer["dkypt"])
                                                      (
                                                          TableRow(
                                                              children: [
                                                                Container(margin: const EdgeInsets.symmetric(vertical: 5), child: Center(child: Text(chitiet["goipt"]["ten"]))),
                                                                Container(margin: const EdgeInsets.symmetric(vertical: 5),child: Center(child: Text(CommonService.convertISOToDateOnly(chitiet["ngaydk"])))),
                                                                Container(margin: const EdgeInsets.symmetric(vertical: 5),child: Center(child: Text(CommonService.convertISOToDateOnly(chitiet["ngayhethan"])))),
                                                              ]
                                                          )
                                                      )

                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]
                                ),
                              ),

                            ],
                          ),
                        )],
                    ),
                  ]
              ),
            ),

          ),
        )
    );
  }


}
