
part of 'catalog_bloc.dart';

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

final class CatalogEventLoadMore extends CatalogEvent {
  const CatalogEventLoadMore();
}

final class CatalogEventClear extends CatalogEvent {
  const CatalogEventClear();
}