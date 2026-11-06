
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../models/task_model.dart';
import '../screens/task_detail_screen.dart';

class TaskCard extends StatefulWidget {
  final TaskModel task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with WidgetsBindingObserver {
  Timer? _timer;

  TaskModel get task => widget.task;

  bool get isDark =>
      Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    // Automatically refresh task time status.
    _timer = Timer.periodic(
      const Duration(seconds: 30),
          (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Refresh when app comes back to foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      setState(() {});
    }
  }

  // Priority color
  Color get priorityColor {
    switch (task.priority.toLowerCase()) {
      case 'high':
        return AppColors.highPriority;
      case 'low':
        return AppColors.lowPriority;
      default:
        return AppColors.mediumPriority;
    }
  }

  // Check if task has only one hour remaining.
  bool get isEndingSoon {
    final reminder = task.reminderAt;

    if (task.isCompleted || reminder == null) {
      return false;
    }

    final now = DateTime.now();

    return !now.isBefore(
      reminder.subtract(const Duration(hours: 1)),
    ) &&
        now.isBefore(reminder);
  }

  // Check if scheduled time has passed.
  bool get isTimeOverdue {
    final reminder = task.reminderAt;

    if (task.isCompleted || reminder == null) {
      return false;
    }

    return DateTime.now().isAfter(reminder);
  }

  // Dynamic card background for light and dark mode.
  Color _cardColor(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    if (task.isCompleted) {
      return dark
          ? const Color(0xFF173D2A)
          : const Color(0xFFF0FDF4);
    }

    if (isTimeOverdue) {
      return dark
          ? const Color(0xFF42232A)
          : const Color(0xFFFFF1F2);
    }

    if (isEndingSoon) {
      return dark
          ? const Color(0xFF40351F)
          : const Color(0xFFFFFBEB);
    }

    return dark
        ? const Color(0xFF1E293B)
        : AppColors.cardBackground;
  }

  // Dynamic left border.
  Color _borderColor() {
    if (task.isCompleted) {
      return const Color(0xFF22C55E);
    }

    if (isTimeOverdue) {
      return const Color(0xFFEF4444);
    }

    if (isEndingSoon) {
      return const Color(0xFFF59E0B);
    }

    return const Color(0xFF16A34A);
  }

  // Status label
  Widget _statusLabel() {
    if (task.isCompleted) {
      return _statusChip(
        'Completed',
        AppColors.success,
        Icons.check_circle_outline,
      );
    }

    if (isTimeOverdue) {
      return _statusChip(
        'Time passed',
        Colors.redAccent,
        Icons.warning_amber_rounded,
      );
    }

    if (isEndingSoon) {
      return _statusChip(
        '1 hour left',
        Colors.deepOrange,
        Icons.access_time_rounded,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _statusChip(
      String label,
      Color color,
      IconData icon,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Delete Task',
      barrierColor: Colors.black.withOpacity(0.55),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (
          context,
          animation,
          secondary,
          child,
          ) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: curved,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color ??
                        Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.delete_forever_rounded,
                        color: AppColors.danger,
                        size: 55,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        context.tr('Delete Task?'),
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${context.tr('Are you sure you want to delete')} "${task.title}"?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  Navigator.pop(context, false),
                              child: Text(context.tr('Cancel')),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.danger,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () =>
                                  Navigator.pop(context, true),
                              child: Text(context.tr('Delete')),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (result == true) {
      widget.onDelete();
    }
  }

  void _openDetails(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, animation, secondaryAnimation) {
          return TaskDetailScreen(
            task: task,
            onEdit: () {
              Navigator.pop(context);
              widget.onEdit();
            },
            onDelete: () async {
              Navigator.pop(context);
              await _confirmDelete(context);
            },
            onToggle: () {
              Navigator.pop(context);
              widget.onToggle();
            },
          );
        },
        transitionsBuilder: (
            _,
            animation,
            secondaryAnimation,
            child,
            ) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.12, 0),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  String _formatDueDate() {
    if (task.dueDate == null) {
      return 'No due date';
    }

    final date = task.dueDate!;

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _formatReminder() {
    if (task.reminderAt == null) return '';

    return TimeOfDay.fromDateTime(
      task.reminderAt!,
    ).format(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final time = _formatReminder();

    final secondaryTextColor =
        theme.colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Slidable(
        key: ValueKey(task.id),

        // Right to left actions
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.72,
          children: [
            SlidableAction(
              onPressed: (_) => widget.onEdit(),
              backgroundColor: const Color(0xFF16A34A),
              foregroundColor: Colors.white,
              icon: Icons.edit_rounded,
              label: context.tr('Edit'),
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => widget.onToggle(),
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              icon: task.isCompleted
                  ? Icons.undo_rounded
                  : Icons.check_circle_rounded,
              label: context.tr(
                task.isCompleted ? 'Undo' : 'Done',
              ),
            ),
            SlidableAction(
              onPressed: (_) => _confirmDelete(context),
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              label: context.tr('Delete'),
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),

        // Left to right actions
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          extentRatio: 0.50,
          children: [
            SlidableAction(
              onPressed: (_) => _openDetails(context),
              backgroundColor: const Color(0xFF166534),
              foregroundColor: Colors.white,
              icon: Icons.visibility_rounded,
              label: context.tr('Details'),
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => widget.onEdit(),
              backgroundColor: const Color(0xFF16A34A),
              foregroundColor: Colors.white,
              icon: Icons.edit_rounded,
              label: context.tr('Edit'),
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),

        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _openDetails(context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _cardColor(context),
                borderRadius: BorderRadius.circular(16),
                border: Border(
                  left: BorderSide(
                    color: _borderColor(),
                    width: 4,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: _borderColor().withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Complete checkbox
                  GestureDetector(
                    onTap: widget.onToggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: task.isCompleted
                            ? const Color(0xFF16A34A)
                            : (isDark
                            ? const Color(0xFF263548)
                            : Colors.white),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: task.isCompleted
                              ? const Color(0xFF16A34A)
                              : (isDark
                              ? const Color(0xFF64748B)
                              : const Color(0xFF16A34A)),
                          width: 1.8,
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: task.isCompleted
                            ? const Icon(
                          Icons.check_rounded,
                          key: ValueKey('checked'),
                          size: 17,
                          color: Colors.white,
                        )
                            : const SizedBox(
                          key: ValueKey('unchecked'),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 13),

                  // Task details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                          child: Text(
                            task.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],

                        const SizedBox(height: 9),

                        Wrap(
                          spacing: 10,
                          runSpacing: 7,
                          crossAxisAlignment:
                          WrapCrossAlignment.center,
                          children: [
                            _info(
                              context,
                              Icons.category_outlined,
                              task.category,
                            ),
                            _info(
                              context,
                              Icons.calendar_today_outlined,
                              _formatDueDate(),
                            ),
                            if (time.isNotEmpty)
                              _info(
                                context,
                                Icons.access_time,
                                time,
                              ),
                          ],
                        ),

                        if (task.isCompleted ||
                            isEndingSoon ||
                            isTimeOverdue) ...[
                          const SizedBox(height: 9),
                          _statusLabel(),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Priority and edit
                  Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 11,
                        width: 11,
                        decoration: BoxDecoration(
                          color: priorityColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: priorityColor.withOpacity(0.25),
                              blurRadius: 7,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: widget.onEdit,
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          Icons.edit_outlined,
                          color: secondaryTextColor,
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _info(BuildContext context, IconData icon, String value) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 11,
          color: color,
        ),
        const SizedBox(width: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            color: color,
          ),
        ),
      ],
    );
  }
}
