import 'package:flutter/material.dart';
import 'package:flutter_work/features/profile/bloc/edit_profile_bloc.dart';
import 'package:flutter_work/features/profile/ui/scope/profile_scope.dart';
import 'package:scope/scope.dart';

class ProfileListener extends StatelessWidget {
  const ProfileListener({
    required this.child,
    super.key,
  });

  final Widget child;

  static void _listener(BuildContext context, EditProfileState state) {
    switch (state) {
      case final EditProfileStateError _:
        {

        }
      default:
        null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamListener(
      listener: _listener,
      stream: ProfileScope.streamOfEdit,
      child: child,
    );
  }
}
