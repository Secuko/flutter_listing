import 'package:flutter_work/features/profile/data/user_datasource.dart';
import 'package:flutter_work/features/profile/models/profile_model.dart';

abstract class IProfileRepository {
  const IProfileRepository();
  Future<ProfileModel> getUser();
  Future<void> saveUser(ProfileModel model);
  Future<void> deleteUser();
}

class UserRepository implements IProfileRepository {
  const UserRepository({required IUserDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final IUserDataSource _remoteDataSource;

  @override
  Future<ProfileModel> getUser() async {
    final user = await _remoteDataSource.getUser();

    if (user == null) {
      throw Exception('Пользователь не найден');
    }

    return ProfileModel(user: user);
  }

  @override
  Future<void> deleteUser() async {
    await _remoteDataSource.deleteUser();
  }

  @override
  Future<void> saveUser(ProfileModel model) async {
    User? user = model.user;
    if (user != null) {
      return await _remoteDataSource.saveUser(user);
    }
  }
}
