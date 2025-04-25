import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_work/features/profile/data/user_repository.dart';
import 'package:flutter_work/features/profile/models/profile_model.dart';

part 'edit_profile_events.dart';
part 'edit_profile_states.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc({required IProfileRepository repository})
    : _repository = repository,
      super(EditProfileStateIdle(data: ProfileModel.empty())) {
    on<EditProfileEvent>(
      (event, emitter) async => switch (event) {
        final EditProfileEventLoad _ => _load(emitter),
        final EditProfileEventSaveData event => _save(event, emitter),
        final EditProfileEventError event => _error(event, emitter),
      },
    );
  }

  final IProfileRepository _repository;

  Stream<bool> get succesesStateWasCalled =>
      stream.map((state) => state.isSuccess).where((isSuccess) => isSuccess);

  Future<void> _load(Emitter<EditProfileState> emitter) async {
    await _executor(
      emitter,
      func: () async {
        print('Edit state loading');
        emitter.call(EditProfileStateLoading(data: state.data));
        final data = await _repository.getUser();
        print('Edit bloc loaded user ${data.user}');
        print('Edit state success');
        emitter.call(EditProfileStateSuccess(data: data));
      },
    );
  }

  Future<void> _error(
    EditProfileEventError event,
    Emitter<EditProfileState> emitter,
  ) async {
    print('Edit call state error ');
    emitter.call(EditProfileStateError(data: state.data, error: event.error));
  }

  Future<void> _save(
    EditProfileEventSaveData event,
    Emitter<EditProfileState> emitter,
  ) async {
    // emitter.call(EditProfileStateLoading(data: state.data));
    await _executor(
      emitter,
      func: () async {
        ProfileModel data = ProfileModel(
          user: User(
            name: event.name,
            surname: event.surname,
            lastName: event.lastName,
            phone: event.phone,
          ),
        );
        print('Call save user');
        await _repository.saveUser(data);
        print('Edit state success');
        emitter.call(EditProfileStateSuccess(data: data));
      },
    );
  }

  Future<void> _executor(
    Emitter<EditProfileState> emitter, {
    required Future<void> Function() func,
  }) async {
    try {
      await func();
    } on Object catch (_) {
      emitter
        ..call(EditProfileStateError(data: state.data))
        ..call(EditProfileStateIdle(data: state.data));
      rethrow;
    }
  }
}
