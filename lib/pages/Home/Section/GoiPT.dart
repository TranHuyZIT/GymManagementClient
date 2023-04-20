import 'package:easy_pagination_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Services/prodCategoryService.dart';
import 'package:frontend/pages/Home/DataSource/GoiTap.source.dart';
import 'package:frontend/pages/Home/Form/GoiTap.form.dart';

import '../DataSource/GoiPT.source.dart';
import '../Form/GoiPT.form.dart';

class GoiPTSection extends StatefulWidget {
  const GoiPTSection({super.key});

  @override
  State<GoiPTSection> createState() => _GoiPTSectionState();
}

class _GoiPTSectionState extends State<GoiPTSection> {
  var rowsPerPage = 15;

  final source = GoiPTSource();

  var sortIndex = 0;

  var sortAsc = true;

  void delete(id, context)async {
    await ProductCategoryService.delete(id, context);
    setState(() {
    });
  }

  DataRow getRow(int index){
    final goitap = source.lastDetails!.rows[index];
    return (
        DataRow(
            cells: [
              DataCell(Text(goitap["ten"], style: const TextStyle(fontSize: 10),)),
              DataCell(Text(goitap["gia"].toString(),style: const TextStyle(fontSize: 10))),
              DataCell(Text(goitap["songay"].toString(),style: const TextStyle(fontSize: 10))),
              DataCell(Row(
                children: [
                  IconButton(icon: const Icon(Icons.edit), onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GoiPTForm(), settings: RouteSettings(
                        arguments: goitap
                    )));
                  },),
                  IconButton(icon: const Icon(Icons.delete), onPressed: (){
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        title: Text("Xác Nhận Xóa"),
                        content: Text("Bạn có chắc chắn muốn xóa gói pt này không", style: TextStyle(fontSize: 20),),
                        actions: [
                          ElevatedButton(onPressed: (){
                            delete(goitap["_id"], context);
                          },
                              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
                              child: Text("Xóa"))
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
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GoiPTForm(), settings: const RouteSettings(
        arguments: <String, dynamic>{}
    )));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: SingleChildScrollView(
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            const Text("Gói PT", style: TextStyle(fontSize: 25)),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(onPressed: (){
                navigateToForm(context);
              }, icon: const Icon(Icons.add)),
            )
          ],),
          AdvancedPaginatedDataTable(
            getRow: getRow,
            addEmptyRows: false,
            source: source,
            sortAscending: sortAsc,
            sortColumnIndex: sortIndex,
            showFirstLastButtons: true,
            rowsPerPage: rowsPerPage,
            availableRowsPerPage: const [10, 15],
            onRowsPerPageChanged: (newRowsPerPage) {
              if (newRowsPerPage != null) {
                setState(() {
                  rowsPerPage = newRowsPerPage;
                });
              }
            },
            columns: [
              DataColumn(label: const Text('Tên'), onSort: setSort),
              DataColumn(label: const Text('Giá'), onSort: setSort),
              DataColumn(label: const Text('Số ngày'), onSort: setSort),
              const DataColumn(label: Text(""))
            ],
          )
        ],),
      ),
    );


  }}