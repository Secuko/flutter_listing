import 'package:dio/dio.dart';

typedef FromJson<A> = A Function(Json json);

typedef Json = Map<String, dynamic>;
typedef QueryParams = Map<String, dynamic>;
typedef HeadersMap = Map<String, dynamic>;

abstract interface class IBaseClient {
  Future<Response<T>> get<T extends Object>(
    String path, {
    QueryParams? queryParameters,
    HeadersMap? headers,
  });

  Future<Response<T>> patch<T extends Object>(
    String path, {
    QueryParams? queryParameters,
    Object? data,
    HeadersMap? headers,
  });

  Future<Response<T>> post<T extends Object>(
    String path, {
    QueryParams? queryParameters,
    Object? data,
    HeadersMap? headers,
  });

  Future<Response<T>> delete<T extends Object>(
    String path, {
    QueryParams? queryParameters,
    Object? data,
    HeadersMap? headers,
  });

  Future<Response<T>> put<T extends Object>(
    String path, {
    QueryParams? queryParameters,
    Object? data,
    HeadersMap? headers,
  });
}
