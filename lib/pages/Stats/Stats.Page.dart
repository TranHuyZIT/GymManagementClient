import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Services/Log.service.dart';
import 'package:frontend/pages/Shared/BottomNavigationBar.dart';
import 'package:frontend/pages/Stats/GDPStats.dart';
import 'CustomerStats.dart';


class StatsPage extends StatefulWidget {
  const StatsPage({super.key, required this.title});
  final String title;

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  Future<void> _refresh()async {
    setState(() {

    });
  }

  @override
  void initState(){
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: const TabBar(tabs: [
            Tab(child: Text("Thống kê người tập"),),
            Tab(child: Text("Thống kê doanh thu"),),
          ],),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: TabBarView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  width: 410,
                  height: 400,
                  child: CustomerStats(),
                )],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  width: 410,
                  height: 400,
                  child: GDPStats(),
                ),]
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationShared(currentIndex: 2,),
      ),
    );
  }
}
