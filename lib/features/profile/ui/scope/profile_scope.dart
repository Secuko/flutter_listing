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
  const ProfileScope({required this.child, super.key});

  final Widget child;

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
  }) async {
    final editBloc = _editScope.bloc(context);
    final profileBloc = _scope.bloc(context);

    // Отправляем событие сохранения
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

    // _editScope
    //     .bloc(context)
    //     .add(
    //       EditProfileEventSaveData(
    //         name: name,
    //         surname: surname,
    //         lastName: lastName,
    //         phone: phone,
    //       ),
    //     );
    // _scope.bloc(context).add(const ProfileEventLoad());
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
    // SharedPrefs().init('profile');
    // final ILocalStorage localStorage = LocalStorage(
    //   sharedPreferences: SharedPrefs(),
    //   secureStorage: SecureStorage(),
    // );
    final localStorage = LocalStorage(
      sharedPreferences: SharedPrefs(),
      secureStorage: SecureStorage(),
    );
    initStorage(localStorage);
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
