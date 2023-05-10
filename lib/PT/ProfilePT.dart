import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/PT/Material3BottomNav.dart';
import 'package:frontend/Services/CommonService.dart';
import 'package:frontend/Services/pt.service.dart';
import 'package:localstorage/localstorage.dart';

import '../pages/Authentication/Login.dart';

class ProfilePT extends StatefulWidget {
  ProfilePT({Key? key}) : super(key: key);

  @override
  State<ProfilePT> createState() => _ProfilePTState();
}

class _ProfilePTState extends State<ProfilePT> {
  dynamic data;
  Map<String, dynamic> profileData = {
    "ten": "",
    "sdt": "",
    "chieucao": "",
    "cannang": "",
  };
  void _saveProfile() async{
    var jsonResponse = await PTService.update(data["_id"], profileData);
    if (jsonResponse.containsKey("message")){
      CommonService.popUpMessage(jsonResponse["message"], context);
      return;
    }
    Navigator.pop(context);
    CommonService.popUpMessage("Cập nhật thành công", context);
    initState();
  }
  @override
  void initState(){
    getSelfInfo() async{
      var jsonResponse = await PTService.getSelf();
      print(jsonResponse);
      setState(() {
        data = jsonResponse;
        profileData["ten"] = data["ten"];
        profileData["sdt"] = data["sdt"];
        profileData["chieucao"] = data["chieucao"].toString();
        profileData["cannang"] = data["cannang"].toString();
      });
    }
    getSelfInfo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Material3BottomNav(selectedIndex: 1,),
      body: data != null ? Column(
        children: [
          const Expanded(flex: 2, child: _TopPortion()),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data["ten"],
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(onPressed: (){
                        showDialog(context: context, builder: (context) =>
                            AlertDialog(
                              title: const Text("Cập Nhật Thông Tin"),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    TextFormField(
                                      initialValue: profileData["ten"],
                                      decoration: const InputDecoration(
                                        labelText: "Tên",
                                        icon: Icon(Icons.tag),
                                        helperText: 'VD: Trần Gia Huy'
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          profileData["ten"] = value;
                                        });
                                      },
                                    ),
                                    TextFormField(
                                      initialValue: profileData["chieucao"],
                                      keyboardType: const TextInputType.numberWithOptions(),
                                      decoration: const InputDecoration(
                                          labelText: "Chiều cao",
                                          icon: Icon(Icons.height),
                                          suffix: Text("cm"),
                                          helperText: 'VD: 180cm'
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          profileData["chieucao"] = value;
                                        });
                                      },
                                    ),
                                    TextFormField(
                                      keyboardType: const TextInputType.numberWithOptions(),
                                      initialValue: profileData["cannang"],
                                      decoration: const InputDecoration(
                                          labelText: "Cân nặng",
                                          icon: Icon(Icons.scale),
                                          suffix: Text("kg"),
                                          helperText: 'VD: 70kg'
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          profileData["cannang"] = value;
                                        });
                                      },
                                    ),
                                    TextFormField(
                                      keyboardType: const TextInputType.numberWithOptions(),
                                      initialValue: profileData["sdt"],
                                      decoration: const InputDecoration(
                                          labelText: "SĐT",
                                          icon: Icon(Icons.phone),
                                          helperText: 'VD: 0939067106'
                                      ),
                                      onChanged: (value){
                                        setState(() {
                                          profileData["sdt"] = value;
                                        });
                                      },
                                    ),
                                    ElevatedButton(onPressed: (){
                                      _saveProfile();
                                    },
                                        style:
                                        const ButtonStyle(
                                            backgroundColor:
                                            MaterialStatePropertyAll
                                              (Colors.indigo)),
                                        child: const Text("Lưu"))
                                  ],
                                ),
                              ),
                            )
                        );
                      }, icon: const Icon(Icons.edit))
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {
                          showDialog(context: context, builder: (context) => (
                            AlertDialog(
                              title: const Text ("Khách huấn luyện"),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    for (int i = 0 ; i < data["khach"].length; i++)
                                      HistoryCard(data["khach"][i])
                                  ],
                                ),
                              ),
                            )
                          ));
                        },
                        heroTag: 'customer',
                        elevation: 0,
                        label: const Text("Xem Khách"),
                        icon: const Icon(Icons.person),
                      ),
                      const SizedBox(width: 16.0),
                      FloatingActionButton.extended(
                        onPressed: () {
                          signOut();
                        },
                        heroTag: 'signout',
                        elevation: 0,
                        backgroundColor: Colors.red,
                        label: const Text("Đăng Xuất"),
                        icon: const Icon(Icons.logout),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                   _ProfileInfoRow(statList: [data["createdAt"], data["chieucao"], data["cannang"]],)
                ],
              ),
            ),
          ),
        ],
      ) : Column(),
    );
  }
  void signOut(){
    LocalStorage localStorage = LocalStorage("app");
    localStorage.deleteItem("token");
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), ModalRoute.withName("/login"));
  }
}

class _ProfileInfoRow extends StatefulWidget {
  final List<dynamic> statList;

   _ProfileInfoRow({Key? key, required this.statList}) : super(key: key);

  @override
  State<_ProfileInfoRow> createState() => _ProfileInfoRowState();
}

class _ProfileInfoRowState extends State<_ProfileInfoRow> {
  List<ProfileInfoItem> _items = [];

  @override
  void initState(){
    super.initState();
    setState(() {
      _items = [
        ProfileInfoItem("Ngày Đăng Ký", widget.statList.isNotEmpty ?  CommonService.convertISOToDateOnly(widget.statList[0]) : ""),
        ProfileInfoItem("Chiều cao", widget.statList.isNotEmpty ?  widget.statList[1] : ""),
        ProfileInfoItem("Cân nặng", widget.statList.isNotEmpty ?  widget.statList[2] : ""),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
            child: Row(
              children: [
                if (_items.indexOf(item) != 0) const VerticalDivider(),
                Expanded(child: _singleItem(context, item)),
              ],
            )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          item.value.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
      Text(
        item.title,
        style: Theme.of(context).textTheme.caption,
      )
    ],
  );
}

class ProfileInfoItem {
  final String title;
  final dynamic value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xff0043ba), Color(0xff006df1)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/job.png")),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}


class HistoryCard extends StatelessWidget{
  dynamic dky;
  HistoryCard( this.dky, {super.key});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      height: 140,
      width: 300,
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
          Padding(
            padding: EdgeInsets.all(10),
            child: Image.asset("assets/images/gym.png"),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    "Khách: ${dky["makhach"]["ten"]}",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Container(margin: const EdgeInsets.fromLTRB(0, 10, 0, 0), child: Text("Ngày hết hạn: ${CommonService.convertISOToDateOnly(dky["ngayhethan"])}")),
                Container(margin: const EdgeInsets.fromLTRB(0, 10, 0, 0), child: Text("SĐT: ${CommonService.convertISOToDateOnly(dky["makhach"]["sdt"])}")),
              ],
            ),
          ),

        ],
      ),
    );
  }

}