import 'package:flutter/material.dart';
import 'package:frontend/pages/Home/Section/LoaiThietBi.dart';
import 'package:frontend/pages/Home/Section/ThietBi.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: [
            LoaiThietBiSection(),
            ThietBiSection(),
            ThietBiPhongSection()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Phòng Tập',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Phiếu Lập',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Thống Kê',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Quản Trị',
            backgroundColor: Colors.blue,
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.white,
        onTap: (int currentIdx){
          switch(currentIdx) {
            case 0:
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) => MyHomePage(title: "Trần Huy Gym")),
                  ModalRoute.withName('/home'));
              break;
            case 1:
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => InvoicesPage()),
                  ModalRoute.withName('/invoices'));
              break;
          }
        },
      ),
    );
  }
}
