

import 'package:flutter_work/features/catalog/models/catalog_model.dart';
import 'package:app_network/app_network.dart';

abstract class ICatalogDataSource {
  Future<CatalogModel> getCatalog();
}

class CatalogDataSource implements ICatalogDataSource {
  CatalogDataSource({
    required this.client,
  });

  final BaseClient client;

  @override
  Future<CatalogModel> getCatalog() async {
    final response = await client.get<Json>(
      ApiPath.getCatalog,
    );
    final result = CatalogModel.fromJson(response.data!);
    return result;
  }
}



// class NameDataSource with HeadersMixin {
//   NameDataSource({
//     required this.client,
//   });

//   final BaseClient client;

//   @override
//   Future<List<NameModel>> getProducts() async {
//     final response = await client.get<List<dynamic>>(
//       '',
//     );
//     final cast = response.data!.cast<Map<String, dynamic>>();
//     return cast.map(NameModel.fromJson).toList();
//   }
// }
