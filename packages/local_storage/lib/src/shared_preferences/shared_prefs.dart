import 'package:flutter/foundation.dart';
import 'package:local_storage/src/app_keys.dart';
import 'package:local_storage/src/shared_preferences/i_shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

interface class SharedPrefs extends ISharedPrefs {
  late SharedPreferences _sharedPreferences;

  @override
  @visibleForTesting
  void initForTesting(Map<String, Object> values) {
    //ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues(values);
  }

  @override
  Future<void> init(String prefix) async {
    SharedPreferences.setPrefix(prefix);
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Future<void> deleteKey(AppKeysInterface key) async {
    await _sharedPreferences.remove(key.textValue);
  }

  @override
  String? getString(AppKeysInterface key) => _sharedPreferences.getString(key.textValue);

  @override
  Future<void> setString(AppKeysInterface key, String value) async {
    await _sharedPreferences.setString(key.textValue, value);
  }

  @override
  bool? getBool(AppKeysInterface key) => _sharedPreferences.getBool(key.textValue);

  @override
  Future<void> setBool(AppKeysInterface key, {required bool value}) async {
    await _sharedPreferences.setBool(key.textValue, value);
  }

  @override
  Future<void> deleteAll() async {
    await _sharedPreferences.clear();
  }
}
