import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_work/features/profile/ui/scope/profile_scope.dart';
import 'package:flutter_work/features/profile/ui/widget/edit_page.dart';
import 'package:flutter_work/main.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isSuccess = ProfileScope.isSuccessState(context, listen: true);
    final isError = ProfileScope.isErrorState(context, listen: true);
    final isLoading = ProfileScope.isLoadingState(context, listen: true);
    final isUserExists = ProfileScope.isUserExists(context, listen: true);
    final data = ProfileScope.data(context, listen: true);
    final user = data.user;

    print('Profile page user exists: ${isUserExists}');
    print('Profile page user: ${data.user}');

    void pushToEditPage(BuildContext context) {
      ProfileScope.loadEdit(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditPage(),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child:
            (isLoading)
                ? CircularProgressIndicator()
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 25,
                  children: [
                    if (isUserExists) ...[
                      UserInfoCard(
                        firstName: user!.name,
                        surname: user.surname,
                        lastName: user.lastName,
                        phone: user.phone,
                      ),
                      const SizedBox(height: 12),
                      CustomStyledButton(
                        text: 'Редактировать аккаунт',
                        color: Colors.yellow,
                        onPressed: () {
                          // ProfileScope.editAccount(context);
                          pushToEditPage(context);
                        },
                      ),
                      const SizedBox(height: 8),
                      CustomStyledButton(
                        text: 'Удалить аккаунт',
                        color: Colors.red,
                        onPressed: () {
                          ProfileScope.deleteAccount(context);
                        },
                      ),
                    ] else ...[
                      CustomStyledButton(
                        text: 'Создать аккаунт',
                        color: Colors.green,
                        onPressed: () {
                          pushToEditPage(context);
                        },
                      ),
                    ],
                  ],
                ),
      ),
    );
  }
}

class CustomStyledButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const CustomStyledButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Скругление
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class UserInfoCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String surname;
  final String phone;

  const UserInfoCard({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.surname,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Информация о пользователе',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            BuildInfoRow(label: 'Имя',value:  firstName),
            BuildInfoRow(label: 'Фамилия',value: surname),
            BuildInfoRow(label: 'Отчество',value: lastName),
            BuildInfoRow(label: 'Телефон',value: phone),
          ],
        ),
      ),
    );
  }
}


  class BuildInfoRow extends StatelessWidget {
    const BuildInfoRow({super.key , required this.label, required this.value});
    final String label;
    final String value;

    @override
    Widget build(BuildContext context) {
      return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
    }
  }
