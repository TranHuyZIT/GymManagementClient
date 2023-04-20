import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Enum/MachineStatus.dart';
import 'package:frontend/Services/Auth.service.dart';
import 'package:frontend/Services/CommonService.dart';
import 'package:frontend/Services/thietbi.service.dart';
import 'package:frontend/Services/thietbiphong.service.dart';
import 'dart:convert' as convert;
import '../../../Services/PhieuNhap.service.dart';
import '../../../Services/phieukiemtra.service.dart';
final _formKey = GlobalKey<FormState>();
class PhieuKiemTraForm extends StatefulWidget{
  @override
  State<PhieuKiemTraForm> createState() => _PhieuKiemTraFormState();
}

class _PhieuKiemTraFormState extends State<PhieuKiemTraForm> {
  final _dateStringController = TextEditingController();
  Map<String, dynamic> nhanvien = <String, dynamic>{};
  List<dynamic> thietbiphongs = [];
  String manv = '';
  String selectedTinhTrang = MachineStatus.defaultStatus;
  DateTime? ngaylap;
  String ghichu = "";
  List<dynamic> chitiet = [
  ];


  dynamic dropDownSelectedId;
  dynamic dropDownSelectedName;
  String tinhtrang = MachineStatus.defaultStatus;
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

    getThietBis() async{
      var jsonResponse = await ThietBiPhongService.getAll();
      if (!jsonResponse.keys.contains("message")){
        setState(() {
          thietbiphongs = jsonResponse["data"];
        });
      }
    }
    super.initState();
    getIdentity();
    getThietBis();
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

  @override
  Widget build(BuildContext context) {
    final currentData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (currentData.isNotEmpty){
      _dateStringController.value = _dateStringController.value.copyWith(
          text: CommonService.convertISOToDateOnly(DateTime.tryParse(currentData["ngaykiemtra"]).toString())
      );
      setState(() {
        ghichu = currentData["ghichu"];
        nhanvien = currentData["nhanvien"];
        ngaylap = DateTime.tryParse(currentData["ngaykiemtra"]);
        chitiet = currentData["chitiet"].map((ele){
          return {
            "tinhtrang": ele["tinhtrang"].toString(),
            "ten": ele["thietbiphong"]["ten"],
            "mathietbiphong": ele["thietbiphong"]["id"].toString()
          };
        }).toList();
        getIdentity();
      });
    }
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
                                const Text("Phiếu Kiểm Tra", style: TextStyle(fontSize: 35)),
                                TextFormField(
                                  initialValue: ghichu,
                                  enabled: currentData.isEmpty,
                                  decoration:  const InputDecoration(
                                      icon: Icon(Icons.note),
                                      labelText: 'Ghi chú',
                                      helperText: 'Ghi chú'
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      ghichu = value;
                                    });
                                  },
                                ),
                                TextFormField(
                                  enabled: false,
                                  initialValue: manv,
                                  decoration:  InputDecoration(
                                      icon: const Icon(Icons.person),
                                      labelText: '${nhanvien["ten"]}',
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

                    Row(
                      children:  [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: const Text("Chi Tiết Phiếu Kiểm Tra", style: TextStyle(fontSize: 18),),
                        )
                      ],
                    ),
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
                                        title: Text(chitiet[index]["ten"]),
                                        subtitle: Text(chitiet[index]["tinhtrang"]),
                                        leading: const Icon(Icons.info),
                                      ),
                                    )
                                );
                              }),
                        )
                      ],
                    ),
                    currentData.isEmpty? (Column(
                      children: [Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                                value: dropDownSelectedId,
                                decoration: const InputDecoration(icon: Icon(Icons.speaker_notes),
                                    labelText: "Chọn thiết bị phòng*"
                                ),
                                validator: (value){
                                  if (value == null || value == "") {
                                    return "Chọn thiết bị phòng";
                                  }
                                  return null;
                                }
                                ,items: thietbiphongs.map((thietbi){
                              return DropdownMenuItem(
                                value: thietbi["_id"],
                                child: Text(thietbi["ten"]),
                              );
                            }).toList(), onChanged: (value){
                              setState(() {
                                dropDownSelectedId = value;
                                dropDownSelectedName = thietbiphongs[thietbiphongs.indexWhere((element) => element["_id"] == value)]["ten"];
                              });
                            }),
                          ),
                        ],
                      ),
                        Row(
                            children: [
                              Expanded(flex: 2,
                                      child:
                                      DropdownButtonFormField(
                                          value: selectedTinhTrang,
                                          decoration: const InputDecoration(icon: Icon(Icons.speaker_notes),
                                              labelText: "Chọn tình trạng*"
                                          ),
                                          validator: (value){
                                            if (value == null || value == "") {
                                              return "Chọn tình trạng";
                                            }
                                            return null;
                                          }
                                          ,items: MachineStatus.getAllStatus().map((String tinhtrangOption){
                                        return DropdownMenuItem(
                                          value: tinhtrangOption,
                                          child: Text(tinhtrangOption),
                                        );
                                      }).toList(), onChanged: ( value){
                                        setState(() {
                                          selectedTinhTrang = value.toString();
                                        });
                                      })
                              ),
                              Expanded(flex: 1, child: ElevatedButton(onPressed: (){
                                setState(() {
                                  chitiet.add({
                                    "tinhtrang": selectedTinhTrang,
                                    "ten": dropDownSelectedName,
                                    "mathietbiphong": dropDownSelectedId
                                  });
                                });
                              }, child: const Text("Thêm")))
                            ]
                        ),
                        Row(
                          children: [
                            Expanded(child:
                            ElevatedButton(
                              onPressed: () {
                                save(context);
                              },
                              child: const Text("Lưu Phiếu"),
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
      Map<String, dynamic> response = await PhieuKiemTraService.add({
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