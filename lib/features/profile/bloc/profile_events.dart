part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

final class ProfileEventLoad extends ProfileEvent {
  const ProfileEventLoad();
}

// final class ProfileEventCreateAccount extends ProfileEvent {
//   const ProfileEventCreateAccount();
// }

final class ProfileEventEditAccount extends ProfileEvent {
  const ProfileEventEditAccount();
}

final class ProfileEventDeleteAccount extends ProfileEvent {}

// final class ProfileEventEdit extends ProfileEvent {
//   const ProfileEventEdit();
// }

// final class ProfileEventSave extends ProfileEvent {
//   const ProfileEventSave({required this.user});

//   final User user;
// }

// final class ProfileEventFieldChanged extends ProfileEvent {
//   const ProfileEventFieldChanged({required this.user});

//   final User user;
// }

// final class ProfileEventCancelEdit extends ProfileEvent {
//   const ProfileEventCancelEdit();
// }
