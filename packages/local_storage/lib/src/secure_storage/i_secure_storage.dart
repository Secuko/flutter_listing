import 'package:flutter/foundation.dart';
import 'package:local_storage/src/app_keys.dart';

abstract class ISecureStorage {
  @visibleForTesting
  void initForTesting(Map<String, String> values);

  Future<void> init(String prefix);

  Future<void> deleteAll();

  Future<void> deleteKey(AppKeysInterface key);

  Future<String?> getString(AppKeysInterface key);

  Future<void> setString(AppKeysInterface key, String value);
}

mixin ISecureStorageMixin {
  Future<String?> getSecure(AppKeysInterface key);

  Future<void> saveSecure({required AppKeysInterface key, required String value});

  Future<void> deleteSecureKey(AppKeysInterface key);
}
