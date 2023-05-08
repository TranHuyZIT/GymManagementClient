import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/Enum/MachineStatus.dart';
import 'package:frontend/Services/Auth.service.dart';
import 'package:frontend/Services/CommonService.dart';
import 'package:frontend/Services/customer.service.dart';
import 'package:frontend/Services/goipt.service.dart';
import 'package:frontend/Services/goitap.service.dart';
import 'package:frontend/Services/pt.service.dart';
import 'package:frontend/Services/thietbi.service.dart';
import 'package:frontend/Services/thietbiphong.service.dart';
import 'dart:convert' as convert;
import '../../../Services/HoaDon.service.dart';
import '../../../Services/PhieuNhap.service.dart';
import '../../../Services/phieukiemtra.service.dart';
final _formKey = GlobalKey<FormState>();
class HoaDonForm extends StatefulWidget{
  @override
  State<HoaDonForm> createState() => _HoaDonFormState();
}

class _HoaDonFormState extends State<HoaDonForm> with TickerProviderStateMixin {
  final _dateStringController = TextEditingController();
  final _dateStringControllerTap = TextEditingController();
  final _dateStringControllerPT = TextEditingController();
  Map<String, dynamic> nhanvien = <String, dynamic>{};
  String manv = '';
  DateTime? ngaylap;
  String ghichu = "";
  List<dynamic> chitiet = [];
  Table table = Table();
  dynamic data;
  dynamic selectedKhach;
  List<dynamic> khachOptions = [];
  DateTime? ngaydkTap;
  DateTime? ngaydkPT;

  late TabController _tabController;

  List<dynamic> goiTapOptions = [];

  List<dynamic> goiPTOptions = [];

  List<dynamic> ptOptions = [];

  var selectedGoiTap;

  var selectedGoiTapName;

  var selectedGoiPT;

  var selectedGoiPTName;


  var selectedPT;

  var selectedPTName;
  Map<String, String> goiTapCard = {};
  Map<String, String> goiPTCard = {};

