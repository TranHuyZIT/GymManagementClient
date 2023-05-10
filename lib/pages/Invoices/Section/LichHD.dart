import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Services/CommonService.dart';
import 'package:frontend/pages/Invoices/Forms/LichHD.view.dart';


import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../Services/HoaDon.service.dart';
import '../../../Services/LichHD.service.dart';
import '../../Shared/BottomNavigationBar.dart';
import '../Forms/HoaDon.form.dart';
import '../Forms/LichHD.form.dart';

class LichHD extends StatefulWidget{
  const LichHD({super.key});

  @override
  State<LichHD> createState() => _LichHDState();
}

class _LichHDState extends State<LichHD> {
  final PagingController<int, dynamic> _pagingController =
  PagingController(firstPageKey: 0);
  static const _pageSize = 5;

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
      final newItems = await LichHDService.getAll(queries: queryParameter);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LichHDForm(), settings: const RouteSettings(
                            arguments: ""
                        )));
                      }, label: const Text("Thêm"), icon: const Icon(Icons.add),),
                      const SizedBox(width: 8,)
                    ],
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
                                leading: const Icon(Icons.timeline),
                                title: Text('Lịch hướng dẫn'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Ngày bắt đầu: ${CommonService.convertISOToDateOnly(item["ngaybd"] ?? '')}"),
                                    Text("Ngày kết thúc: ${CommonService.convertISOToDateOnly(item["ngaykt"] ?? '')}"),
                                  ],
                                )
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
                                          content: const Text("Bạn có chắc chắn muốn xóa lịch hướng dẫn này không?", style: TextStyle(fontSize: 12),),
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
    await _fetchPage(0);
  }
  void delete(String id, context)async{
    var jsonResponse = await LichHDService.delete(id);
    CommonService.popUpMessage("Xóa lịch hướng dẫn thành công", context);
  }
  void view(lichhd){
    Navigator.push(context, MaterialPageRoute(builder: (context) => LichHDView(currentData: lichhd["_id"],)));
  }
  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}