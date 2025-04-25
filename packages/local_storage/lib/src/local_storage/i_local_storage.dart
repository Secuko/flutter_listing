import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:local_storage/src/app_keys.dart';
import 'package:local_storage/src/i_token.dart';
import 'package:local_storage/src/secure_storage/i_secure_storage.dart';
import 'package:local_storage/src/shared_preferences/i_shared_prefs.dart';

abstract class ILocalStorage with ISecureStorageMixin, ISharedStorageMixin {
  ILocalStorage({
    required ISharedPrefs sharedPreferences,
    required ISecureStorage secureStorage,
    this.setFirstRun = true,
  })  : _sharedPreferences = sharedPreferences,
        _secureStorage = secureStorage;

  final ISecureStorage _secureStorage;
  final ISharedPrefs _sharedPreferences;
  final bool setFirstRun;

  @mustCallSuper
  Future<void> init({required String sharedPrefsPrefix}) async {
    await _sharedPreferences.init(sharedPrefsPrefix);
    await _secureStorage.init(sharedPrefsPrefix);
    // print('local storage has been initialized');
    final isFirstRun = _sharedPreferences.getBool(
      AppKeysSystem.isFirstRun,
    );
    if (isFirstRun ?? true) {
      await _secureStorage.deleteAll();
      if (setFirstRun) {
        await _sharedPreferences.setBool(
          AppKeysSystem.isFirstRun,
          value: false,
        );
      }
    }
  }

  // @mustCallSuper
  // Future<void> clearAll() async {
  //   await _secureStorage.deleteAll();
  //   await _sharedPreferences.deleteAll();
  //   await _sharedPreferences.setBool(
  //     AppKeysSystem.isFirstRun,
  //     value: false,
  //   );
  // }

  IToken? getToken();

  Stream<IToken> get token;

  @mustCallSuper
  Future<void> saveToken(IToken token) async {
    final converted = jsonEncode(token.toJson());
    await _secureStorage.setString(AppKeysSystem.token, converted);
  }

  @mustCallSuper
  Map<String, dynamic>? getAccessToken() {
    final token = getToken();
    if (token != null) {
      final accessToken = token.accessToken;
      return {
        'accessToken': accessToken,
      };
    }
    return null;
  }

  @mustCallSuper
  Map<String, dynamic>? getAccessTokenAndCityHeaders() {
    final token = getToken();
    final city = _sharedPreferences.getString(
      AppKeysSystem.city,
    );
    final accessToken = token?.accessToken;
    final cityJson =
        city != null ? jsonDecode(city) as Map<String, dynamic> : null;
    final cityId = cityJson != null ? cityJson['city_id'] : null;
    if (accessToken != null || city != null) {
      return {
        if (accessToken != null) 'accessToken': accessToken,
        if (city != null) 'city': cityId,
      };
    }
    return null;
  }

  @mustCallSuper
  Future<void> setSurname({
    required final String str,
  }) async {
    await _sharedPreferences.setString(
      AppKeysSystem.surname,
      str,
    );
  }

  @mustCallSuper
  Future<void> setLastName({
    required final String str,
  }) async {
    await _sharedPreferences.setString(
      AppKeysSystem.secondName,
      str,
    );
  }

  @mustCallSuper
  Future<void> setPhone({
    required final String str, //не нужен есть лоадер
  }) async {
    await _sharedPreferences.setString(
      AppKeysSystem.phone,
      str,
    );
  }

  @mustCallSuper
  String getName() {
    final res = _sharedPreferences.getString(
      AppKeysSystem.name,
    );
    // print(res.toString());
    return (res == null) ? '' : res;
  }

  @mustCallSuper
  Future<void> setName({
    required final String str,
  }) async {
    await _sharedPreferences.setString(
      AppKeysSystem.name,
      str,
    );
    print(_sharedPreferences.getString(AppKeysSystem.name));
  }

  @mustCallSuper
  String getLastName() {
    final res = _sharedPreferences.getString(
      AppKeysSystem.secondName,
    );
    return (res == null) ? '' : res;
  }

  @mustCallSuper
  String getSurname() {
    final res = _sharedPreferences.getString(
      AppKeysSystem.surname,
    );
    return (res == null) ? '' : res;
  }

  @mustCallSuper
  String getPhone() {
    final res = _sharedPreferences.getString(
      AppKeysSystem.phone,
    );
    return (res == null) ? '' : res;
  }

  @mustCallSuper
  String? getCityId() {
    final res = _sharedPreferences.getString(
      AppKeysSystem.city,
    );
    if (res != null) {
      final json = jsonDecode(res) as Map<String, dynamic>;
      return '${json['city_id']}';
    }
    return null;
  }

  @mustCallSuper
  Future<void> deleteUser() async {
    // await _sharedPreferences.deleteAll();
    await _sharedPreferences.deleteKey(
      AppKeysSystem.name,
    );
    await _sharedPreferences.deleteKey(
      AppKeysSystem.surname,
    );
    await _sharedPreferences.deleteKey(
      AppKeysSystem.secondName,
    );
    await _sharedPreferences.deleteKey(
      AppKeysSystem.phone,
    );
    print('delete user get called');
  }

  @mustCallSuper
  String? getCityTitle() {
    final res = _sharedPreferences.getString(
      AppKeysSystem.city,
    );
    if (res != null) {
      final json = jsonDecode(res) as Map<String, dynamic>;
      return json['title'];
    }

    return null;
  }

  @mustCallSuper
  Future<void> setIsOnboardingCompleted({
    required final bool value,
  }) async {
    await _sharedPreferences.setBool(
      AppKeysSystem.isOnboardingCompleted,
      value: value,
    );
  }

  @mustCallSuper
  bool? getIsOnboardingCompleted() {
    final res = _sharedPreferences.getBool(
      AppKeysSystem.isOnboardingCompleted,
    );
    return res;
  }

  @override
  Future<String?> getSecure(AppKeysInterface key) async =>
      _secureStorage.getString(key);

  @override
  Future<void> saveSecure(
      {required AppKeysInterface key, required String value}) async {
    await _secureStorage.setString(key, value);
  }

  @override
  bool? getSharedBool(AppKeysInterface key) => _sharedPreferences.getBool(key);

  @override
  String? getSharedString(AppKeysInterface key) =>
      _sharedPreferences.getString(key);

  @override
  Future<void> setSharedBool(
      {required AppKeysInterface key, required bool value}) async {
    await _sharedPreferences.setBool(key, value: value);
  }

  @override
  Future<void> setSharedString(
      {required AppKeysInterface key, required String value}) async {
    await _sharedPreferences.setString(key, value);
  }

  @override
  Future<void> deleteSharedKey({required AppKeysInterface key}) async {
    await _sharedPreferences.deleteKey(key);
  }

  @override
  Future<void> deleteSecureKey(AppKeysInterface key) async {
    await _secureStorage.deleteKey(key);
  }
}