  int tabIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    getCurrentNhanVien() async {
      var jsonResponse = await AuthService.getIdentity();
      setState(() {
        nhanvien = jsonResponse["info"];
      });
    }
    getKhachOption() async {
      var jsonResponse = await CustomerService.getAll();
      setState(() {
          khachOptions = jsonResponse["data"];
      });
    }
    getGoiTapOption () async {
      var jsonResponse = await GoiTapService.getAll();
      setState(() {
        goiTapOptions = jsonResponse["data"];
      });
    }
    getGoiPTOption () async {
      var jsonResponse = await GoiPTService.getAll();
      setState(() {
        goiPTOptions = jsonResponse["data"];
      });
    }
    getPTOption () async {
      var jsonResponse = await PTService.getAll();
      setState(() {
        ptOptions = jsonResponse["data"];
      });
    }
    super.initState();
    getCurrentNhanVien();
    getKhachOption();
    getGoiTapOption();
    getGoiPTOption();
    getPTOption();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      print(tabIndex);
      setState(() {
        tabIndex = _tabController.index;
      });
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
    if (data == null) return;
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
  _selectDateTap(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ngaydkTap ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      CommonService.popUpMessage('Ngày Đăng ký tập: ${picked}', context);
      setState(() {
        ngaydkTap = picked;
      });
      _dateStringControllerTap.value = _dateStringControllerTap.value.copyWith(
          text: CommonService.convertISOToDateOnly(picked.toString())
      );
    }
  }
  _selectDatePT(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ngaydkPT ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      CommonService.popUpMessage('Ngày lập: ${picked}', context);
      setState(() {
        ngaydkPT = picked;
      });
      _dateStringControllerPT.value = _dateStringControllerPT.value.copyWith(
          text: CommonService.convertISOToDateOnly(picked.toString())
      );
    }
  }
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    return (
        Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(title: const Text("Trần Huy Gym"),),
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
                                const Text("Hóa Đơn", style: TextStyle(fontSize: 35)),
                                TextFormField(
                                  enabled: false,
                                  initialValue: manv,
                                  decoration:  InputDecoration(
                                      icon: const Icon(Icons.admin_panel_settings),
                                      labelText: '${nhanvien["ten"]} ',
                                      helperText: 'Nhân viên'
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(child: DropdownButtonFormField(
                                      value: selectedKhach,
                                      decoration: const InputDecoration(icon: Icon(Icons.speaker_notes),
                                          labelText: "Chọn khách"
                                      ),
                                      items: khachOptions.map((khach){
                                        return DropdownMenuItem(
                                            value: khach["_id"],
                                            child: (
                                                Text(khach["ten"])
                                            ));
                                      }).toList(),
                                      validator: (value){
                                        if (value == null || value == "") {
                                          return "Chọn khách";
                                        }
                                        return null;
                                      },
                                      onChanged: (Object? value) { setState(() {
                                        selectedKhach = value;
                                      }); },
                                    )),
                                  ],
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
                                            return "Ngày lập không được trống";
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
                                      child: ElevatedButton(onPressed: (){
                                        _selectDate(context);
                                      } ,
                                          style: ButtonStyle(backgroundColor:  MaterialStateProperty.all(Colors.blue)),
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
                      width: 650,
                      height: 500,
                      child: Scaffold(
                        appBar: TabBar(controller: _tabController, labelColor: Colors.black,indicatorColor: Colors.blue,tabs: const [
                          Tab(
                            text: "Đăng Ký Tập",
                          ),
                          Tab(
                            text: "Đăng Ký PT",
                          )
                        ]),
                        body: Container(margin: const EdgeInsets.fromLTRB(0, 15, 0, 0), height: 300,child:
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    child: tabIndex == 0 ? GoiTapCard(goiTapCard) : GoiPTCard(goiPTCard),
                                  ),
                                  goiTapCard.isNotEmpty ? ElevatedButton(onPressed:(){
                                    if (tabIndex == 0){
                                      setState(() {
                                        goiTapCard.clear();
                                      });
                                      return;
                                    }
                                    goiPTCard.clear();
                                  }, child: const Text("Xóa"),
                                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),) : Container()
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    width: 100,
                                    child: ElevatedButton(onPressed: (){
                                      if (selectedKhach == null){
                                        CommonService.popUpMessage("Vui lòng chọn khách hàng trước.", context);
                                        return;
                                      }
                                      showDialog(context: context,
                                          builder: (BuildContext context) => AlertDialog(
                                            title: const Text("Điền thông tin đăng ký"),
                                            content: SingleChildScrollView(
                                              child: _tabController.index == 0 ?
                                                  Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Expanded(
                                                            child: TextFormField(
                                                              readOnly: true,
                                                              controller: _dateStringControllerTap,
                                                              validator: (value){
                                                                if (value == null || ngaydkTap == null) {
                                                                  return "Ngày đăng ký tập không được trống";
                                                                }
                                                                return null;
                                                              },
                                                              decoration:  const InputDecoration(
                                                                icon: Icon(Icons.date_range),
                                                                labelText: 'Ngày đăng ký tập',
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: ElevatedButton(onPressed: (){
                                                              _selectDateTap(context);
                                                            } ,
                                                                style: ButtonStyle(backgroundColor:  MaterialStateProperty.all(Colors.blue)),
                                                                child: const Text("Chọn ngày")),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(child: DropdownButtonFormField(
                                                              decoration: const InputDecoration(icon: Icon(Icons.speaker_notes),
                                                                  labelText: "Chọn gói tập"
                                                              ),
                                                              value: selectedGoiTap,
                                                              items: goiTapOptions.map((goiTap){
                                                                return DropdownMenuItem(value: goiTap["_id"], child:  (Text(goiTap["ten"])));
                                                              }).toList(),
                                                              onChanged: (value){
                                                                setState(() {
                                                                  selectedGoiTap = value;
                                                                  selectedGoiTapName =
                                                                  goiTapOptions[goiTapOptions.indexWhere((element) => element["_id"] == value)]["ten"];
                                                                });
                                                              }))
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(child: ElevatedButton(onPressed: () {
                                                            setState(() {
                                                                Map<String, String> newgoiTapCard = ({
                                                                "magoitap": selectedGoiTap,
                                                                "tengoitap": selectedGoiTapName,
                                                                "ngaydk": ngaydkTap?.toIso8601String() ?? ""
                                                              });
                                                                goiTapCard = newgoiTapCard;
                                                            });
                                                            Navigator.pop(context);
                                                          }, child: const Text("Lưu"),))
                                                        ],
                                                      )
                                                    ],
                                                  )
                                              : Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: TextFormField(
                                                          readOnly: true,
                                                          controller: _dateStringControllerPT,
                                                          validator: (value){
                                                            if (value == null || ngaydkPT == null) {
                                                              return "Ngày đăng ký tập không được trống";
                                                            }
                                                            return null;
                                                          },
                                                          decoration:  const InputDecoration(
                                                            icon: Icon(Icons.date_range),
                                                            labelText: 'Ngày đăng ký tập',
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: ElevatedButton(onPressed: (){
                                                          _selectDatePT(context);
                                                        } ,
                                                            style: ButtonStyle(backgroundColor:  MaterialStateProperty.all(Colors.blue)),
                                                            child: const Text("Chọn ngày")),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(child: DropdownButtonFormField(
                                                          decoration: const InputDecoration(icon: Icon(Icons.speaker_notes),
                                                              labelText: "Chọn gói pt"
                                                          ),
                                                          value: selectedGoiPT,
                                                          items: goiPTOptions.map((goiTap){
                                                            return DropdownMenuItem(value: goiTap["_id"], child:  (Text(goiTap["ten"])));
                                                          }).toList(),
                                                          onChanged: (value){
                                                            setState(() {
                                                              selectedGoiPT = value;
                                                              selectedGoiPTName =
                                                              goiPTOptions[goiPTOptions.indexWhere((element) => element["_id"] == value)]["ten"];
                                                            });
                                                          }))
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(child: DropdownButtonFormField(
                                                          decoration: const InputDecoration(icon: Icon(Icons.speaker_notes),
                                                              labelText: "Chọn huấn luyện viên"
                                                          ),
                                                          value: selectedPT,
                                                          items: ptOptions.map((goiTap){
                                                            return DropdownMenuItem(value: goiTap["_id"], child:  (Text(goiTap["ten"])));
                                                          }).toList(),
                                                          onChanged: (value){
                                                            setState(() {
                                                              selectedPT = value;
                                                              selectedPTName =
                                                              ptOptions[ptOptions.indexWhere((element) => element["_id"] == value)]["ten"];
                                                            });
                                                          }))
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(child: ElevatedButton(onPressed: () {
                                                        setState(() {
                                                          Map<String, String> newgoiPTCard = ({
                                                            "magoitap": selectedGoiPT,
                                                            "tengoitap": selectedGoiPTName,
                                                            "ngaydk": ngaydkPT?.toIso8601String() ?? "",
                                                            "mapt": selectedPT,
                                                            "tenpt": selectedPTName
                                                          });
                                                          goiPTCard = newgoiPTCard;
                                                        });
                                                        Navigator.pop(context);
                                                      }, child: const Text("Lưu"),))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ));
                                    }, child: const Text("Thêm")),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    child: ElevatedButton(
                                      onPressed: (){
                                        save(context);
                                      },
                                      style: const ButtonStyle(
                                        backgroundColor: MaterialStatePropertyAll(Colors.indigo)
                                      ),
                                      child: const Text("Lập hóa đơn"),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )),
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
      Map<String, dynamic> body = {
        "ngaylap": ngaylap?.toIso8601String(),
        "makhach": selectedKhach
      };
      if (goiTapCard.isNotEmpty){
        body.addAll({"dkytap": [{
          "ngaydk": goiTapCard["ngaydk"],
          "magoitap": goiTapCard["magoitap"]
        }]});
      }
      if (goiPTCard.isNotEmpty){
        body.addAll({"dkypt": [{
          "ngaydk": goiPTCard["ngaydk"],
          "magoipt": goiPTCard["magoitap"],
          "mapt": goiPTCard["mapt"]
        }]});
      }
      print(body);
      Map<String, dynamic> response = await HoaDonService.add(body);
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
class GoiTapCard extends StatelessWidget{
  var data;

  GoiTapCard(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (data == null || data.isEmpty) return const Expanded(child: Center(child: Text("Không có")));
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: const [
            BoxShadow(
              offset: Offset(17, 17),
              blurRadius: 23,
              spreadRadius: -30,
              color: Colors.black,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image.asset(
              "assets/images/job.png",
              width: 100,
              height: 100,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data["tengoitap"],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text("Ngày đăng ký: ${CommonService.convertISOToDateOnly(data["ngaydk"])}")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
class GoiPTCard extends StatelessWidget{
  var data;

  GoiPTCard(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (data == null || data.isEmpty) return const Expanded(child: Center(child: Text("Không có")));
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: const [
            BoxShadow(
              offset: Offset(17, 17),
              blurRadius: 23,
              spreadRadius: -30,
              color: Colors.black,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image.asset(
              "assets/images/job.png",
              width: 100,
              height: 100,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data["tengoitap"],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text("Ngày đăng ký: ${CommonService.convertISOToDateOnly(data["ngaydk"])}"),
                  Text("HLV: ${data["tenpt"]}")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}