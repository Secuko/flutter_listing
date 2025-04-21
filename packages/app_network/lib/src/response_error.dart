import 'package:app_network/src/response_error_type_enum.dart';

class ResponseError implements Exception {
  ResponseError._({
    this.type = ResponseErrorType.anotherError,
    this.message,
    this.error,
  });

  factory ResponseError.networkError({Object? error}) => ResponseError._(
        type: ResponseErrorType.networkError,
        message: 'No internet connection',
        error: error,
      );

  factory ResponseError.dioOtherError({Object? error}) => ResponseError._(
        type: ResponseErrorType.dioAnotherError,
        error: error,
      );

  factory ResponseError.responseParseError({Object? error}) => ResponseError._(
        type: ResponseErrorType.responseParseError,
        message: 'Response parse error',
        error: error,
      );

  factory ResponseError.anotherError({String? message, Object? error}) => ResponseError._(
        message: message,
        error: error,
      );

  final ResponseErrorType type;
  final String? message;
  final Object? error;

  @override
  String toString() {
    return 'type: $type, message: $message error: $error';
  }
}
