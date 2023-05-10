import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/Home/MyHomepage.dart';
import 'package:frontend/pages/Invoices/Section/Checkin.dart';
import 'package:frontend/pages/Invoices/Section/HoaDon.dart';
import 'package:frontend/pages/Invoices/Section/LichHD.dart';
import 'package:frontend/pages/Invoices/Section/PhieuKiemTra.dart';
import 'package:frontend/pages/Shared/BottomNavigationBar.dart';
import 'package:frontend/pages/Users/UsersPage.dart';

import 'Section/PhieuNhap.dart';

class InvoicesPage extends StatefulWidget{
  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  Future<void> _refresh()async {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarShared(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FractionallySizedBox(
          heightFactor: 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                      child: Container(
                        width: 120,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            const Icon(Icons.post_add),
                            const Text("Phiếu Nhập"),
                            ElevatedButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PhieuNhap()));
                            }, child: const Text("Truy Cập"))
                          ],
                        ),
                      )
                  ),
                  Card(
                      child: Container(
                        width: 120,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            const Icon(Icons.fact_check),
                            const Text("Phiếu Kiểm Tra"),
                            ElevatedButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PhieuKiemTra()));

                            }, child: const Text("Truy Cập"))
                          ],
                        ),
                      )
                  ),
                  Card(
                      child: Container(
                        width: 120,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            const Icon(Icons.storefront),
                            const Text("Hóa Đơn"),
                            ElevatedButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HoaDon()));

                            }, child: const Text("Truy Cập"))
                          ],
                        ),
                      )
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                      child: Container(
                        width: 120,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            const Icon(Icons.fitness_center),
                            const Text("Lịch Hướng Dẫn"),
                            ElevatedButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LichHD()));
                            }, child: const Text("Truy Cập"))
                          ],
                        ),
                      )
                  ),
                  Card(
                      child: Container(
                        width: 120,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            const Icon(Icons.search),
                            const Text("Check-in"),
                            ElevatedButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CheckInSection()));
                            }, child: const Text("Truy Cập"))
                          ],
                        ),
                      )
                  ),
                ],
              )
            ]
          ),
        )
      ),
      bottomNavigationBar: BottomNavigationShared(currentIndex: 0,),
    );
  }
}

