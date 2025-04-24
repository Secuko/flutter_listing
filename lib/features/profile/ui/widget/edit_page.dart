import 'package:flutter/material.dart';
import 'package:flutter_work/features/profile/models/profile_model.dart';
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
  late final User? _user;

  @override
  void initState() {
    super.initState();
    _user = ProfileScope.editData(context, listen: false).user;
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
    super.dispose();
  }

  String _fieldPlaceholder(str, placeholder) {
    print(_user.toString());
    if (_user == null || str == null) {
      return placeholder;
    } else {
      return str;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать профиль'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
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
                hint: _fieldPlaceholder(_user!.name, 'Имя'),
              ),
              const SizedBox(height: 12),
              InputField(controller: _surnameController, hint: 'Surname'),
              const SizedBox(height: 12),
              InputField(controller: _lastNameController, hint: 'Last Name'),
              const SizedBox(height: 12),
              InputField(controller: _phoneController, hint: 'Phone'),
              const SizedBox(height: 12),
              SaveButton(
                onPressed: () {
                  ProfileScope.saveEdit(
                    context,
                    name: _nameController.text,
                    surname: _surnameController.text,
                    lastName: _lastNameController.text,
                    phone: _phoneController.text,
                  );
                  Navigator.pop(context);
                },
              ),
            ],
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
