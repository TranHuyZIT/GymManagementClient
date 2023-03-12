import 'package:flutter/material.dart';
import 'package:frontend/pages/Home/Section/ThietBi.dart';
import 'package:frontend/request.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:localstorage/localstorage.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var prodCategories = [];
  var products = [];
  var facilityProducts = [];
  final LocalStorage storage = new LocalStorage('app');
  Future<void>  getAllProdCategories () async {
    Response response = await RequestUtil.request("get", "/loaithietbi");
    var jsonResponse =
    convert.jsonDecode(response.body) as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    getAllProdCategories();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ThietBiSection(),
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
        onTap: (int currentIdx){},
      ),
    );
  }
}
