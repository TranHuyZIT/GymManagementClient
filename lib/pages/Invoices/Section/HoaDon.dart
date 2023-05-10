import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Services/CommonService.dart';
import 'package:frontend/pages/Invoices/Forms/HoaDon.view.dart';


import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../Services/HoaDon.service.dart';
import '../../Shared/BottomNavigationBar.dart';
import '../Forms/HoaDon.form.dart';

class HoaDon extends StatefulWidget{
  const HoaDon({super.key});

  @override
  State<HoaDon> createState() => _HoaDonState();
}

class _HoaDonState extends State<HoaDon> {
  final PagingController<int, dynamic> _pagingController =
  PagingController(firstPageKey: 0);
  final searchTextController = TextEditingController(text: "");
  static const _pageSize = 5;
  String search = "";
  bool clearCurrent = false;

  bool? isChecked = false;
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final queryParameter = <String, dynamic>{
        'offset': pageKey.toString(),
        'pageSize': _pageSize.toString(),
      };
      queryParameter.addAll({"checked": isChecked.toString()});
      if (search != ""){
        queryParameter.addAll({"name": search});
      }
      final newItems = await HoaDonService.getAll(queries: queryParameter);
      final isLastPage = newItems["data"].length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems["data"]);
      } else {
        final nextPageKey = pageKey + newItems["data"].length;
        _pagingController.appendPage(newItems["data"], nextPageKey as int?);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (
        Scaffold(
            appBar: AppBarShared(),
            body: RefreshIndicator(
              onRefresh: _refresh,
              child: Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HoaDonForm(), settings: const RouteSettings(
                              arguments: <String, dynamic>{}
                          )));
                        }, child: const Text("Lập Mới")),
                        const SizedBox(width: 46,),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 20, 15, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text("Đã duyệt", style: TextStyle(fontSize: 12),),
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      isChecked = newValue;
                                    });
                                    _pagingController.refresh();
                                  },
                                ),
                              ],
                            )
                        ),
                        SizedBox(
                          width: 130,
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Tìm theo tên khách"
                            ),
                            controller: searchTextController,
                            onChanged: (value){
                              setState(() {
                                search = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: IconButton(onPressed: (){
                            _pagingController.refresh();
                          }, icon: const Icon(Icons.search)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                      ],
                    ),
                  ),
                  Expanded(child: PagedListView<int, dynamic>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<dynamic>(
                      itemBuilder: (context, item, index) =>  Card(
                        child: InkWell(
                          splashColor: Colors.lightBlue[50],
                          onTap: () {},
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(Icons.post_add),
                                title: Text('Hóa Đơn #${item["id"]}  ${CommonService.convertISOToDateOnly(item["ngaylap"] ?? '')}'),
                                subtitle: Text('Tổng tiền: ${item["tongtien"].toString()}'),
                                trailing: Column(
                                  children: [
                                    const Text('Khách'),
                                    Text('${item["khach"]["ten"]} # ${item["khach"]["id"]}'),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  ElevatedButton.icon(
                                    label: const Text('Xem' ),
                                    icon: const Icon(Icons.visibility),
                                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.black)),
                                    onPressed: () {view(item);},
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    label: const Text('Xóa'),
                                    icon: const Icon(Icons.delete),
                                    style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
                                    onPressed: (){
                                      showDialog(context: context, builder: (BuildContext context){
                                        return AlertDialog(
                                          title: const Text("Xác Nhận Xóa"),
                                          content: const Text("Bạn có chắc chắn muốn xóa hóa đơn này không?", style: TextStyle(fontSize: 12),),
                                          actions: [
                                            ElevatedButton(onPressed: (){
                                              delete(item["_id"], context);
                                              Navigator.of(context).pop();
                                            },
                                                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
                                                child: Text("Xóa"))
                                          ],
                                        );
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))
                ],
              ),
            )
        )
    );
  }
  Future <void> _refresh()async {
    _pagingController.refresh();
  }
  void delete(String id, context)async{
    var jsonResponse = await HoaDonService.delete(id);
    CommonService.popUpMessage("Xóa hóa đơn thành công", context);
  }
  void view(hoadon){
    Navigator.push(context, MaterialPageRoute(builder: (context) => HoaDonView(), settings: RouteSettings(
        arguments: hoadon
    )));
  }
  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}