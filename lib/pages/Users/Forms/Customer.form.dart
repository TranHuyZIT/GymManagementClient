import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Services/CommonService.dart';
import 'package:frontend/Services/customer.service.dart';
import 'package:frontend/Services/prodCategoryService.dart';
import 'package:frontend/Services/thietbi.service.dart';
enum Gender { MALE, FEMALE }



final _formKey = GlobalKey<FormState>();

class CustomerForm extends StatefulWidget{

  const CustomerForm({super.key});

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _dateStringController = TextEditingController();
  String name = "";
  DateTime? ngaysinh;
  String sdt = "";
  Gender gioitinh = Gender.MALE;
  String cccd = "";
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

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ngaysinh ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      CommonService.popUpMessage('Ngày sinh: ${picked}', context);
      setState(() {
        ngaysinh = picked;
      });
      _dateStringController.value = _dateStringController.value.copyWith(
          text: CommonService.convertISOToDateOnly(picked.toString())
      );
    }
  }

  void save(context) async{
    if (_formKey.currentState!.validate()){
      if (id == ""){
        Map<String, dynamic> response = await CustomerService.tao({
          "ten": name,
          "ngaysinh": ngaysinh?.toIso8601String(),
          "sdt": sdt,
          "cccd": cccd,
          "gioitinh": gioitinh == Gender.MALE ? true: false
        }, context);
        if (response.keys.contains("message")){
          CommonService.popUpMessage(response["message"], context);
          return;
        }
        print(response);
        CommonService.popUpMessage("Thêm khách hàng thành công", context);
        Navigator.pop(context);
        return;
      }
      else{
        dynamic response = await ThietBiService.update({
          "ten": name,
          "_id": id
        }, context);
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
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                title: const Text("Trần Huy Gym"),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: 400,
                  child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: const Center(child: Text("Khách Hàng", style: TextStyle(fontSize: 35),)),
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
                                  hintText: 'Tên *',
                                  labelText: 'Tên *'
                              ),
                              onChanged:(value) => setState(() {
                                name = value;
                              }),
                            ),
                            TextFormField(
                              initialValue: sdt,
                              validator: (value) {
                                if (value == null || value.isEmpty || value == "") {
                                  return "Nhập vào số điện thoại";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.speaker_notes),
                                  hintText: 'Số điện thoại *',
                                  labelText: 'Số điện thoại *'
                              ),
                              onChanged:(value) => setState(() {
                                sdt = value;
                              }),
                            ),
                            TextFormField(
                              readOnly: true,
                              controller: _dateStringController,
                              validator: (value){
                                if (value == null || ngaysinh == null) {
                                  return "Ngày sinh không được trống";
                                }
                                return null;
                              },
                              decoration:  const InputDecoration(
                                icon: Icon(Icons.date_range),
                                labelText: 'Ngày sinh',
                              ),
                            ),
                            ElevatedButton(onPressed: () => _selectDate(context), child: const Text("Chọn ngày")),
                            Container(
                              width: 400,
                              child: Row(
                                children: [
                                  const Expanded(child: Text("Giới tính")),
                                  Expanded(
                                    flex: 2,
                                    child: ListTile(
                                      title: const Text('Nam'),
                                      leading: Radio<Gender>(
                                        value: Gender.MALE,
                                        groupValue: gioitinh,
                                        onChanged: (Gender? value) {
                                          setState(() {
                                            gioitinh = value!;
                                          });
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
                                          setState(() {
                                            gioitinh = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextFormField(
                              initialValue: cccd,
                              validator: (value) {
                                if (value == null || value.isEmpty || value == "") {
                                  return "Nhập vào số cccd";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.speaker_notes),
                                  hintText: 'Căn cước công dân *',
                                  labelText: 'Căn cước công dân *'
                              ),
                              onChanged:(value) => setState(() {
                                cccd = value;
                              }),
                            ),
                          ],
                        )),
                        ElevatedButton(onPressed: (){
                          save(context);
                        }, child: const Text("Lưu"))
                      ]
                  ),
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
