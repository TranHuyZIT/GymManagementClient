import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Services/Auth.service.dart';
import 'package:frontend/Services/CommonService.dart';
import 'package:frontend/Services/thietbi.service.dart';
import 'dart:convert' as convert;
import '../../../Services/PhieuNhap.service.dart';
final _formKey = GlobalKey<FormState>();
class PhieuNhapForm extends StatefulWidget{
  @override
  State<PhieuNhapForm> createState() => _PhieuNhapFormState();
}

class _PhieuNhapFormState extends State<PhieuNhapForm> {
    final _dateStringController = TextEditingController();
   Map<String, dynamic> nhanvien = <String, dynamic>{};
   List<dynamic> thietbis = [];
   String manv = '';
   DateTime? ngaylap;
   List<dynamic> chitiet = [
   ];


  dynamic dropDownSelectedId;
  dynamic dropDownSelectedName;
   dynamic gianhap;
  @override
  void initState() {
    // TODO: implement initState
    getIdentity() async{
      var jsonResponse = await AuthService.getIdentity();
      if (!jsonResponse.keys.contains("message")){
        print(jsonResponse);
        setState(() {
          nhanvien = jsonResponse;
          manv = nhanvien["info"]["id"].toString();
        });
      }
    }
    getThietBis() async{
      var jsonResponse = await ThietBiService.getAll();
      if (!jsonResponse.keys.contains("message")){
        setState(() {
          thietbis = jsonResponse["data"];
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
          text: CommonService.convertISOToDateOnly(DateTime.tryParse(currentData["ngaynhap"]).toString())
      );
      setState(() {
        nhanvien = currentData["nhanvien"];
        ngaylap = DateTime.tryParse(currentData["ngaynhap"]);
        chitiet = currentData["chitiet"].map((ele){
          return {
            "gianhap": ele["gianhap"].toString(),
            "ten": ele["thietbiphong"]["ten"],
            "matb": ele["thietbiphong"]["thietbi"]["id"].toString()
          };
        }).toList();
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
                        const Text("Phiếu Nhập", style: TextStyle(fontSize: 35)),
                        TextFormField(
                          enabled: false,
                          initialValue: manv,
                          decoration:  InputDecoration(
                            icon: const Icon(Icons.person),
                            labelText: '${nhanvien["ten"]} - #${manv}',
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
                    child: const Text("Chi Tiết Phiếu Nhập", style: TextStyle(fontSize: 18),),
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
                                  subtitle: Text(CommonService.formatVND(chitiet[index]["gianhap"])),
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
                              labelText: "Chọn loại thiết bị*"
                          ),
                          validator: (value){
                            if (value == null || value == "") {
                              return "Chọn loại thiết bị";
                            }
                            return null;
                          }
                          ,items: thietbis.map((thietbi){
                        return DropdownMenuItem(
                          value: thietbi["_id"],
                          child: Text(thietbi["ten"]),
                        );
                      }).toList(), onChanged: (value){
                        setState(() {
                          dropDownSelectedId = value;
                          dropDownSelectedName = thietbis[thietbis.indexWhere((element) => element["_id"] == value)]["ten"];
                        });
                      }),
                    ),
                  ],
                ),
                  Row(
                      children: [
                        Expanded(flex: 1, child:
                        TextFormField(
                          initialValue: '0',
                          validator: (value) {
                            if (value == null || value == '' || value == '0'  ){
                              return "Giá nhập không hợp lệ";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              icon: Icon(Icons.price_change),
                              labelText: "Giá Nhập"
                          ),
                          onChanged: (value){
                            setState(() {
                              gianhap = value;
                            });
                          },
                        )
                        ),
                        Expanded(flex: 1, child: ElevatedButton(onPressed: (){

                          setState(() {
                            chitiet.add({
                              "gianhap": gianhap,
                              "ten": dropDownSelectedName,
                              "matb": dropDownSelectedId
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
        print({
          "ngaynhap": ngaylap?.toIso8601String(),
          "manv": manv,
          "chitiet": chitiet
        });
        Map<String, dynamic> response = await PhieuNhapService.add({
          "ngaynhap": ngaylap?.toIso8601String(),
          "manv": manv,
          "chitiet": chitiet
        });
        setState(() {
          chitiet = [];
          ngaylap = DateTime.now();
        });
        CommonService.popUpMessage("Lưu thành công", context);
        Navigator.pop(context);
        return;

      }
      CommonService.popUpMessage("Vui lòng kiểm tra lại thông tin phiếu nhập", context);
    }
}