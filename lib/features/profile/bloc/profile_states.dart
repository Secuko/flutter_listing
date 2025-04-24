part of 'profile_bloc.dart';

sealed class ProfileState {
  const ProfileState();

  ProfileModel get data => switch (this) {
    final ProfileStateIdle state => state.data,
    final ProfileStateLoading state => state.data,
    // final ProfileStateSaving state => state.data, //не нужен есть лоадер
    // final ProfileStateEditing state => state.data, //не нужен есть лоадер
    final ProfileStateSuccess state => state.data,
    final ProfileStateError state => state.data,
  };

  //добавить экран можно через один скоп через мульти блок провайдер
  //нужно следить за тем чтобы не дублировать состояния - разносить все по разным блокам

  bool get isLoading => switch (this) {
    final ProfileStateLoading _ => true,
    _ => false,
  };

  bool get isUserExists => switch (this) {
    final ProfileStateIdle state => (state.data.user != null),
    _ => false,
  };

  bool get isSuccess => switch (this) {
    final ProfileStateSuccess _ => true,
    _ => false,
  };

  bool get isError => switch (this) {
    final ProfileStateError _ => true,
    _ => false,
  };

  String? get error => switch (this) {
    final ProfileStateError state => state.error,
    _ => null,
  };
}

final class ProfileStateLoading extends ProfileState {
  ProfileStateLoading({required this.data});

  @override
  final ProfileModel data;
}

final class ProfileStateSuccess extends ProfileState {
  ProfileStateSuccess({required this.data});

  @override
  final ProfileModel data;
}

final class ProfileStateIdle extends ProfileState {
  ProfileStateIdle({required this.data});

  @override
  final ProfileModel data;
}

final class ProfileStateError extends ProfileState {
  ProfileStateError({required this.data, this.error});

  @override
  final ProfileModel data;

  @override
  final String? error;
}


// final class ProfileStateEmpty extends ProfileState {
//   ProfileStateEmpty({required this.data});

//   @override
//   final ProfileModel data;
// }

// final class ProfileStateEditing extends ProfileState {
//   ProfileStateEditing({required this.data});

//   @override
//   final ProfileModel data;
// }

// final class ProfileStateSaving extends ProfileState {
//   ProfileStateSaving({required this.data});

//   @override
//   final ProfileModel data;
// }

// final class ProfileStateIdle extends ProfileState {
//   ProfileStateIdle({required this.data});

//   @override
//   final ProfileModel data;
// }

  // bool get isSaving => switch (this) {
  //   final ProfileStateSaving _ => true,
  //   _ => false,
  // };

  // bool get isEditing => switch (this) {
  //   final ProfileStateEditing _ => true,
  //   _ => false,
  // };