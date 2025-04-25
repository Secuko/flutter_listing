import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_work/features/profile/bloc/edit_profile_bloc.dart';
import 'package:flutter_work/features/profile/models/profile_model.dart';
import 'package:flutter_work/features/profile/ui/listener/profile_listener.dart';
import 'package:flutter_work/features/profile/ui/scope/profile_scope.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  // late StreamSubscription<EditProfileState> _errorSub;
  // late final user = ProfileScope.editData(context, listen: true).user;
  late bool isEditError = ProfileScope.isEditError(context, listen: false);
  late String editError =
      ProfileScope.editError(context, listen: false) ?? 'Ошибка';
  // late final User? user;

  @override
  void initState() {
    // _errorSub = ProfileScope.streamOfEdit(context).listen((s) {
    //   if (s.isError) {
    //     setState(() {
    //       isEditError = true;
    //       editError = ProfileScope.editError(context, listen: false) ?? 'Ошибка';
    //     });
    //   } else {
    //     Navigator.pop(context);
    //   }
    // });
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    // _errorSub.cancel();
    super.dispose();
  }

  String _fieldPlaceholder(user, str, placeholder) {
    if (user == null || str == null || str.isEmpty) {
      return placeholder;
    } else {
      return str;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ProfileScope.editData(context, listen: true);
    final user = data.user;
    // final bool isEditError = ProfileScope.isEditError(context, listen: true);
    // final String editError =
    //     ProfileScope.editError(context, listen: true) ?? 'Ошибка';
    //  final User? user;
    return ProfileListener(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Редактировать профиль'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InputField(
                  controller: _nameController,
                  hint: _fieldPlaceholder(user, user?.name, 'Имя'),
                ),
                const SizedBox(height: 12),
                InputField(
                  controller: _surnameController,
                  hint: _fieldPlaceholder(user, user?.surname, 'Фамилия'),
                ),
                const SizedBox(height: 12),
                InputField(
                  controller: _lastNameController,
                  hint: _fieldPlaceholder(user, user?.lastName, 'Отчество'),
                ),
                const SizedBox(height: 12),
                InputField(
                  controller: _phoneController,
                  hint: _fieldPlaceholder(user, user?.phone, 'Телефон'),
                ),
                const SizedBox(height: 12),
                BlocListener<EditProfileBloc, EditProfileState>(
                  listener: (context, state) {
                    if (state.isError) {
                      setState(() {
                        isEditError = true;
                        editError = state.error ?? 'Ошибка';
                      });
                    } else if (state.isSuccess) {
                      Navigator.pop(context);
                    }
                  },
                  child: SaveButton(
                    onPressed: () async {
                      print('Edit page save button pressed');
                      await ProfileScope.saveEdit(
                        context,
                        name: _nameController.text,
                        surname: _surnameController.text,
                        lastName: _lastNameController.text,
                        phone: _phoneController.text,
                        user: user,
                      );

                      // if (!isEditError) {
                      //   Navigator.pop(context);
                      // }
                      print('Edit page error state: $isEditError');
                    },
                  ),
                ),
                const SizedBox(height: 12),
                (isEditError)
                    ? Text(editError, style: const TextStyle(color: Colors.red))
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({super.key, required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          // Дополнительные настройки для лучшего отображения
          hintStyle: TextStyle(color: Colors.grey[600]),
          isDense: true,
          contentPadding: EdgeInsets.all(12),
        ),
      ),
    );
  }
}

//нужен класс

class SaveButton extends StatelessWidget {
  const SaveButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightGreen,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: const Text('Сохранить'),
    );
  }
}
