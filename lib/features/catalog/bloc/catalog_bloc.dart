
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_work/features/catalog/data/catalog_repository.dart';
import 'package:flutter_work/features/catalog/models/catalog_model.dart';

part 'catalog_events.dart';

part 'catalog_states.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc({required ICatalogRepository repository})
    : _repository = repository,
      super(CatalogStateIdle(data: CatalogModel(products: []))) {
    on<CatalogEvent>(
      (event, emitter) async => switch (event) {
        final CatalogEventLoad _ => _load(event, emitter),
        final CatalogEventRefreshData _ => _refreshData(event, emitter),
        final CatalogEventLoadMore _ => _loadMore(event, emitter),
        final CatalogEventClear _ => _clear(event, emitter),
      },
    );
  }

  final ICatalogRepository _repository;

  Future<void> _load(CatalogEvent event, Emitter<CatalogState> emitter) async {
    await _executor(
      emitter,
      func: () async {
        emitter.call(CatalogStateLoading(data: state.data));
        final data = await _repository.getCatalog();
        await Future.delayed(const Duration(seconds: 2));
        emitter.call(CatalogStateSuccess(data: data));
      },
    );
  }

  Future<void> _loadMore(CatalogEvent event, Emitter<CatalogState> emitter) async {
    await _executor(
      emitter,
      func: () async {
        emitter.call(CatalogStateLoading(data: state.data));
        final currentData = state.data.products;
        final newData = await _repository.getCatalog();
        final data = CatalogModel(products: [...currentData, ...newData.products]);
        await Future.delayed(const Duration(seconds: 2));
        emitter.call(CatalogStateSuccess(data: data));
      },
    );
  }

  Future<void> _refreshData(CatalogEvent event, Emitter<CatalogState> emitter) async {
    await _executor(
      emitter,
      func: () async {
        emitter.call(CatalogStateLoading(data: state.data));
        await Future.delayed(const Duration(seconds: 2));
        final data = await _repository.getCatalog();
        emitter.call(CatalogStateSuccess(data: data));
      },
    );
  }

  Future<void> _clear(CatalogEvent event, Emitter<CatalogState> emitter) async {
    emitter.call(CatalogStateIdle(data: state.data));
  }

  Future<void> _executor(
    Emitter<CatalogState> emitter, {
    required Future<void> Function() func,
  }) async {
    try {
      await func();
    } on Object catch (_) {
      emitter
        ..call(CatalogStateError(data: state.data))
        ..call(CatalogStateIdle(data: state.data));
      rethrow;
    }
  }
}
