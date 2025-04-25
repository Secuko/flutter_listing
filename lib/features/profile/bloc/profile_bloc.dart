import 'package:app_network/app_network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_work/features/profile/data/user_repository.dart';
import 'package:flutter_work/features/profile/models/profile_model.dart';

part 'profile_states.dart';
part 'profile_events.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required IProfileRepository repository})
    : _repository = repository,
      super(ProfileStateIdle(data: ProfileModel.empty())) {
    on<ProfileEvent>(
      (event, emitter) async => switch (event) {
        final ProfileEventLoad _ => _load(emitter),
        final ProfileEventDeleteAccount _ => _deleteAccount(emitter),
      },
    );
  }

  final IProfileRepository _repository;

  Future<void> _load(Emitter<ProfileState> emitter) async {
    await _executor(
      emitter,
      func: () async {
        print('Profile state loading');
        emitter.call(ProfileStateLoading(data: state.data));
        final data = await _repository.getUser();
        print('Profile bloc loaded user ${data.user.toString()}');
        print('Profile state success');
        emitter.call(ProfileStateSuccess(data: data));
      },
    );
  }

  Future<void> _deleteAccount(Emitter<ProfileState> emitter) async {
    emitter.call(ProfileStateLoading(data: state.data));
    await _executor(
      emitter,
      func: () async {
        emitter.call(ProfileStateLoading(data: state.data));
        print('call delete user');
        await _repository.deleteUser();
        print('Profile state success');
        emitter.call(ProfileStateSuccess(data: state.data.copyWith(user: null)));
        // print('Profile state idle');
        // emitter.call(ProfileStateIdle(data: state.data));
      },
    );
  }


  Future<void> _executor(
    Emitter<ProfileState> emitter, {
    required Future<void> Function() func,
  }) async {
    try {
      await func();
    } on ResponseError catch (e) {
      print('ResponseError: ${e.toString()}');
      emitter
        ..call(ProfileStateError(data: state.data, error: e.toString()))
        ..call(ProfileStateIdle(data: state.data));
      rethrow;
    } on Object catch (_) {
      print('Object error');
      emitter
        ..call(ProfileStateError(data: state.data))
        ..call(ProfileStateIdle(data: state.data));
      rethrow;
    }
  }
}
