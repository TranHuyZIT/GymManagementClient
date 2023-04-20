
import 'dart:convert' as convert;
import 'package:easy_pagination_datatable/advancedDataTableSource.dart';


import '../../../Services/customer.service.dart';
import '../../../Services/pt.service.dart';
class PTSource extends AdvancedDataTableSource{
  String lastSearchTerm = "";


  void filterServerSide(String filterQuery) {
    lastSearchTerm = filterQuery.trim();
    var pageRequest = NextPageRequest(15, 0);
    getNextPage(pageRequest);
  }


  @override
  Future<RemoteDataSourceDetails>  getNextPage (NextPageRequest pageRequest) async {
    // TODO: implement getNextPage
    final queryParameter = <String, dynamic>{
      'offset': pageRequest.offset.toString(),
      'pageSize': pageRequest.pageSize.toString(),
      'sortIndex': ((pageRequest.columnSortIndex ?? 0) + 1).toString(),
      'sortAsc': ((pageRequest.sortAscending ?? true) ? 1 : 0).toString(),
      'name': lastSearchTerm
    };
    var jsonResponse = await PTService.getAll(queries: queryParameter);
    return RemoteDataSourceDetails(
        jsonResponse["totalRows"],
        jsonResponse["data"]
    );
  }

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

}