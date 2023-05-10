import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/Enum/MachineStatus.dart';
import 'package:frontend/Services/Auth.service.dart';
import 'package:frontend/Services/CommonService.dart';
import 'package:frontend/Services/thietbi.service.dart';
import 'package:frontend/Services/thietbiphong.service.dart';
import 'dart:convert' as convert;
import '../../../Services/HoaDon.service.dart';
import '../../../Services/PhieuNhap.service.dart';
import '../../../Services/phieukiemtra.service.dart';
import '../../Shared/BottomNavigationBar.dart';
final _formKey = GlobalKey<FormState>();
class HoaDonView extends StatefulWidget{
  @override
  State<HoaDonView> createState() => _HoaDonViewState();
}

class _HoaDonViewState extends State<HoaDonView> with TickerProviderStateMixin {
  final _dateStringController = TextEditingController();
  Map<String, dynamic> nhanvien = <String, dynamic>{};
  String manv = '';
  String selectedTinhTrang = MachineStatus.defaultStatus;
  DateTime? ngaylap;
  String ghichu = "";
  List<dynamic> chitiet = [];
  Table table = Table();
  dynamic data;


  dynamic dropDownSelectedId;
  dynamic dropDownSelectedName;
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      switch(_tabController.index){
        case 0:
          generateTabe(_tabController.index, data, "dkytap", ["Ngày Đăng Ký", "Ngày Hết Hạn"]);
          break;
        case 1:
          generateTabe(_tabController.index, data, "dkypt", ["Ngày Đăng Ký", "Ngày Hết Hạn"]);
          break;
      }
    });
  }
  void generateTabe(int type, data, key, List<String> headers) {
    String name = "";
    String keyDetail = "";
    switch(type){
      case 0:
        name = "Gói Tập";
        keyDetail = "goitap";
        break;
      case 1:
        name = "Gói PT";
        keyDetail = "goipt";
        break;
    }
    setState(() {
      table = Table(
        children: [
          TableRow(
              decoration: const BoxDecoration(
                  color: Colors.blueAccent
              ),
              children: [
                Padding(padding: const EdgeInsets.all(5),child: Center(child: Text(name, style: const TextStyle(color: Colors.white),))),
                Padding(padding: const EdgeInsets.all(5),child: Center(child: Text(headers[0], style: const TextStyle(color: Colors.white),))),
                Padding(padding: const EdgeInsets.all(5),child: Center(child: Text(headers[1], style: const TextStyle(color: Colors.white),))),
              ]
          ),
          for(var chitiet in data[key])
            (
                TableRow(
                    children: [
                      Container(margin: const EdgeInsets.symmetric(vertical: 5), child: Center(child: Text(chitiet[keyDetail]["ten"]))),
                      Container(margin: const EdgeInsets.symmetric(vertical: 5),child: Center(child: Text(CommonService.convertISOToDateOnly(chitiet["ngaydk"])))),
                      Container(margin: const EdgeInsets.symmetric(vertical: 5),child: Center(child: Text(CommonService.convertISOToDateOnly(chitiet["ngayhethan"])))),
                    ]
                )
            )
        ],
      );
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ngaylap ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      CommonService.popUpMessage('Ngày lập: ${picked}', context);
      setState(() {
        ngaylap = picked;
      });
      _dateStringController.value = _dateStringController.value.copyWith(
          text: CommonService.convertISOToDateOnly(picked.toString())
      );
    }
  }
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    final currentData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (currentData.isNotEmpty && !initialized){
      _dateStringController.value = _dateStringController.value.copyWith(
          text: CommonService.convertISOToDateOnly(DateTime.tryParse(currentData["ngaylap"]).toString())
      );
      generateTabe(_tabController.index, currentData, "dkytap", ["Ngày Đăng Ký", "Ngày Hết Hạn"]);
      print(currentData);
      setState(() {
        nhanvien =  currentData["manv"] ?? <String, dynamic>{};
        ngaylap = DateTime.tryParse(currentData["ngaylap"]);
        data = currentData;
        initialized = true;
      });
    }
    return (
        Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBarShared(),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
              child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Form(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Hóa Đơn", style: TextStyle(fontSize: 35)),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: ElevatedButton(onPressed: () async{
                                        var response = await HoaDonService.duyet(data["_id"]);
                                        if (response.containsKey("message")){
                                          CommonService.popUpMessage(response["message"], context);
                                          return;
                                        }
                                        CommonService.popUpMessage("Duyệt Hóa Đơn Thành Công", context);
                                        Navigator.pop(context);
                                      }, child: const Text("Duyệt hóa đơn")),
                                    )
                                  ],
                                ),
                                TextFormField(
                                  enabled: false,
                                  initialValue: manv,
                                  decoration:  InputDecoration(
                                      icon: const Icon(Icons.person),
                                      labelText: '${nhanvien["ten"] ?? "Chưa có"} ',
                                      helperText: 'Nhân viên'
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: _dateStringController,
                                        validator: (value){
                                          if (value == null || ngaylap == null) {
                                            return "Ngày kiểm tra không được trống";
                                          }
                                          return null;
                                        },
                                        decoration:  const InputDecoration(
                                          icon: Icon(Icons.date_range),
                                          labelText: 'Ngày lập',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ElevatedButton(onPressed:currentData.isEmpty? (){
                                        _selectDate(context);
                                      } : null,
                                          style: currentData.isNotEmpty? ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(Colors.grey),
                                            textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white)),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18.0),
                                                side: BorderSide(color: Colors.grey),
                                              ),
                                            ),
                                          ):  ButtonStyle(backgroundColor:  MaterialStateProperty.all(Colors.blue)),
                                          child: const Text("Chọn ngày")),
                                    )
                                  ],
                                ),

                              ],
                            ),
                          ),
                        )],
                    ),
                    SizedBox(
                      width: 350,
                      height: 80,
                      child: Scaffold(
                        appBar: TabBar(controller: _tabController, labelColor: Colors.black,indicatorColor: Colors.blue,tabs: const [
                          Tab(
                            text: "Đăng Ký Tập",
                          ),
                          Tab(
                            text: "Đăng Ký PT",
                          )
                        ]),
                        body: Container(margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),child: table),
                      ),
                    ),
                  ]
              ),

            ),
          ),
        )
    );
  }
  void save(context) async{
    if (_formKey.currentState!.validate()){
      Map<String, dynamic> response = await HoaDonService.add({
        "ngaykiemtra": ngaylap?.toIso8601String(),
        "ghichu": ghichu,
        "manv": manv,
        "chitiet": chitiet.map((e) => ({
          "mathietbiphong": e["mathietbiphong"],
          "tinhtrang": e["tinhtrang"]
        })).toList()
      });
      setState(() {
        chitiet = [];
        ngaylap = DateTime.now();
      });
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
}