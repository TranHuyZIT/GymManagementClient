import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/Home/MyHomepage.dart';
import 'package:frontend/pages/Invoices/Section/PhieuKiemTra.dart';

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
      appBar: AppBar(
        title: const Text("Trần Huy Gym"),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FractionallySizedBox(
          heightFactor: 0.8,
          child: Row(
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
                        ElevatedButton(onPressed: (){}, child: const Text("Truy Cập"))
                      ],
                    ),
                  )
              )
            ],
          ),
        )
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
        currentIndex: 1,
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

