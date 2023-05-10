import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:frontend/Enum/MachineStatus.dart';
import 'package:frontend/Services/Auth.service.dart';
import 'package:frontend/Services/CommonService.dart';
import 'package:frontend/Services/pt.service.dart';
import 'package:frontend/Services/thietbi.service.dart';
import 'package:frontend/Services/thietbiphong.service.dart';
import 'dart:convert' as convert;
import '../../../Services/LichHD.service.dart';
import '../../../Services/PhieuNhap.service.dart';
import '../../../Services/customer.service.dart';
import '../../../Services/phieukiemtra.service.dart';
import '../../Shared/BottomNavigationBar.dart';
final _formKey = GlobalKey<FormState>();
class LichHDForm extends StatefulWidget{
  @override
  State<LichHDForm> createState() => _LichHDFormState();
}

class _LichHDFormState extends State<LichHDForm> {
  final _dateStringController = TextEditingController();
  final _dateStringKTController = TextEditingController();
  Map<String, dynamic> nhanvien = <String, dynamic>{};
  List<dynamic> pts = [];
  List<dynamic> customers = [];
  var thus = [
    {
      "value": "2",
      "ten": "Hai"
    },
    {
      "value": "3",
      "ten": "Ba"
    },
    {
      "value": "4",
      "ten": "Tư"
    },
    {
      "value": "5",
      "ten": "Năm"
    },
    {
      "value": "6",
      "ten": "Sáu"
    },
    {
      "value": "7",
      "ten": "Bảy"
    }
  ];
  String manv = '';
  DateTime? ngaybd;
  DateTime? ngaykt;
  List<dynamic> chitiet = [
  ];

  dynamic selectedPtId;
  dynamic selectedPtName;
  dynamic selectedCustomerId;
  dynamic selectedCustomerName;
  dynamic selectedThu;
  DateTime? selectedGioBd;




