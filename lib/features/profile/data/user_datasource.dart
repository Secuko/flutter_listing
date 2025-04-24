import 'package:flutter_work/features/profile/models/profile_model.dart';
import 'package:local_storage/local_storage.dart';

abstract class IUserDataSource {
  Future<User?> getUser();
  Future<void> saveUser(User user);
  Future<void> deleteUser();
}

class UserDataSource implements IUserDataSource {
  UserDataSource({required this.localStorage});

  final ILocalStorage localStorage;

  @override
  Future<User?> getUser() async {
    try {
      final User user = User(
        name: localStorage.getName(),
        surname: localStorage.getSurname(),
        lastName: localStorage.getLastName(),
        phone: localStorage.getPhone(),
      );
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteUser() async {
    await localStorage.deleteUser();
  }

  @override
  Future<void> saveUser(User user) async {
    print('Save user ${user.name} ${user.surname} ${user.lastName} ${user.phone}');
    await localStorage.setName(str: user.name);
    await localStorage.setSurname(str: user.surname);
    await localStorage.setLastName(str: user.lastName);
    await localStorage.setPhone(str: user.phone);
  }
}
