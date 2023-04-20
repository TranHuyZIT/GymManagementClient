import 'package:easy_pagination_datatable/datatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/Users/Forms/Customer.form.dart';
import 'package:frontend/pages/Users/Sources/Customer.source.dart';

import '../../../Services/CommonService.dart';
import '../../Home/Form/GoiPT.form.dart';
import 'Checkin.view.dart';

class CheckInSection extends StatefulWidget{
  const CheckInSection({super.key});

  @override
  State<CheckInSection> createState() => _CheckInSectionState();
}

class _CheckInSectionState extends State<CheckInSection> {
  int sortIndex = 0;

  var source = CustomerSource();
  String search = "";
  String searchBy = "ten";
  List<Map<String, String>> searchByOptions = [
    {
      "value": "ten",
      "desc": "Tên"
    },
    {
      "value": "sdt",
      "desc": "Số điện thoại"
    },
    {
      "value": "cccd",
      "desc": "Căn cước công dân"
    },
  ];

  bool sortAsc = false;
  var rowsPerPage = 15;
  DataRow getRow(int index){
    try{
      final khach = source.lastDetails!.rows[index];
      return (
          DataRow(
              cells: [
                DataCell(Text(khach["ten"], style: const TextStyle(fontSize: 10),)),
                DataCell(Text(CommonService.convertISOToDateOnly(khach["ngaysinh"].toString()),style: const TextStyle(fontSize: 10))),
                DataCell(Text(khach["sdt"].toString(),style: const TextStyle(fontSize: 10))),
                DataCell(Text(khach["gioitinh"]? "Nam": "Nữ" ,style: const TextStyle(fontSize: 10))),
                DataCell(Row(
                  children: [
                    ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CheckInView(customerId: khach["_id"])));
                    }, child: const Text("Mở")),
                    IconButton(icon: const Icon(Icons.delete), onPressed: (){
                      showDialog(context: context, builder: (BuildContext context){
                        return AlertDialog(
                          title: const Text("Xác Nhận Xóa"),
                          content: const Text("Bạn có chắc chắn muốn xóa thông tin khách hàng này không?", style: TextStyle(fontSize: 20),),
                          actions: [
                            ElevatedButton(onPressed: (){
                              // delete(khach["_id"], context);
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
    catch(e){
      return const DataRow(cells: [
        DataCell(Text("")),
        DataCell(Text("")),
        DataCell(Text("")),
        DataCell(Text("")),
        DataCell(Text("")),
      ]);
    }
  }
  void setSort(int i, bool asc) => setState(() {
    sortIndex = i;
    sortAsc = asc;
  });
  final searchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return (
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(title: const Text("Trần Huy Gym")),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(child: Text("Check-in Khách", style: TextStyle(fontSize: 20),)),
                        Expanded(
                          child: IconButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerForm(), settings: const RouteSettings(
                                arguments: <String, dynamic>{}
                            )));
                          }, icon: const Icon(Icons.add)),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 200,child: DropdownButtonFormField(
                            value: searchBy,
                            decoration: const InputDecoration(
                                labelText: "Tìm kiếm theo"
                            ),
                            validator: (value){
                              if (value == null || value == "") {
                                return "Chọn thông tin tìm kiếm";
                              }
                              return null;
                            }
                            ,items: searchByOptions.map((option){
                          return DropdownMenuItem(
                            value: option["value"],
                            child: Text(option["desc"]!),
                          );
                        }).toList(), onChanged: (value){
                          setState(() {
                            searchBy = value!;
                          });
                        })),
                        SizedBox(width: 100, child: ElevatedButton(onPressed:(){
                          setState(() {
                            searchTextController.value = const TextEditingValue(text: "");
                            searchBy = "ten";
                            search = "";
                            source = CustomerSource();
                          });

                        }, child: const Text("Đặt Lại"),),)
                      ],
                    ),
                    Row(
                        children: [
                          Expanded(
                            flex:5,
                            child: TextFormField(
                              controller: searchTextController,
                              onChanged: (value){
                                setState(() {
                                  search = value;
                                });
                              },
                            ),
                          ),
                          Expanded(flex: 1, child: IconButton(onPressed: (){
                            setState(() {
                              source = CustomerSource();
                              source.filterServerSide(search, searchBy: searchBy);
                            });
                          }, icon: const Icon(Icons.search))),
                        ]
                    ),
                    SingleChildScrollView(
                      child: SizedBox(
                        child: AdvancedPaginatedDataTable(
                          getRow: getRow,
                          addEmptyRows: false,
                          source: source,
                          sortAscending: sortAsc,
                          sortColumnIndex: sortIndex,
                          showFirstLastButtons: true,
                          rowsPerPage: rowsPerPage,
                          availableRowsPerPage: const [15],
                          onRowsPerPageChanged: (newRowsPerPage) {
                            if (newRowsPerPage != null) {
                              setState(() {
                                rowsPerPage = newRowsPerPage;
                              });
                            }
                          },
                          columns: [
                            DataColumn(label: const Text('Tên'), onSort: setSort),
                            DataColumn(label: const Text('Ngày sinh'), onSort: setSort),
                            DataColumn(label: const Text('Sđt'), onSort: setSort),
                            DataColumn(label: const Text('Giới tính'), onSort: setSort),
                            const DataColumn(label: Text(""))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}