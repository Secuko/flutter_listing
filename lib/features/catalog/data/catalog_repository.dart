import 'package:flutter_work/features/catalog/models/catalog_model.dart';
import 'package:flutter_work/features/catalog/data/catalog_datasourse.dart';

abstract class ICatalogRepository {
  const ICatalogRepository();
  Future<CatalogModel> getCatalog();
}

class CatalogRepository implements ICatalogRepository{
  const CatalogRepository({
    required ICatalogDataSource remoteDataSource,
  })  : _remoteDataSource = remoteDataSource;

  final ICatalogDataSource _remoteDataSource;

  @override
  Future<CatalogModel> getCatalog() async {
    final response = await _remoteDataSource.getCatalog();
    return response;
  }
}
