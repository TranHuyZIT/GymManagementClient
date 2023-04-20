import 'dart:convert';
import 'dart:convert' as convert;
import 'package:easy_pagination_datatable/advancedDataTableSource.dart';
import 'package:frontend/Services/goitap.service.dart';
import 'package:frontend/Services/prodCategoryService.dart';
import 'package:frontend/request.dart';
import 'package:http/http.dart';

import '../../../Services/goipt.service.dart';
class GoiPTSource extends AdvancedDataTableSource{
  @override
  Future<RemoteDataSourceDetails>  getNextPage (NextPageRequest pageRequest) async {
    // TODO: implement getNextPage
    final queryParameter = <String, dynamic>{
      'offset': pageRequest.offset.toString(),
      'pageSize': pageRequest.pageSize.toString(),
      'sortIndex': ((pageRequest.columnSortIndex ?? 0) + 1).toString(),
      'sortAsc': ((pageRequest.sortAscending ?? true) ? 1 : 0).toString(),
    };
    var jsonResponse = await GoiPTService.getAll(queries: queryParameter);
    return RemoteDataSourceDetails(
        jsonResponse["totalRows"],
        jsonResponse["data"]
    );
  }

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;


}