import 'package:easy_pagination_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Services/thietbi.service.dart';
import 'package:frontend/pages/Home/Form/ThietBi.form.dart';
import 'package:http/http.dart';
import '../DataSource/ThietBi.dart';

class ThietBiSection extends StatefulWidget {
  const ThietBiSection({super.key});

  @override
  State<ThietBiSection> createState() => _ThietBiSectionState();
}

class _ThietBiSectionState extends State<ThietBiSection> {
  var rowsPerPage = 15;

  final source = ThietBiSource();

  var sortIndex = 0;

  var sortAsc = true;

  void delete(id, context)async {
    await ThietBiService.delete(id, context);
    setState(() {
    });
  }

  DataRow getRow(int index){
    final thietbi = source.lastDetails!.rows[index];
    return (
      DataRow(
        cells: [
          DataCell(Text(thietbi["ten"], style: const TextStyle(fontSize: 10),)),
          DataCell(Text(thietbi["loaitb"]["ten"],style: const TextStyle(fontSize: 10))),
          DataCell(Row(
            children: [
              IconButton(icon: const Icon(Icons.edit), onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ThietBiForm(), settings: RouteSettings(
                  arguments: thietbi
                )));
              },),
              IconButton(icon: const Icon(Icons.delete), onPressed: (){
                showDialog(context: context, builder: (BuildContext context){
                  return AlertDialog(
                    title: Text("Xác Nhận Xóa"),
                    content: Text("Bạn có chắc chắn muốn xóa thiết bị này không", style: TextStyle(fontSize: 20),),
                    actions: [
                      ElevatedButton(onPressed: (){
                        delete(thietbi["_id"], context);
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
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ThietBiForm(), settings: const RouteSettings(
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
            const Text("Thiết Bị", style: TextStyle(fontSize: 25)),
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
              DataColumn(label: const Text('Loại Thiết Bị'), onSort: setSort),
              const DataColumn(label: Text(""))
            ],
          )
        ],),
      ),
    );


  }}