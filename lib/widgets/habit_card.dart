import 'package:flutter/material.dart';

class HabitCard extends StatelessWidget {
  final String habitName;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const HabitCard({
    super.key,
    required this.habitName,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.all(5),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF292929) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primaryColor.withAlpha(150), width: 1.5),
          ),
          child: Center(
            child: Text(
              habitName,
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
