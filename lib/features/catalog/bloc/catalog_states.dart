part of 'catalog_bloc.dart';

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

  bool get isEmpty => switch (this) {
    final CatalogStateIdle _ => true,
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
  CatalogStateError({required this.data, this.error});

  @override
  final CatalogModel data;

  @override
  final String? error;
}
