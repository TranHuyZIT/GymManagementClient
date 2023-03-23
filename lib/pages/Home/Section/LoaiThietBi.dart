import 'package:easy_pagination_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Services/prodCategoryService.dart';
import 'package:frontend/pages/Home/DataSource/LoaiThietBi.source.dart';
import 'package:frontend/pages/Home/Form/LoaiThietBi.form.dart';
import 'package:frontend/pages/Home/Form/ThietBi.form.dart';

class LoaiThietBiSection extends StatefulWidget {
  const LoaiThietBiSection({super.key});

  @override
  State<LoaiThietBiSection> createState() => _LoaiThietBiSectionState();
}

class _LoaiThietBiSectionState extends State<LoaiThietBiSection> {
  var rowsPerPage = 15;

  final source = LoaiThietBiSource();

  var sortIndex = 0;

  var sortAsc = true;

  void delete(id, context)async {
    await ProductCategoryService.delete(id, context);
    setState(() {
    });
  }

  DataRow getRow(int index){
    final loaithietbi = source.lastDetails!.rows[index];
    print(loaithietbi);
    return (
        DataRow(
            cells: [
              DataCell(Text(loaithietbi["_id"], style: const TextStyle(fontSize: 10),)),
              DataCell(Text(loaithietbi["ten"],style: const TextStyle(fontSize: 10))),
              DataCell(Row(
                children: [
                  IconButton(icon: const Icon(Icons.edit), onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ThietBiForm(), settings: RouteSettings(
                        arguments: loaithietbi
                    )));
                  },),
                  IconButton(icon: const Icon(Icons.delete), onPressed: (){
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        title: Text("Xác Nhận Xóa"),
                        content: Text("Bạn có chắc chắn muốn xóa thiết bị này không", style: TextStyle(fontSize: 20),),
                        actions: [
                          ElevatedButton(onPressed: (){
                            delete(loaithietbi["_id"], context);
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
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            const Text("Loại Thiết Bị", style: TextStyle(fontSize: 25)),
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
              DataColumn(label: const Text('ID'), onSort: setSort),
              DataColumn(label: const Text('Tên'), onSort: setSort),
              const DataColumn(label: Text(""))
            ],
          )
        ],),
      ),
    );


  }}