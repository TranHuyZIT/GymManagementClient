import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Services/CommonService.dart';
import 'package:frontend/Services/prodCategoryService.dart';
import 'package:frontend/Services/thietbi.service.dart';
final _formKey = GlobalKey<FormState>();

class LoaiThietBiForm extends StatefulWidget{

  const LoaiThietBiForm({super.key});

  @override
  State<LoaiThietBiForm> createState() => _LoaiThietBiFormState();
}

class _LoaiThietBiFormState extends State<LoaiThietBiForm> {
  String name = "";
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
        dynamic response = await ProductCategoryService.add({
          "ten": name,
        }, context);
        setState(() {
          name = "";
        });
        Navigator.pop(context);
        return;
      }
      else{
        dynamic response = await ProductCategoryService.update({
          "ten": name,
        }, id, context);
        setState(() {
          name = "";
          id = "";
        });
        Navigator.pop(context);
      }
    }
    CommonService.popUpMessage("Vui lòng kiểm tra lại thông tin loại thiết bị", context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final currentData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (currentData.isNotEmpty && id == ""){
      setState(() {
        name = currentData["ten"];
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
                        child: const Center(child: Text("Loại Thiết Bị", style: TextStyle(fontSize: 35),)),
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
                                hintText: 'Tên Thiết Bị *',
                                labelText: 'Tên Thiết Bị *'
                            ),
                            onChanged:(value) => setState(() {
                              name = value;
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