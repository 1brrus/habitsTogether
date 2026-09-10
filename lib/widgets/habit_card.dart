import 'package:flutter/material.dart';

class HabitCard extends StatefulWidget {
  final String habitName;
  final Set<String> completedDates;
  final Function(bool isCompleted) onToggle;
  final VoidCallback onLongPress;
  final VoidCallback? onTap;

  const HabitCard({
    super.key,
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
