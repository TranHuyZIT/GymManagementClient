import 'dart:convert';
import 'dart:convert' as convert;
import 'package:easy_pagination_datatable/advancedDataTableSource.dart';
import 'package:frontend/request.dart';
import 'package:http/http.dart';
class ThietBiPhongSource extends AdvancedDataTableSource{
  @override
  Future<RemoteDataSourceDetails>  getNextPage (NextPageRequest pageRequest) async {
    // TODO: implement getNextPage
    final queryParameter = <String, dynamic>{
      'offset': pageRequest.offset.toString(),
      'pageSize': pageRequest.pageSize.toString(),
      'sortIndex': ((pageRequest.columnSortIndex ?? 0) + 1).toString(),
      'sortAsc': ((pageRequest.sortAscending ?? true) ? 1 : 0).toString(),
    };
    Response response = await RequestUtil.request("get", "/thietbiphong", queries: queryParameter);
    var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      return RemoteDataSourceDetails(
          jsonResponse["totalRows"],
          jsonResponse["data"]
      );
    } else {
      throw Exception('Unable to query remote server');
    }
  }

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}