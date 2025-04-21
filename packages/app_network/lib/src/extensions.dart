import 'dart:io';

import 'package:dio/dio.dart';

extension DioExt on DioException {
  bool get isConnection =>
      error is SocketException ||
      type == DioExceptionType.connectionTimeout ||
      type == DioExceptionType.sendTimeout ||
      type == DioExceptionType.receiveTimeout;
}
