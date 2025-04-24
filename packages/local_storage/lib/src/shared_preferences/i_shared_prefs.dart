import 'package:flutter/foundation.dart';
import 'package:local_storage/src/app_keys.dart';

abstract class ISharedPrefs {
  @visibleForTesting
  void initForTesting(Map<String, Object> values);

  Future<void> init(String prefix);

  Future<void> deleteKey(AppKeysInterface key);

  String? getString(AppKeysInterface key);

  Future<void> setString(AppKeysInterface key, String value);

  bool? getBool(AppKeysInterface key);

  Future<void> setBool(AppKeysInterface key, {required bool value});

  Future<void> deleteAll();
}

mixin ISharedStorageMixin {
  String? getSharedString(AppKeysInterface key);

  Future<void> setSharedString({required AppKeysInterface key, required String value});

  bool? getSharedBool(AppKeysInterface key);

  Future<void> setSharedBool({required AppKeysInterface key, required bool value});

  Future<void> deleteSharedKey({required AppKeysInterface key});
}
