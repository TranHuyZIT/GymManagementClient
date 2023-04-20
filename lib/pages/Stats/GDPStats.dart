import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import '../../Services/CommonService.dart';
import '../../Services/Log.service.dart';
import 'AppColors.dart';

class GDPStats extends StatefulWidget{

  GDPStats({super.key,});


  @override
  State<GDPStats> createState() => _GDPStatsState( );
}

class _GDPStatsState extends State<GDPStats> {
  dynamic data;
  dynamic dataSide;
  dynamic dataBottom;
  dynamic maxYState = 0;
  dynamic maxBotState = 0;

  getStat(DateTime? ngaybd, DateTime? ngaykt) async{
    if (ngaybd == null || ngaykt == null) return;
    var queries = <String, dynamic>{
      'ngaybd': ngaybd.toIso8601String(),
      'ngaykt': ngaykt.toIso8601String()
    };
    var jsonResponse = await LogService.getDoanhThuStats(queries: queries);

    generateSpots(jsonResponse);


  }

  @override
  void initState(){
    super.initState();
    getStat(null, null);
  }

  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];
  DateTime? ngaybd;
  DateTime? ngaykt;
  final _dateStringControllerStart = TextEditingController();
  final _dateStringControllerEnd = TextEditingController();
  _selectDateStart(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ngaybd ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      CommonService.popUpMessage('Ngày BĐ: ${picked}', context);
      getStat(picked, ngaykt);
      setState(() {
        ngaybd = picked;

      });
      _dateStringControllerStart.value = _dateStringControllerStart.value.copyWith(
          text: CommonService.convertISOToDateOnly(picked.toString())
      );
    }
  }
  _selectDateEnd(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ngaykt ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      CommonService.popUpMessage('Ngày KT: ${picked}', context);
      getStat(ngaybd, picked);
      setState(() {
        ngaykt = picked;
      });
      _dateStringControllerEnd.value = _dateStringControllerEnd.value.copyWith(
          text: CommonService.convertISOToDateOnly(picked.toString())
      );
    }
  }
  List<FlSpot> spots =[];

  List<FlSpot> generateSpots(dynamic data){
    if (data == null) return [];
    List<FlSpot> spotsLocal = [];
    for(dynamic spot in data["spot"]){
      spotsLocal.add(FlSpot(spot["x"].toDouble(), spot["y"].toDouble()));
    }
    setState(() {
      spots = spotsLocal;
      this.data = data;
      dataSide = data["side"];
      dataBottom = data["bot"];
      maxYState = data["side"]["maxSide"]["value"];
      maxBotState = data["bot"]["maxBot"]["key"];
    });

    return spotsLocal;
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Expanded(child: Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),child: Center(child: Text("Thống kê doanh thu", style: TextStyle(fontSize: 25),))))
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                readOnly: true,
                controller: _dateStringControllerStart,
                validator: (value){
                  if (value == null || ngaybd == null) {
                    return "Ngày BĐ không được trống";
                  }
                  return null;
                },
                decoration:  const InputDecoration(
                  icon: Icon(Icons.date_range),
                  labelText: 'Ngày bắt đầu',
                ),
              ),
            ),
            Expanded(flex: 1,child: ElevatedButton(child: const Text("Chọn"), onPressed: (){
              _selectDateStart(context);
            },))
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                readOnly: true,
                controller: _dateStringControllerEnd,
                validator: (value){
                  if (value == null || ngaykt == null) {
                    return "Ngày kết thúc không được trống";
                  }
                  return null;
                },
                decoration:  const InputDecoration(
                  icon: Icon(Icons.date_range),
                  labelText: 'Ngày kết thúc',
                ),
              ),
            ),
            Expanded(flex: 1,child: ElevatedButton(child: const Text("Chọn"), onPressed: (){
              _selectDateEnd(context);
            },))
          ],
        ),
        Expanded(child: LineChart(
          mainData(),
        ))
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (double arg1, TitleMeta arg2){
              return bottomTitleWidgets(arg1, arg2, dataBottom);
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (double arg1, TitleMeta arg2){
              return leftTitleWidgets(arg1, arg2, dataSide);
            },
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: maxBotState.toDouble(),
      minY: 0,
      maxY: maxYState.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

Widget bottomTitleWidgets(double value, TitleMeta meta, dynamic data) {
  if (data == null) {
    return Container();
  }
  var max = data["maxBot"];
  var min = data["minBot"];
  var avg = data["avgBot"];

  String text;
  if (value.toInt() == min["key"]){
    text = min["value"].toString();
  }
  else if (value.toInt() == avg["key"]){
    text = avg["value"].toString();
  }
  else if (value.toInt() == max["key"]){
    text = max["value"].toString();
  }
  else {
    return Container();
  }
  Widget label = Text(CommonService.convertISOToDateWithoutYear(text));
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: label,
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta, dynamic data) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
  if (data == null) {
    return Container();
  }
  String text;
  var max = data["maxSide"];
  var min = data["minSide"];
  var avg = data["avgSide"];


  if (value.toInt() == 0) {
    text = min["value"].toString();
  }
  else if (value.toInt() == (max["value"].toInt() % 2 == 0 ? max["value"] / 2 : (max["value"] + 1) / 2)) {
    text = avg["value"].toString();
  }
  else if (value.toInt() == max["value"].toInt()) {
    text = max["value"].toString();
  }
  else{
    return Container();
  }

  return Text(text, style: style, textAlign: TextAlign.left);
}
