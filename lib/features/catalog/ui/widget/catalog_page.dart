import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_work/features/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_work/features/catalog/ui/scope/catalog_scope.dart';
import 'package:flutter_work/features/catalog/ui/listener/catalog_listener.dart';

class ProductCatalogPage extends StatelessWidget {
  const ProductCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogListener(child: const ProductCatalogView());
  }
}

class ProductCatalogView extends StatelessWidget {
  const ProductCatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    final catalogData = CatalogScope.data(context, listen: true);
    final products = catalogData.products;
    final isLoading = CatalogScope.isLoadingState(context, listen: true);
    final isError = CatalogScope.isErrorState(context, listen: true);
    final isEmpty = CatalogScope.isEmptyState(context, listen: true);
    final isSuccess = CatalogScope.isSuccessState(context, listen: true);
    final error = CatalogScope.error(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Обновить',
            onPressed: () {
              // context.read<CatalogBloc>().add(const CatalogEventRefreshData());
              CatalogScope.refresh(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Загрузить ещё',
            onPressed: () {
              // context.read<CatalogBloc>().add(const CatalogEventLoadMore());
              CatalogScope.loadMore(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Очистить',
            onPressed: () {
              // context.read<CatalogBloc>().add(const CatalogEventClear());
              CatalogScope.clear(context);
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (isError) {
            return Center(
              child: Text('Ошибка: $error ?? "Неизвестная ошибка"}'),
            );
          } else if (isEmpty) {
            return const Center(child: Text('Вы очистили каталог'));
          } else if (isSuccess && products.isEmpty) {
            return const Center(child: Text('Нет товаров для отображения.'));
          }

          // Основной контент при успешной загрузке
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


// shared prefernces в pakages local storage
// профиль на канапе посмотреть
