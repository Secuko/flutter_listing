import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';

@freezed
class ProfileModel with _$ProfileModel {
  factory ProfileModel({required User? user}) = _ProfileModel;

  factory ProfileModel.empty() => ProfileModel(user: null);

  factory ProfileModel.correct() => ProfileModel(user: User(name: "Ivan", lastName: "Ivanovich", surname: "Ivanov", phone: "+79999999999"));
}

@freezed
class User with _$User {
  factory User({
    required String name,
    required String lastName,
    required String surname,
    required String phone,
  }) = _User;

  const User._();
}
