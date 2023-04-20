import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Services/CommonService.dart';

import '../../../Services/goipt.service.dart';
final _formKey = GlobalKey<FormState>();

class GoiPTForm extends StatefulWidget{

  const GoiPTForm({super.key});

  @override
  State<GoiPTForm> createState() => _GoiPTFormState();
}

class _GoiPTFormState extends State<GoiPTForm> {
  String name = "";
  String gia = "0";
  String songay = "0";
  String id = "";
  bool isLoading = true;

  @override
  void initState() {
    getCategories() async{
      setState(() {
        isLoading = false;
      });
    }
    // TODO: implement initState
    super.initState();
    getCategories();
  }

  void save(context) async{
    if (_formKey.currentState!.validate()){
      if (id == ""){
        Map<String, dynamic> response = await GoiPTService.add({
          "ten": name,
          "songay": int.parse(songay),
          "gia": int.parse(gia)
        }, context);
        if (response.keys.contains("message")){
          CommonService.popUpMessage(response["message"], context);
          return;
        }
        CommonService.popUpMessage("Thêm thành công", context);
        Navigator.pop(context);
        return;
      }
      else{
        dynamic response = await GoiPTService.update({
          "ten": name,
          "songay": int.parse(songay),
          "gia": int.parse(gia),
          "_id": id
        }, context);
        Navigator.pop(context);
        return;
      }
    }
    CommonService.popUpMessage("Vui lòng kiểm tra lại thông tin gói pt", context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final currentData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (currentData.isNotEmpty && id == ""){
      setState(() {
        name = currentData["ten"];
        gia = currentData["gia"].toString();
        songay = currentData["songay"].toString();
        id = currentData["_id"];
      });
    }
    return Builder(
      builder: (context){
        if (!isLoading){
          return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: const Text("Trần Huy Gym"),
              ),
              body: Container(
                padding: const EdgeInsets.all(20),
                width: 400,
                child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: const Center(child: Text("Gói PT", style: TextStyle(fontSize: 35),)),
                      ),
                      Form(key: _formKey, autovalidateMode: AutovalidateMode.always, child: Column(
                        children: <Widget>[
                          TextFormField(
                            initialValue: name,
                            validator: (value) {
                              if (value == null || value.isEmpty || value == "" || value == "0") {
                                return "Nhập vào tên";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                icon: Icon(Icons.speaker_notes),
                                hintText: 'Tên Gói PT *',
                                labelText: 'Tên Gói PT *'
                            ),
                            onChanged:(value) => setState(() {
                              name = value;
                            }),
                          ),
                          TextFormField(
                            initialValue: songay.toString(),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty || value == ""|| value == "0") {
                                return "Nhập vào số ngày";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                icon: Icon(Icons.speaker_notes),
                                hintText: 'Số ngày *',
                                labelText: 'Số ngày *'
                            ),
                            onChanged:(value) => setState(() {
                              songay = value;
                            }),
                          ),
                          TextFormField(
                            initialValue: gia.toString(),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty || value == "" || value == "0") {
                                return "Nhập vào giá";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                icon: Icon(Icons.speaker_notes),
                                hintText: 'Giá *',
                                labelText: 'Giá *'
                            ),
                            onChanged:(value) => setState(() {
                              gia = value;
                            }),
                          ),
                          ElevatedButton(onPressed: () => save(context), child: const Text("Lưu")),
                        ],
                      ))
                    ]
                ),
              )
          );
        }
        return Scaffold(
            appBar: AppBar(title: const Text("Trần Huy Gym"),
            ),
            body: SizedBox(
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator()
                ],
              ),
            )
        );
      },
    );
  }
}