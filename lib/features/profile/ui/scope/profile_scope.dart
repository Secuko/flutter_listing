import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_work/features/profile/bloc/edit_profile_bloc.dart';
import 'package:flutter_work/features/profile/bloc/profile_bloc.dart';
import 'package:flutter_work/features/profile/data/user_datasource.dart';
import 'package:flutter_work/features/profile/data/user_repository.dart';
import 'package:flutter_work/features/profile/models/profile_model.dart';
import 'package:local_storage/local_storage.dart';
import 'package:scope/scope.dart';

class ProfileScope extends StatelessWidget {
  const ProfileScope({
    required this.child,
    required this.localStorage,
    super.key,
  });

  final Widget child;
  final ILocalStorage localStorage;

  //edit profile bloc

  static const BlocScope<EditProfileEvent, EditProfileState, EditProfileBloc>
  _editScope = BlocScope();

  static ScopeData<bool> get isEditError =>
      _editScope.select((state) => state.isError);

  static ScopeData<bool> get isEditLoading =>
      _editScope.select((state) => state.isLoading);

  static ScopeData<bool> get isEditSuccess =>
      _editScope.select((state) => state.isSuccess);

  static ScopeData<String?> get editError =>
      _editScope.select((state) => state.error);

  static ScopeData<ProfileModel> get editData =>
      _editScope.select((state) => state.data);

  static Stream<EditProfileState> streamOfEdit(BuildContext context) =>
      _editScope.bloc(context).stream;

  static void loadEdit(BuildContext context) {
    _editScope.bloc(context).add(const EditProfileEventLoad());
  }

  static Future<void> saveEdit(
    BuildContext context, {
    required String name,
    required String surname,
    required String lastName,
    required String phone,
    required User? user,
  }) async {
    final editBloc = _editScope.bloc(context);
    final profileBloc = _scope.bloc(context);
    print(
      'Data recieved in saveEdit method: $name, $surname, $lastName, $phone user = $user',
    );

    // Check if the user is null and all fields are empty
    // If so, emit an error event
    if (user == null &&
        (name.isEmpty ||
            surname.isEmpty ||
            lastName.isEmpty ||
            phone.isEmpty)) {
      print('Error: Заполните все поля');
      editBloc.add(const EditProfileEventError(error: 'Заполните все поля'));
      return;
    }

    // Check if all fields are empty
    if (name.isEmpty && surname.isEmpty && lastName.isEmpty && phone.isEmpty) {
      print('All fields are empty');
      return;
    }

    if (user != null) {
      name = (user.name != name && name != '') ? name : user.name;
      surname =
          (user.surname != surname && surname != '') ? surname : user.surname;
      lastName =
          (user.lastName != lastName && lastName != '')
              ? lastName
              : user.lastName;
      phone = (user.phone != phone && phone != '') ? phone : user.phone;
    }
    print('add event EditProfileEventSaveData');
    editBloc.add(
      EditProfileEventSaveData(
        name: name,
        surname: surname,
        lastName: lastName,
        phone: phone,
      ),
    );

    await editBloc.saveCompleted.firstWhere((isSuccess) => isSuccess);

    profileBloc.add(const ProfileEventLoad());
    //добаавить bloc listener если состояние из isSuccess - попробую
  }

  //profile bloc
  static const BlocScope<ProfileEvent, ProfileState, ProfileBloc> _scope =
      BlocScope();

  // --- Data --- //
  static void load(BuildContext context) {
    _scope.bloc(context).add(const ProfileEventLoad());
  }

  static void deleteAccount(BuildContext context) {
    _scope.bloc(context).add(ProfileEventDeleteAccount());
  }

  static void editAccount(BuildContext context) {
    _scope.bloc(context).add(ProfileEventEditAccount());
  }

  static ScopeData<ProfileModel> get data =>
      _scope.select((state) => state.data);

  static ScopeData<String?> get error => _scope.select((state) => state.error);

  static ScopeData<bool> get isLoadingState =>
      _scope.select((state) => state.isLoading);

  static ScopeData<bool> get isSuccessState =>
      _scope.select((state) => state.isSuccess);

  static ScopeData<bool> get isErrorState =>
      _scope.select((state) => state.isError);

  static ScopeData<bool> get isUserExists =>
      _scope.select((state) => state.isUserExists);

  void initStorage(localStorage) async {
    await localStorage.init(sharedPrefsPrefix: 'Storage');
  }

  static Stream<ProfileState> streamOfProfile(BuildContext context) =>
      _scope.bloc(context).stream;

  @override
  Widget build(BuildContext context) {
    final repository = UserRepository(
      remoteDataSource: UserDataSource(localStorage: localStorage),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ProfileBloc(repository: repository),
        ),
        BlocProvider(
          create:
              (BuildContext context) => EditProfileBloc(repository: repository),
        ),
      ],
      child: child,
    );
  }
}

final class LocalStorage extends ILocalStorage {
  LocalStorage({
    required super.sharedPreferences,
    required super.secureStorage,
  });

  @override
  IToken? getToken() {
    throw UnimplementedError();
  }

  @override
  Stream<IToken> get token => throw UnimplementedError();
}
