import 'package:easy_pagination_datatable/advancedDataTableSource.dart';
import 'package:frontend/Services/PhieuNhap.service.dart';

class PhieuNhapSource extends AdvancedDataTableSource{

  @override
  Future<RemoteDataSourceDetails> getNextPage(NextPageRequest pageRequest) async{
    // TODO: implement getNextPage
    final queryParameter = <String, dynamic>{
      'offset': pageRequest.offset.toString(),
      'pageSize': pageRequest.pageSize.toString(),
      'sortIndex': ((pageRequest.columnSortIndex ?? 0) + 1).toString(),
      'sortAsc': ((pageRequest.sortAscending ?? true) ? 1 : 0).toString(),
    };
    var jsonResponse = await PhieuNhapService.getAll(queries: queryParameter);
    return RemoteDataSourceDetails(
        jsonResponse["totalRows"],
        jsonResponse["data"]
    );
  }

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => throw UnimplementedError();

}