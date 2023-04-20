import 'dart:convert';
import 'dart:convert' as convert;
import 'package:easy_pagination_datatable/advancedDataTableSource.dart';
import 'package:frontend/Services/prodCategoryService.dart';
import 'package:frontend/request.dart';
import 'package:http/http.dart';

import '../../../Services/customer.service.dart';
class CustomerSource extends AdvancedDataTableSource{
  String lastSearchTerm = "";
  String searchBy ="";


  void filterServerSide(String filterQuery, { String? searchBy}) {
    print(this.searchBy);
    lastSearchTerm = filterQuery.trim();
    this.searchBy = searchBy ?? "";
    var pageRequest = NextPageRequest(10, 0);
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
      'term': lastSearchTerm,
      'searchBy': searchBy
    };
    var jsonResponse = await CustomerService.getAll(queries: queryParameter);
    return RemoteDataSourceDetails(
        jsonResponse["totalRows"],
        jsonResponse["data"]
    );
  }

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

}