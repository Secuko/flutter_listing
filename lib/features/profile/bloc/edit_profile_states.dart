part of 'edit_profile_bloc.dart';

sealed class EditProfileState {
  const EditProfileState();

  ProfileModel get data => switch (this) {
    final EditProfileStateIdle state => state.data,
    final EditProfileStateLoading state => state.data,
    final EditProfileStateSuccess state => state.data,
    final EditProfileStateError state => state.data,
  };

  bool get isSuccess => switch (this) {
    final EditProfileStateSuccess _ => true,
    _ => false,
  };

  bool get isLoading => switch (this) {
    final EditProfileStateLoading _ => true,
    _ => false,
  };

  bool get isError => switch (this) {
    final EditProfileStateError _ => true,
    _ => false,
  };

  String? get error => switch (this) {
    final EditProfileStateError state => state.error,
    _ => null,
  };

  // NetworkError? get networkError => switch (this) {
  //       final EditProfileStateError state => state.networkError,
  //       _ => null,
  //     };
}

final class EditProfileStateIdle extends EditProfileState {
  EditProfileStateIdle({required this.data});

  @override
  final ProfileModel data;
}

final class EditProfileStateLoading extends EditProfileState {
  EditProfileStateLoading({required this.data});

  @override
  final ProfileModel data;
}

final class EditProfileStateSuccess extends EditProfileState {
  EditProfileStateSuccess({required this.data});

  @override
  final ProfileModel data;
}

final class EditProfileStateError extends EditProfileState {
  EditProfileStateError({
    required this.data,
    this.error,
    // this.networkError,
  });

  @override
  final ProfileModel data;

  @override
  final String? error;

  // @override
  // final NetworkError? networkError;
}
