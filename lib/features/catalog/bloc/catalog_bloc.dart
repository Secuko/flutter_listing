import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_work/features/catalog/data/catalog_repository.dart';
import 'package:flutter_work/features/catalog/models/catalog_model.dart';


//классы эвентов
sealed class CatalogEvent {
  const CatalogEvent();
}

final class CatalogEventLoad extends CatalogEvent {
  const CatalogEventLoad();
}

final class CatalogEventRefreshData extends CatalogEvent {
  const CatalogEventRefreshData();
}


//родительский класс состояния
sealed class CatalogState {
  const CatalogState();

  CatalogModel get data => switch (this) {
        final CatalogStateIdle state => state.data,
        final CatalogStateLoading state => state.data,
        final CatalogStateSuccess state => state.data,
        final CatalogStateError state => state.data,
      };

  bool get isSuccess => switch (this) {
    final CatalogStateSuccess _ => true,
    _ => false,
  };

  bool get isLoading => switch (this) {
        final CatalogStateLoading _ => true,
        _ => false,
      };

  bool get isError => switch (this) {
        final CatalogStateError _ => true,
        _ => false,
      };

  String? get error => switch (this) {
        final CatalogStateError state => state.error,
        _ => null,
      };
}

final class CatalogStateIdle extends CatalogState {
  CatalogStateIdle({required this.data});

  @override
  final CatalogModel data;
}

final class CatalogStateLoading extends CatalogState {
  CatalogStateLoading({required this.data});

  @override
  final CatalogModel data;
}

final class CatalogStateSuccess extends CatalogState {
  CatalogStateSuccess({required this.data});

  @override
  final CatalogModel data;
}

final class CatalogStateError extends CatalogState {
  CatalogStateError({
    required this.data,
    this.error,
  });

  @override
  final CatalogModel data;

  @override
  final String? error;
}

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc({
    required ICatalogRepository repository,
  })  : _repository = repository,
        super(CatalogStateIdle(data: CatalogModel(products: []))) {
    on<CatalogEvent>(
      (event, emitter) async => switch (event) {
        final CatalogEventLoad _ => _load(emitter),
        final CatalogEventRefreshData event => _refreshData(event, emitter),
      },
    );
  }

  final ICatalogRepository _repository;

  // Future<void> _load(
  //   Emitter<CatalogState> emitter,
  // ) async {
  //   emitter.call(CatalogStateLoading(data: state.data));
  //   await _executor(
  //     emitter,
  //     func: () async {
  //       emitter.call(CatalogStateSuccess(data: state.data));
  //     },
  //   );
  // }
    Future<void> _load(
    Emitter<CatalogState> emitter,
  ) async {
    await _executor(
      emitter,
      func: () async {
        final data = await _repository.getCatalog();
                emitter.call(
          CatalogStateLoading(
            data: data,
          ),
        );
        await Future.delayed(const Duration(seconds: 5));
        emitter.call(
          CatalogStateSuccess(
            data: data,
          ),
        );
      },
    );
  }

  Future<void> _refreshData(
    CatalogEventRefreshData event,
    Emitter<CatalogState> emitter,
  ) async {
    final data = await _repository.getCatalog();
        emitter.call(
          CatalogStateSuccess(
            data: data,
          ),
        );
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
        ..call(
          CatalogStateIdle(data: state.data),
        );
      rethrow;
    }
  }
}