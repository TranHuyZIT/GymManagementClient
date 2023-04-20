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
final _formKey = GlobalKey<FormState>();
class LichHDView extends StatefulWidget{
  var currentData;

   LichHDView({super.key, this.currentData} );

  @override
  State<LichHDView> createState() => _LichHDViewState(currentData: currentData);
}

class _LichHDViewState extends State<LichHDView> {
  _LichHDViewState({this.currentData} );
  dynamic currentData;

  final _dateStringController = TextEditingController();
  final _dateStringKTController = TextEditingController();
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
  DateTime? ngaybd;
  DateTime? ngaykt;
  dynamic chitiets;
  List<TableRow> chitietRows = [];


  @override
  void initState() {
    getLichHD(id) async{
      var jsonResponse = await LichHDService.getOne(id);
      if (!jsonResponse.keys.contains("message")){
        setState(() {
          _dateStringController.value = _dateStringController.value.copyWith(text: CommonService.convertISOToDateOnly(jsonResponse["ngaybd"]));
          _dateStringKTController.value = _dateStringKTController.value.copyWith(text: CommonService.convertISOToDateOnly(jsonResponse["ngaykt"]));
          chitiets = jsonResponse["chitiet"];
        });
        generateTableRow(jsonResponse["chitiet"]);
      }
    }
    getLichHD(currentData);
    super.initState();
  }
  void generateTableRow(chitiets){
    List<TableRow>  result = [];
    if (chitiets == null){
      return;
    }
    result.add(const TableRow(
        decoration: BoxDecoration(
            color: Colors.blueAccent
        ),
        children: [
          Padding(padding: EdgeInsets.fromLTRB(10, 20, 10, 20),child: Center(child: Text("Thứ", style: TextStyle(color: Colors.white),))),
          Padding(padding: EdgeInsets.fromLTRB(10, 20, 10, 20),child: Center(child: Text("Khách", style: TextStyle(color: Colors.white),))),
          Padding(padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Center(child: Text("Huấn luyện viên",  style: TextStyle(color: Colors.white),))),
        ]
    ));
    for (var i = 2; i <= 8; i++){
      result.add(
        TableRow(
          decoration: BoxDecoration(
            color: Colors.grey[200]
          ),
            children: [
              Padding(padding: EdgeInsets.all(10),
              child: Center(child: Text("Thứ ${i.toString()}"))),
              const TableCell(child: Text("")),
              const TableCell(child: Text("")),
            ]
        ),
      );
      if (chitiets[i.toString()] == null) {
        return;
      }
      for (var j = 0 ; j < chitiets[i.toString()].length; j++){
        result.add(
            TableRow(
                children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Center(child: Text(CommonService.convertISOToTime(chitiets[i.toString()][j]["giobd"])))),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Center(child: Text(chitiets[i.toString()][j]["khach"]["ten"]))),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Center(child: Text(chitiets[i.toString()][j]["pt"]["ten"])))
                ]
            )
        );
      }
    }
    setState(() {
      chitietRows = result;
    });
  }

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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("Lịch hướng dẫn", style: TextStyle(fontSize: 35)),
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
                                ],
                              ),
                            ],
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
                    Row(
                      children: [
                        Expanded(
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(1),
                              1: FlexColumnWidth(2),
                              2: FlexColumnWidth(2),
                            },
                            children: chitietRows
                          ),
                        )
                      ],
                    )

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
        "chitiet": chitiets.map((e) => ({
          "giobd": e["giobd"],
          "makhach": e["makhach"],
          "mapt": e["mapt"]
        })).toList()
      });
      setState(() {
        chitiets = [];
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