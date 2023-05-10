import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../Services/CommonService.dart';
import '../Services/LichHD.service.dart';
import 'Material3BottomNav.dart';

class SchedulePT extends StatefulWidget{
  @override
  State<SchedulePT> createState() => _SchedulePTState();
}

class _SchedulePTState extends State<SchedulePT> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _selectedColor = Color(0xff1a73e8);

  final _unselectedColor = Color(0xff5f6368);
  List<Tab> tabs = [];
  dynamic scheduleView;

  dynamic dataState;

  bool loading = true;

  @override
  void initState(){
    super.initState();
    getData() async {
      dynamic data = await LichHDService.getOneForPT();
      setState(() {
        dataState = data;
      });
      List<Tab> tabBars = [];
      for (int i = 0 ; i < data["range"].length; i++){
        tabBars.add(
            Tab(child: Container(
              child: Column(
                children: [
                  Text(data["range"][i]["thu"] == 8 ? "CN" :
                  "Thứ ${data["range"][i]["thu"]}",
                    style: const TextStyle(fontSize: 10),),
                  const SizedBox(height: 5,),
                  Text(CommonService.convertISOToDateWithoutYear(data["range"][i]["date"])
                    , style: TextStyle(fontSize: 10),)
                ],
              ),
            ),)
        );
      }
      setState(() {
        tabs = tabBars;
        scheduleView = data["chitiet"][data["range"][0]["thu"].toString()];
        loading = false;
      });
      _tabController = TabController(length: data["range"].length, vsync: this);
      _tabController.addListener(() {
        String thu = data["range"][_tabController.index]["thu"].toString();
        dynamic schedule = data["chitiet"][thu];
        setState(() {
          scheduleView = schedule;
        });
      });
    }
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size;
    return Scaffold(
      bottomNavigationBar: Material3BottomNav(selectedIndex: 1,),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: size.height * .35,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              image: DecorationImage(
                image: AssetImage("assets/images/undraw_pilates_gpdb.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SafeArea(child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    "Lịch Hướng Dẫn",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontWeight: FontWeight.w900, fontSize: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: size.width * 1, // it just take 60% of total width
                    child: const Center(
                      child: Text(
                          "Xem lịch tập với huấn luyện viên của bạn trong tuần.", style: TextStyle(fontSize: 20)
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  !loading ? TabBar(
                    controller: _tabController,
                    tabs: tabs,
                    labelColor: Colors.black,
                    indicatorColor: Colors.black,
                    unselectedLabelColor: _unselectedColor,
                  ): const SizedBox() ,
                  const SizedBox(height: 20),
                  scheduleView != null ?
                  Column(
                    children: [
                      for (int i = 0 ; i < scheduleView.length; i ++ )
                        Container(
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(CommonService.convertISOToTimeOnly(scheduleView[i]["giobd"])
                                    , style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                                  const lineGen([10.0, 20.0, 30.0, 40.0])
                                ],
                              ),
                              const SizedBox(width: 12,),
                              Expanded(child:
                              Container(
                                height: 120,
                                decoration: const BoxDecoration(
                                    color: Color(0xff654f91),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0)
                                    )
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(left: 8.0),
                                  color: const Color(0xfffcf9f5),
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Text("Buổi Tập", style: TextStyle(fontWeight: FontWeight.bold),),
                                              const VerticalDivider(color: Colors.black, thickness: 1,),
                                              Text(CommonService.convertISOToTime(scheduleView[i]["giobd"]), style:
                                              Theme.of(context)
                                                  .textTheme
                                                  .displaySmall?.copyWith(color: Colors.black, fontSize: 14),),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              const Text("Khách: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                              Text(scheduleView[i]["khach"]["ten"]),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              const Text("SĐT: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                              Text(scheduleView[i]["khach"]["sdt"]),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(width: 12,),
                                      Container(
                                        width: 70,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                            image: DecorationImage(
                                                image: AssetImage("assets/images/meditation_bg.png")
                                            )
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ))
                            ],
                          ),
                        )
                    ],
                  )
                      : Container()
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}

class lineGen extends StatelessWidget{
  final List<double> lines;
  const lineGen(this.lines, {super.key});
  @override
  Widget build(context){
    print(lines);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
      List.generate(4, (index) => Container(
        height: 2.0,
        width: lines[index],
        color: kBlueColor,
        margin: const EdgeInsets.symmetric(vertical: 8),
      )),
    );
  }
}