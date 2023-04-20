import 'package:easy_pagination_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Services/prodCategoryService.dart';
import 'package:frontend/pages/Home/DataSource/LoaiThietBi.source.dart';
import 'package:frontend/pages/Home/DataSource/ThietBiPhong.source.dart';
import 'package:frontend/pages/Home/Form/LoaiThietBi.form.dart';
import 'package:frontend/pages/Home/Form/ThietBi.form.dart';

class ThietBiPhongSection extends StatefulWidget {
  const ThietBiPhongSection({super.key});

  @override
  State<ThietBiPhongSection> createState() => _ThietBiPhongSectionState();
}

class _ThietBiPhongSectionState extends State<ThietBiPhongSection> {
  var rowsPerPage = 5;

  final source = ThietBiPhongSource();
  var sortIndex = 0;

  var sortAsc = true;

  void delete(id, context)async {
    await ProductCategoryService.delete(id, context);
    setState(() {
    });
  }

  DataRow getRow(int index){
    final thietbiphong = source.lastDetails!.rows[index];
    return (
        DataRow(
            cells: [
              DataCell(Text(thietbiphong["ten"],style: const TextStyle(fontSize: 10))),
              DataCell(Text(thietbiphong["tinhtrang"],style: const TextStyle(fontSize: 10))),
              DataCell(Row(
                children: [
                  IconButton(icon: const Icon(Icons.delete), onPressed: (){
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        title: const Text("Xác Nhận Xóa"),
                        content: const Text("Bạn có chắc chắn muốn xóa thiết bị này không", style: TextStyle(fontSize: 20),),
                        actions: [
                          ElevatedButton(onPressed: (){
                            delete(thietbiphong["_id"], context);
                          },
                              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
                              child: const Text("Xóa"))
                        ],
                      );
                    });
                  },),
                ],
              ))
            ]
        )
    );
  }
  void setSort(int i, bool asc) => setState(() {
    sortIndex = i;
    sortAsc = asc;
  });
  void navigateToForm(context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoaiThietBiForm(), settings: const RouteSettings(
        arguments: <String, dynamic>{}
    )));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: SingleChildScrollView(
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center,children: const [
            Text("Thiết Bị Phòng", style: TextStyle(fontSize: 25)),
          ],),
          AdvancedPaginatedDataTable (
            getRow: getRow,
            addEmptyRows: false,
            source: source,
            sortAscending: sortAsc,
            sortColumnIndex: sortIndex,
            showFirstLastButtons: true,
            rowsPerPage: rowsPerPage,
            availableRowsPerPage: const [5, 10],
            onRowsPerPageChanged: (newRowsPerPage) {
              if (newRowsPerPage != null) {
                setState(() {
                  rowsPerPage = newRowsPerPage;
                });
              }
            },
            columns: [
              DataColumn(label: const Text('Tên'), onSort: setSort),
              DataColumn(label: const Text('Tình Trạng'), onSort: setSort),
              const DataColumn(label: Text(""))
            ],
          )
        ],),
      ),
    );


  }}