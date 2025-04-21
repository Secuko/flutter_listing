import 'dart:convert';
import 'dart:io';

import 'package:app_network/src/base_client.dart';
import 'package:app_network/src/response_error.dart';
import 'package:app_network/src/response_error_type_enum.dart';
import 'package:dio/dio.dart';
import 'package:flutter_mock_web_server/flutter_mock_web_server.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Test base client',
    () {
      late BaseClient client;
      final server = MockWebServer();
      final testJson = {
        'userId': 1,
        'id': 1,
        'title': 'delectus aut autem',
        'completed': false,
      };
      setUpAll(() async {
        await server.start();
        client = BaseClient(baseUrl: '${server.url}/');
      });
      tearDownAll(() async {
        await server.shutdown();
      });
      test(
        'get test',
        () async {
          server.enqueue(
            httpCode: 200,
            body: jsonEncode(testJson),
          );
          final data = await client.get<Map<String, dynamic>>('todos/1');
          expect(
            data.data!,
            testJson,
          );
        },
      );
      test(
        'patch test',
        () async {
          server.enqueue(
            httpCode: 200,
            body: jsonEncode(testJson),
          );
          final data = await client.patch<Map<String, dynamic>>('');
          expect(
            data.data!,
            testJson,
          );
        },
      );
      test(
        'post test',
        () async {
          server.enqueue(
            httpCode: 200,
            body: jsonEncode(testJson),
          );
          final data = await client.post<Map<String, dynamic>>('');
          expect(
            data.data!,
            testJson,
          );
        },
      );
      test(
        'delete test',
        () async {
          server.enqueue(
            httpCode: 200,
            body: jsonEncode(testJson),
          );
          final data = await client.delete<Map<String, dynamic>>('');
          expect(
            data.data!,
            testJson,
          );
        },
      );
      test(
        'put test',
        () async {
          server.enqueue(
            httpCode: 200,
            body: jsonEncode(testJson),
          );
          final data = await client.put<Map<String, dynamic>>('');
          expect(
            data.data!,
            testJson,
          );
        },
      );
      test(
        'Exception test',
        () async {
          server.enqueue(
            httpCode: 200,
            body: jsonEncode(testJson),
          );
          await expectLater(
            () => client.request(
              request: () async {
                throw Exception();
              },
            ),
            throwsA(
              isA<ResponseError>().having(
                (e) => e.type,
                'type',
                ResponseErrorType.anotherError,
              ),
            ),
          );
        },
      );
      test(
        'SocketException test',
        () async {
          server.enqueue(
            httpCode: 200,
            body: jsonEncode(testJson),
          );
          await expectLater(
            () => client.request(
              request: () async {
                throw const SocketException('');
              },
            ),
            throwsA(
              isA<ResponseError>().having(
                (e) => e.type,
                'type',
                ResponseErrorType.networkError,
              ),
            ),
          );
        },
      );
      test(
        'Dio connectTimeout error test',
        () async {
          server.enqueue(
            httpCode: 200,
            body: jsonEncode(testJson),
          );
          await expectLater(
            () => client.request(
              request: () async {
                throw DioException(
                  requestOptions: RequestOptions(),
                  type: DioExceptionType.connectionTimeout,
                );
              },
            ),
            throwsA(
              isA<ResponseError>().having(
                (e) => e.type,
                'type',
                ResponseErrorType.networkError,
              ),
            ),
          );
        },
      );
      test(
        'Dio response error test',
        () async {
          server.enqueue(
            httpCode: 200,
            body: jsonEncode(testJson),
          );
          await expectLater(
            () => client.request(
              request: () async {
                throw DioException(
                  requestOptions: RequestOptions(),
                  type: DioExceptionType.badResponse,
                );
              },
            ),
            throwsA(
              isA<ResponseError>().having(
                (e) => e.type,
                'type',
                ResponseErrorType.responseParseError,
              ),
            ),
          );
        },
      );
      test(
        'Dio sendTimeout error test',
        () async {
          server.enqueue(
            httpCode: 200,
            body: jsonEncode(testJson),
          );
          await expectLater(
            () => client.request(
              request: () async {
                throw DioException(
                  requestOptions: RequestOptions(),
                  type: DioExceptionType.sendTimeout,
                );
              },
            ),
            throwsA(
              isA<ResponseError>().having(
                (e) => e.type,
                'type',
                ResponseErrorType.networkError,
              ),
            ),
          );
        },
      );
      test(
        'Dio cancel error test',
        () async {
          server.enqueue(
            httpCode: 200,
            body: jsonEncode(testJson),
          );
          await expectLater(
            () => client.request(
              request: () async {
                throw DioException(
                  requestOptions: RequestOptions(),
                  type: DioExceptionType.cancel,
                );
              },
            ),
            throwsA(
              isA<ResponseError>().having(
                (e) => e.type,
                'type',
                ResponseErrorType.dioAnotherError,
              ),
            ),
          );
        },
      );
      test(
        'Dio receiveTimeout error test',
        () async {
          server.enqueue(
            httpCode: 200,
            body: jsonEncode(testJson),
          );
          await expectLater(
            () => client.request(
              request: () async {
                throw DioException(
                  requestOptions: RequestOptions(),
                  type: DioExceptionType.receiveTimeout,
                );
              },
            ),
            throwsA(
              isA<ResponseError>().having(
                (e) => e.type,
                'type',
                ResponseErrorType.networkError,
              ),
            ),
          );
        },
      );
      test(
        ' test',
        () {
          final error = ResponseError.anotherError();
          expect(error.toString(), isA<String>());
        },
      );
    },
  );
}
