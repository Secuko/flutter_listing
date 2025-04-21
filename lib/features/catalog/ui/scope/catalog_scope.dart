import 'package:app_network/app_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_work/features/catalog/bloc/catalog_bloc.dart';
import 'package:flutter_work/features/catalog/data/catalog_datasourse.dart';
import 'package:flutter_work/features/catalog/data/catalog_repository.dart';
import 'package:flutter_work/features/catalog/models/catalog_model.dart';
import 'package:scope/scope.dart';

class BasketScope extends StatelessWidget {
  const BasketScope({required this.child, super.key});

  final Widget child;

  static const BlocScope<CatalogEvent, CatalogState, CatalogBloc> _scope = BlocScope();

  // --- Data --- //

  static ScopeData<CatalogModel> get data => _scope.select((state) => state.data);

  static ScopeData<String?> get error => _scope.select((state) => state.error);

  static ScopeData<bool> get isLoadingState => _scope.select((state) => state.isLoading);

  static ScopeData<bool> get isSuccessState => _scope.select((state) => state.isSuccess);

  static ScopeData<bool> get isErrorState => _scope.select((state) => state.isError);

  static void load(BuildContext context) {
    _scope.bloc(context).add(const CatalogEventLoad());
  }

   static void refresh(BuildContext context) {
    _scope.bloc(context).add(const CatalogEventRefreshData());
  }


  @override
  Widget build(BuildContext context) {
    final repository = CatalogRepository(remoteDataSource: CatalogDataSource(client: BaseClient(baseUrl: 'https://dummyjson.com')));
    return BlocProvider(
      create: (_) => CatalogBloc(
        repository: repository,
      ),
      child: child,
    );
  }
}