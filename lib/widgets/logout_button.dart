import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:achivment_together/services/auth_service.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () async {
          {
            final confirm = await showCupertinoModalPopup<bool>(
              context: context,
              builder: (context) => CupertinoActionSheet(
                title: const Text('Выйти из аккаунта'),
                message: const Text(
                  'Вы уверены, что хотите выйти из аккаунта?',
                ),
                actions: [
                  CupertinoActionSheetAction(
                    isDestructiveAction: true,
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Выйти'),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  isDefaultAction: true,
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Отмена',
                    style: TextStyle(
                      color: CupertinoColors.systemBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );

            if (confirm == true) {
              await AuthService().signOut();
            }
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(width: 3, color: primaryColor),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Выйти из аккаунта',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              Icon(Icons.logout_rounded, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
