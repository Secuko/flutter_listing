import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

class TestToken extends IToken {
  TestToken({required super.accessToken, required super.isAuthorized});

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

final class MockLocalStorage extends ILocalStorage {
  MockLocalStorage({required super.sharedPreferences, required super.secureStorage});

  @override
  IToken? getToken() {
    throw UnimplementedError();
  }

  @override
  Stream<IToken> get token => throw UnimplementedError();
}

void main() {
  group(
    'test local storage client',
    () {
      late ILocalStorage localStorage;
      final values = <String, Object>{'counter': false, 'string': 'test'};
      final valuesSecure = <String, String>{'counter': 'counter', 'string': 'test'};

      setUpAll(() async {
        SharedPreferences.setMockInitialValues(values);
        FlutterSecureStorage.setMockInitialValues(valuesSecure);
        localStorage = MockLocalStorage(
          sharedPreferences: SharedPrefs(),
          secureStorage: SecureStorage(),
        );
        await localStorage.init(sharedPrefsPrefix: '');
      });
      tearDownAll(() async {});
      test(
        'get shared bool',
        () async {
          expect(localStorage.getSharedBool(AppKeysInterface('flutter.counter')), false);
        },
      );
      test(
        'get shared string',
        () async {
          expect(localStorage.getSharedString(AppKeysInterface('flutter.string')), 'test');
        },
      );
      test(
        'set shared bool',
        () async {
          await localStorage.setSharedBool(key: AppKeysInterface('newBool'), value: true);
          expect(localStorage.getSharedBool(AppKeysInterface('newBool')), true);
        },
      );
      test(
        'set shared string',
        () async {
          await localStorage.setSharedString(
            key: AppKeysInterface('newString'),
            value: 'newString',
          );
          expect(localStorage.getSharedString(AppKeysInterface('newString')), 'newString');
        },
      );
      test(
        'delete shared key',
        () async {
          await localStorage.setSharedString(
            key: AppKeysInterface('temp'),
            value: 'tempString',
          );
          await localStorage.deleteSharedKey(key: AppKeysInterface('temp'));
          expect(localStorage.getSharedString(AppKeysInterface('temp')), null);
        },
      );
      test(
        'save secure',
        () async {
          await localStorage.saveSecure(
            key: AppKeysInterface('temp'),
            value: 'secureString',
          );
          expect(localStorage.getSecure(AppKeysInterface('temp')), completion('secureString'));
        },
      );
      test(
        'delete secure',
        () async {
          await localStorage.saveSecure(
            key: AppKeysInterface('temp'),
            value: 'secureString',
          );
          await localStorage.deleteSecureKey(AppKeysInterface('temp'));
          expect(localStorage.getSecure(AppKeysInterface('temp')), completion(null));
        },
      );
      test(
        'save token',
        () async {
          await localStorage.saveToken(TestToken(accessToken: '', isAuthorized: true));
        },
      );
      test(
        'delete all',
        () async {
          await localStorage.setSharedString(
            key: AppKeysInterface('temp'),
            value: 'tempString',
          );
          await localStorage.clearAll();
          expect(localStorage.getSharedString(AppKeysInterface('temp')), null);
          expect(localStorage.getSharedBool(AppKeysSystem.isFirstRun), false);
        },
      );
    },
  );
}
