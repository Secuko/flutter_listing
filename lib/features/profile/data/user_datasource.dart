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
    final name = localStorage.getName();
    final surname = localStorage.getSurname();
    final lastName = localStorage.getLastName();
    final phone = localStorage.getPhone();
    if (name.isEmpty ||
        surname.isEmpty ||
        lastName.isEmpty ||
        phone.isEmpty) {
      return null;
    }
    final User user = User(
      name: name,
      surname: surname,
      lastName: lastName,
      phone: phone,
    );
    print('local storage name ${localStorage.getName()}');
    print('get user in datasource ${user.toString()}');
    return user;
  }

  @override
  Future<void> deleteUser() async {
    await localStorage.deleteUser();
  }

  @override
  Future<void> saveUser(User user) async {
    print(
      'Save user in db ${user.name} ${user.surname} ${user.lastName} ${user.phone}',
    );
    await localStorage.setName(str: user.name);
    await localStorage.setSurname(str: user.surname);
    await localStorage.setLastName(str: user.lastName);
    await localStorage.setPhone(str: user.phone);
  }
}
