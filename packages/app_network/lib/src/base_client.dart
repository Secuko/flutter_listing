//ignore_for_file: avoid_dynamic_calls
import 'dart:io';

import 'package:app_network/src/extensions.dart';
import 'package:app_network/src/i_base_client.dart';
import 'package:app_network/src/response_error.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/adapters/io_adapter.dart';
import 'package:flutter/foundation.dart';

class BaseClient extends BaseClientClosed {
  BaseClient({
    required String baseUrl,
    super.options,
  }) : super(dio: Dio(BaseOptions(baseUrl: baseUrl)));
}

class BaseClientClosed implements IBaseClient {
  BaseClientClosed({
    required Dio dio,
    Options? options,
  })  : _dio = dio,
        _options = options {
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };
    checkForCharlesProxy(_dio);
  }

  final Dio _dio;
  final Options? _options;

  @override
  Future<Response<T>> get<T extends Object>(
    String path, {
    QueryParams? queryParameters,
    HeadersMap? headers,
  }) async {
    final response = await _createResponse<T>(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      headers: headers,
    );

    return response;
  }

  @override
  Future<Response<T>> patch<T extends Object>(
    String path, {
    QueryParams? queryParameters,
    Object? data,
    HeadersMap? headers,
  }) async {
    final response = await _createResponse<T>(
      path,
      method: 'PATCH',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );

    return response;
  }

  @override
  Future<Response<T>> post<T extends Object>(
    String path, {
    QueryParams? queryParameters,
    Object? data,
    HeadersMap? headers,
  }) async {
    final response = await _createResponse<T>(
      path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );

    return response;
  }

  @override
  Future<Response<T>> delete<T extends Object>(
    String path, {
    QueryParams? queryParameters,
    Object? data,
    HeadersMap? headers,
  }) async {
    final response = await _createResponse<T>(
      path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );

    return response;
  }

  @override
  Future<Response<T>> put<T extends Object>(
    String path, {
    QueryParams? queryParameters,
    Object? data,
    HeadersMap? headers,
  }) async {
    final response = await _createResponse<T>(
      path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
    );
    return response;
  }

  Future<Response<T>> _createResponse<T extends Object>(
    String path, {
    required String method,
    QueryParams? queryParameters,
    Object? data,
    HeadersMap? headers,
  }) async {
    final oldHeaders = _options?.headers ?? {};
    final oldOptions = _options ?? Options();

    final newOptions = oldOptions.copyWith(
      headers: oldHeaders
        ..addAll(_headers)
        ..addAll(
          headers ?? {},
        ),
    );

    final response = await request<T>(
      request: () => _dio.request<T>(
        path,
        queryParameters: queryParameters,
        data: data,
        options: DioMixin.checkOptions(method, newOptions),
      ),
    );
    return response;
  }

  @visibleForTesting
  Future<Response<T>> request<T extends Object>({
    required Future<Response<T>> Function() request,
  }) async {
    try {
      final result = await request();

      return result;
    } on SocketException catch (error, stackTrace) {
      throw Error.throwWithStackTrace(
        ResponseError.networkError(error: error),
        stackTrace,
      );
    } on DioException catch (error, stackTrace) {
      if (error.type == DioExceptionType.badResponse) {
        final response = error.response?.data;
        if (response != null && response is Map) {
          String? data;
          try {
            data = response['message'] ?? response['error']['message'];
          } on Object catch (error, stackTrace2) {
            final trace = StackTrace.fromString(stackTrace.toString() + stackTrace2.toString());
            throw Error.throwWithStackTrace(
              ResponseError.responseParseError(error: error),
              trace,
            );
          }
          throw Error.throwWithStackTrace(
            ResponseError.anotherError(error: error, message: data),
            stackTrace,
          );
        }
        throw Error.throwWithStackTrace(
          ResponseError.responseParseError(error: error),
          stackTrace,
        );
      }
      if (error.isConnection) {
        throw Error.throwWithStackTrace(
          ResponseError.networkError(error: error),
          stackTrace,
        );
      }

      throw Error.throwWithStackTrace(
        ResponseError.dioOtherError(error: error),
        stackTrace,
      );
    } on Object catch (error, stackTrace) {
      throw Error.throwWithStackTrace(
        ResponseError.anotherError(error: error),
        stackTrace,
      );
    }
  }

  void checkForCharlesProxy(Dio dio) {
    const charlesIp = String.fromEnvironment('CHARLES_PROXY_IP');
    if (charlesIp.isEmpty) return;
    debugPrint('#CharlesProxyEnabled $charlesIp');
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
      client.findProxy = (uri) => 'PROXY $charlesIp:8888;';
      // ignore: cascade_invocations
      client.badCertificateCallback = (cert, host, port) => true;
      return null;
    };
  }

  final _headers = {
    'Authorization': const String.fromEnvironment('authorization'),
    'API-SECRET-KEY': const String.fromEnvironment('apiSecretKey'),
  };

  Map<String, String> get headers => _headers;
}
