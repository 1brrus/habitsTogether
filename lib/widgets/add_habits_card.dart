import 'package:flutter/material.dart';

class AddHabitsCard extends StatelessWidget {
  final VoidCallback onTap;
  const AddHabitsCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.all(5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.grey[850]!.withAlpha(100)
                : Colors.grey[300]!.withAlpha(100),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primaryColor.withAlpha(150), width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outlined, size: 36, color: primaryColor),
              const SizedBox(height: 8),
              Text(
                'Добавить',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
