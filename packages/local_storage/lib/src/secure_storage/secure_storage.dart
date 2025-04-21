import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_storage/src/app_keys.dart';
import 'package:local_storage/src/secure_storage/i_secure_storage.dart';

// Object's Adapter pattern
interface class SecureStorage extends ISecureStorage {
  late FlutterSecureStorage _secureStorage;

  @override
  @visibleForTesting
  void initForTesting(Map<String, String> values) {
    // ignore: invalid_use_of_visible_for_testing_member
    FlutterSecureStorage.setMockInitialValues(values);

  }

  @override
  Future<void> init(String prefix) async {
    _secureStorage = FlutterSecureStorage(
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock, accountName: prefix),
      aOptions: AndroidOptions.defaultOptions.copyWith(sharedPreferencesName: prefix),
    );
  }

  @override
  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }

  @override
  Future<void> deleteKey(AppKeysInterface key) async {
    await _secureStorage.delete(key: key.textValue);
  }

  @override
  Future<String?> getString(AppKeysInterface key) => _secureStorage.read(key: key.textValue);

  @override
  Future<void> setString(AppKeysInterface key, String value) async {
    await _secureStorage.write(key: key.textValue, value: value);
  }
}
