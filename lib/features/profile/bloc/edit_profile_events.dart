part of 'edit_profile_bloc.dart';

sealed class EditProfileEvent {
  const EditProfileEvent();
}

final class EditProfileEventLoad extends EditProfileEvent {
  const EditProfileEventLoad();
}

final class EditProfileEventSaveData extends EditProfileEvent {
  EditProfileEventSaveData({required this.name,required this.surname, required this.lastName, required this.phone});

  final String name;
  final String surname;
  final String lastName;
  final String phone;
}
