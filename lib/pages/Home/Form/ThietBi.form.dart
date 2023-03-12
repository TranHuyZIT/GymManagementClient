import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Services/CommonService.dart';
import 'package:frontend/Services/prodCategoryService.dart';
import 'package:frontend/Services/thietbi.service.dart';
final _formKey = GlobalKey<FormState>();

class ThietBiForm extends StatefulWidget{

  const ThietBiForm({super.key});

  @override
  State<ThietBiForm> createState() => _ThietBiFormState();
}

class _ThietBiFormState extends State<ThietBiForm> {
  String name = "";
  String id = "";
  dynamic selectedLoaiTB;
  List<dynamic> allCategories = [];
  bool isLoading = true;

  @override
  void initState() {
    getCategories() async{
      allCategories = await ProductCategoryService.getAll();
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
        dynamic response = await ThietBiService.add({
          "ten": name,
          "maloaitb": selectedLoaiTB
        }, context);
        setState(() {
          name = "";
          selectedLoaiTB = null;
        });
        Navigator.pop(context);
        return;
      }
      else{
        // update
      }
    }
    CommonService.popUpMessage("Vui lòng kiểm tra lại thông tin thiết bị", context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final currentData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (currentData.isNotEmpty){
      setState(() {
        name = currentData["ten"];
        selectedLoaiTB = currentData["loaitb"]["_id"];
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
                        child: const Center(child: Text("Thiết Bị", style: TextStyle(fontSize: 35),)),
                      ),
                      Form(key: _formKey, autovalidateMode: AutovalidateMode.always, child: Column(
                        children: <Widget>[
                          TextFormField(
                            initialValue: name,
                            validator: (value) {
                              if (value == null || value.isEmpty || value == "") {
                                return "Nhập vào tên";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                icon: Icon(Icons.speaker_notes),
                                hintText: 'Tên thiết bị *',
                                labelText: 'Tên thiết bị *'
                            ),
                            onChanged:(value) => setState(() {
                              name = value;
                            }),
                          ),
                          DropdownButtonFormField(
                            decoration: const InputDecoration(icon: Icon(Icons.speaker_notes),
                              labelText: "Chọn loại thiết bị*"
                            ),
                              validator: (value){
                                if (value == null || value == "") {
                                  return "Chọn loại thiết bị";
                                }
                                return null;
                              }
                              ,items: allCategories.map((prodCate){
                            return DropdownMenuItem(
                              value: prodCate["_id"],
                              child: Text(prodCate["ten"]),
                            );
                          }).toList(), onChanged: (value){
                            setState(() {
                              selectedLoaiTB = value;
                            });
                          }),
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