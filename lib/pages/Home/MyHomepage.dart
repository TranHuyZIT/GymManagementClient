import 'package:flutter/material.dart';
import 'package:frontend/pages/Home/Section/GoiPT.dart';
import 'package:frontend/pages/Home/Section/GoiTap.dart';
import 'package:frontend/pages/Home/Section/LoaiThietBi.dart';
import 'package:frontend/pages/Home/Section/ThietBi.dart';
import 'package:frontend/pages/Shared/BottomNavigationBar.dart';
import 'package:frontend/pages/Users/UsersPage.dart';
import '../../core/Colors.Hex_Color.dart';
import '../Invoices/InvoicesPage.dart';
import 'Section/ThietBiPhong.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _refresh()async {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text(widget.title),
          bottom: const TabBar(tabs: [
            Tab(text: "Trang Thiết Bị"),
            Tab(text: "Thiết Bị Phòng"),
            Tab(text: "Gói Tập và PT"),
          ]),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: Container(
          decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              HexColor("#fff").withOpacity(0.2), BlendMode.dstATop),
            image: const NetworkImage(
            'https://mir-s3-cdn-cf.behance.net/project_modules/fs/01b4bd84253993.5d56acc35e143.jpg',
            ),
            ),
          ),
            child: Center(
              child: Card(
                elevation: 5,
                child: TabBarView(
                  children: [
                    ListView(
                      children: [
                        LoaiThietBiSection(),
                        ThietBiSection(),
                      ],
                    ),
                    ListView(
                      children: [
                        ThietBiPhongSection(),
                      ],
                    ),
                    ListView(
                      children: [
                        GoiTapSection(),
                        GoiPTSection()
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
          ),
        bottomNavigationBar: BottomNavigationShared(currentIndex: 1,),
        ),
      );
  }
}