  getIdentity() async{
    var jsonResponse = await AuthService.getIdentity();
    if (!jsonResponse.keys.contains("message")){
      setState(() {
        nhanvien = jsonResponse["info"];
        manv = nhanvien["_id"].toString();
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    getCustomers() async{
      var jsonResponse = await CustomerService.getAll();
      if (!jsonResponse.keys.contains("message")){
        setState(() {
          customers = jsonResponse["data"];
        });
      }
    }

    getPTs() async{
      var jsonResponse = await PTService.getAll();
      if (!jsonResponse.keys.contains("message")){
        setState(() {
          pts = jsonResponse["data"];
        });
      }
    }

    super.initState();
    getIdentity();
    getPTs();
    getCustomers();
  }

  _selectDateBD(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ngaybd ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      CommonService.popUpMessage('Ngày lập: ${picked}', context);
      setState(() {
        ngaybd = picked;
      });
      _dateStringController.value = _dateStringController.value.copyWith(
          text: CommonService.convertISOToDateOnly(picked.toString())
      );
    }
  }
  _selectDateKT(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ngaykt ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      CommonService.popUpMessage('Ngày kết thúc: ${picked}', context);
      setState(() {
        ngaykt = picked;
      });
      _dateStringKTController.value = _dateStringKTController.value.copyWith(
          text: CommonService.convertISOToDateOnly(picked.toString())
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final currentData = ModalRoute.of(context)!.settings.arguments as String;
    if (currentData.isNotEmpty){
      // _dateStringController.value = _dateStringController.value.copyWith(
      //     text: CommonService.convertISOToDateOnly(DateTime.tryParse(currentData["ngaykiemtra"]).toString())
      // );

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
                                const Text("Lịch hướng dẫn", style: TextStyle(fontSize: 35)),
                                TextFormField(
                                  enabled: false,
                                  initialValue: manv,
                                  decoration:  InputDecoration(
                                      icon: const Icon(Icons.person),
                                      labelText: '${nhanvien["ten"]}',
                                      helperText: 'Nhân viên'
                                  ),
                                ),
                                // PICK DATES
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: _dateStringController,
                                        validator: (value){
                                          if (value == null || ngaybd == null) {
                                            return "Ngày bắt đầu không được trống";
                                          }
                                          return null;
                                        },
                                        decoration:  const InputDecoration(
                                          icon: Icon(Icons.date_range),
                                          labelText: 'Ngày bắt đầu',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ElevatedButton(onPressed:currentData.isEmpty? (){
                                        _selectDateBD(context);
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: _dateStringKTController,
                                        validator: (value){
                                          if (value == null || ngaybd == null) {
                                            return "Ngày kết thúc không được trống";
                                          }
                                          return null;
                                        },
                                        decoration:  const InputDecoration(
                                          icon: Icon(Icons.date_range),
                                          labelText: 'Ngày kết thúc',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ElevatedButton(onPressed:currentData.isEmpty? (){
                                        _selectDateKT(context);
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



                    Row(
                      children:  [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: const Text("Chi Tiết Lịch Hướng Dẫn", style: TextStyle(fontSize: 18),),
                        )
                      ],
                    ),

                    // Detail List View
                    Row(
                      children: [
                        Flexible(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: chitiet.length,
                              itemBuilder: (context, index){
                                return (
                                    Card(
                                      child: ListTile(
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('PT: ${chitiet[index]["tenPt"]}' ),
                                            Text('Khách: ${chitiet[index]["tenKhach"]}')
                                          ],
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${CommonService.convertISOToTimeOnly(chitiet[index]["giobd"])}'),
                                          ],
                                        ),
                                        leading: const Icon(Icons.info),
                                        trailing: IconButton(icon: Icon(Icons.delete), onPressed: () { setState(() {
                                          chitiet.removeAt(index);
                                        }); },),
                                      ),
                                    )
                                );
                              }),
                        )
                      ],
                    ),

                    // Detail Controller
                    currentData.isEmpty? (Column(
                      children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                                value: selectedPtId,
                                decoration: const InputDecoration(icon: Icon(Icons.fitness_center),
                                    labelText: "Chọn pt*"
                                ),
                                validator: (value){
                                  if (value == null || value == "") {
                                    return "Chọn pt";
                                  }
                                  return null;
                                }
                                ,items: pts.map((pt){
                              return DropdownMenuItem(
                                value: pt["_id"],
                                child: Text(pt["ten"]),
                              );
                            }).toList(), onChanged: (value){
                              setState(() {
                                selectedPtId = value;
                                selectedPtName = pts[pts.indexWhere((element) => element["_id"] == value)]["ten"];
                              });
                            }),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                                value: selectedCustomerId,
                                decoration: const InputDecoration(icon: Icon(Icons.payment),
                                    labelText: "Chọn khách*"
                                ),
                                validator: (value){
                                  if (value == null || value == "") {
                                    return "Chọn khách";
                                  }
                                  return null;
                                }
                                ,items: customers.map((pt){
                              return DropdownMenuItem(
                                value: pt["_id"],
                                child: Text(pt["ten"]),
                              );
                            }).toList(), onChanged: (value){
                              setState(() {
                                print(value);
                                selectedCustomerId = value;
                                selectedCustomerName = customers[customers.indexWhere((element) => element["_id"] == value)]["ten"];
                              });
                            }),
                          ),
                        ],
                    ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(selectedGioBd != null ? CommonService.convertISOToDate(selectedGioBd?.toIso8601String() ?? "") : "Chưa chọn", style:
                              const TextStyle(decoration: TextDecoration.underline),)
                          ),
                          Expanded(child: TextButton(
                              onPressed: () {
                                DatePicker.showDateTimePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime(2018, 3, 5),
                                    maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                                    }, onConfirm: (date) {
                                      setState(() {
                                        selectedGioBd = date;
                                      });
                                      CommonService.popUpMessage('Giờ bắt đầu ${CommonService.convertISOToTimeOnly(date.toIso8601String())}.', context);
                                    }, currentTime: DateTime.now(), locale: LocaleType.vi);
                              },
                              child: const Text(
                                'Chọn giờ',
                                style: TextStyle(color: Colors.blue),
                              )))
                        ],
                      ),
                      Row(
                          children: [
                            Expanded(child: ElevatedButton(onPressed: () {
                              if (selectedGioBd ==  null || selectedPtId == null || selectedCustomerId == null){
                                CommonService.popUpMessage("Vui lòng kiếm tra lại chi tiết buổi tập", context);
                                return;
                              }
                              chitiet.add({
                                "giobd": selectedGioBd?.toIso8601String(),
                                "makhach": selectedCustomerId,
                                "mapt": selectedPtId,
                                "tenPt": selectedPtName,
                                "tenKhach": selectedCustomerName
                              });
                              setState(() {
                                selectedGioBd = null;
                                selectedCustomerId = null;
                                selectedPtId = null;
                              });
                            }, child: const Text("Thêm Chi Tiết"),))
                          ]
                      ),

                      // Save Button
                      Row(
                        children: [
                          Expanded(child:
                          ElevatedButton(
                            onPressed: () {
                              save(context);
                            },
                            child: const Text("Lưu Phiếu"), style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.indigo)),
                          ))
                        ],
                      )],
                  )) : SizedBox.shrink()
                  ]
              ),

            ),
          ),
        )
    );
  }
  void save(context) async{
    if (_formKey.currentState!.validate()){
      Map<String, dynamic> response = await LichHDService.add({
        "ngaybd": ngaybd?.toIso8601String(),
        "ngaykt": ngaykt?.toIso8601String(),
        "chitiet": chitiet.map((e) => ({
          "giobd": e["giobd"],
          "makhach": e["makhach"],
          "mapt": e["mapt"]
        })).toList()
      });
      setState(() {
        chitiet = [];
        ngaybd = DateTime.now();
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