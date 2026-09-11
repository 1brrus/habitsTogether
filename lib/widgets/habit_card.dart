import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HabitCard extends StatefulWidget {
  final String habitId;
  final String habitName;
  final Set<String> completedDates;
  final Function(bool isCompleted) onToggle;
  final VoidCallback onLongPress;
  final VoidCallback? onTap;

  const HabitCard({
    super.key,
    required this.habitId,
    required this.habitName,
    required this.completedDates,
    required this.onToggle,
    required this.onLongPress,
    this.onTap,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  void showShareHabitDialog(
    BuildContext context,
    String habitId,
    String habitName,
  ) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Пригласить друга в $habitName'),
        content: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              const Text('Отправь этот код другу, чтобы вести привычку вместе'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  habitId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: habitId));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Код скопирован в буфер обмена')),
              );
            },
            child: const Text(
              'Скопировать код',
              style: TextStyle(
                color: CupertinoColors.activeBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  int _calculateStreak() {
    final today = DateTime.now();
    final todayStr = _formatDate(today);
    final yesterdayStr = _formatDate(today.subtract(const Duration(days: 1)));

    if (!widget.completedDates.contains(todayStr) &&
        !widget.completedDates.contains(yesterdayStr)) {
      return 0;
    }

    int streak = 0;
    DateTime checkDate = widget.completedDates.contains(todayStr)
        ? today
        : today.subtract(const Duration(days: 1));

    while (widget.completedDates.contains(_formatDate(checkDate))) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final todayStr = _formatDate(DateTime.now());
    final isCompletedToday = widget.completedDates.contains(todayStr);
    final streak = _calculateStreak();

    const successColor = Color(0xFF34C759);
    final borderColor = isCompletedToday
        ? successColor
        : primaryColor.withValues(alpha: 0.6);

    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: widget.onTap ?? () => widget.onToggle(!isCompletedToday),
        onLongPress: widget.onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF292929) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: isCompletedToday ? 2.0 : 1.5,
            ),
            boxShadow: isCompletedToday
                ? [
                    BoxShadow(
                      color: successColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. ВЕРХНИЙ УГОЛ: Название привычки
              Text(
                widget.habitName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),

              // 2. НИЖНИЙ УГОЛ: Стрик слева, галочка справа
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Индикатор серии (огонек)
                  if (streak > 0)
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          size: 16,
                          color: Colors.orangeAccent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$streak',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),

                  IconButton(
                    icon: const Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      showShareHabitDialog(
                        context,
                        widget.habitId,
                        widget.habitName,
                      );
                    },
                  ),

                  // Галочка выполнения в нижнем правом углу
                  GestureDetector(
                    onTap: () => widget.onToggle(!isCompletedToday),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompletedToday
                            ? successColor
                            : Colors.transparent,
                        border: Border.all(
                          color: isCompletedToday
                              ? successColor
                              : Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                      child: isCompletedToday
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
