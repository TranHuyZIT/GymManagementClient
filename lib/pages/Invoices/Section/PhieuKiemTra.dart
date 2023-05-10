import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Services/CommonService.dart';
import 'package:frontend/Services/phieukiemtra.service.dart';
import 'package:frontend/pages/Invoices/Forms/PhieuKiemTra.form.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../Services/PhieuNhap.service.dart';
import '../../Shared/BottomNavigationBar.dart';

class PhieuKiemTra extends StatefulWidget{
  const PhieuKiemTra({super.key});

  @override
  State<PhieuKiemTra> createState() => _PhieuKiemTraState();
}

class _PhieuKiemTraState extends State<PhieuKiemTra> {
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
      final newItems = await PhieuKiemTraService.getAll(queries: queryParameter);
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PhieuKiemTraForm(), settings: const RouteSettings(
                            arguments: <String, dynamic>{}
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
                                leading: const Icon(Icons.post_add),
                                title: Text('Phiếu Kiểm Tra #${item["id"]}'),
                                subtitle: Text('Ghi chú: ${item["ghichu"]}'),
                                trailing: Column(
                                  children: [
                                    Text('Ngày ${CommonService.convertISOToDateOnly(item["ngaykiemtra"] ?? '')}'),
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
                                          content: const Text("Bạn có chắc chắn muốn xóa phiếu kiểm tra này không?", style: TextStyle(fontSize: 12),),
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
    initState();
  }
  void delete(String id, context)async{
    var jsonResponse = await PhieuNhapService.delete(id, context);

  }
  void view(phieukiemtra){
    Navigator.push(context, MaterialPageRoute(builder: (context) => PhieuKiemTraForm(), settings: RouteSettings(
        arguments: phieukiemtra
    )));
  }
  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}