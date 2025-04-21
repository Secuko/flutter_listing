import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_work/features/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_work/features/catalog/models/catalog_model.dart';
import 'package:flutter_work/features/catalog/data/catalog_datasourse.dart';
import 'package:flutter_work/features/catalog/data/catalog_repository.dart';
import 'package:app_network/app_network.dart';

class ProductCatalogPage extends StatelessWidget {
  const ProductCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    // я понимаю что так не должно быть)
    final client = BaseClient(baseUrl: 'https://dummyjson.com');
    final dataSource = CatalogDataSource(client: client);
    final repository = CatalogRepository(remoteDataSource: dataSource);

    return BlocProvider(
      create:
          (_) =>
              CatalogBloc(repository: repository)
                ..add(const CatalogEventLoad()),
      child: const ProductCatalogView(),
    );
  }
}

class ProductCatalogView extends StatelessWidget {
  const ProductCatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Update',
            onPressed: () {
              context.read<CatalogBloc>().add(const CatalogEventRefreshData());
            },
          ),
        ],
      ),
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isError) {
            return Center(
              child: Text('Ошибка: ${state.error ?? "Неизвестная ошибка"}'),
            );
          } else if (state.isSuccess && state.data.products.isEmpty) {
            return const Center(child: Text('Нет товаров для отображения.'));
          }

          final products = state.data.products;

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: products.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  product.description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
