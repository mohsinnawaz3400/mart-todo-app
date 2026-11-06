import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_snackbar.dart';

import '../controllers/task_controller.dart';
import '../models/task_model.dart';

import '../widgets/add_task_header.dart';
import '../widgets/task_category_selector.dart';
import '../widgets/task_priority_selector.dart';
import '../widgets/task_date_tile.dart';
import '../widgets/task_save_button.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskModel? task;

  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleFieldKey = GlobalKey();
  final _descriptionFieldKey = GlobalKey();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  String _category = 'Personal';
  String _priority = 'Medium';

  DateTime? _dueDate;
  DateTime? _reminderAt;

  bool _isSaving = false;

  bool get isEditing => widget.task != null;

  ThemeData get _theme => Theme.of(context);

  Color get _primary => _theme.colorScheme.primary;

  @override
  void initState() {
    super.initState();

    final task = widget.task;
    final now = DateTime.now();

    _titleController = TextEditingController(text: task?.title ?? '');

    _descriptionController = TextEditingController(
      text: task?.description ?? '',
    );

    if (task != null) {
      _category = task.category;
      _priority = task.priority;
      _dueDate = task.dueDate;
      _reminderAt = task.reminderAt;
    } else {
      _dueDate = now;
      _reminderAt = now;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _scrollToField(GlobalKey fieldKey) async {
    _dismissKeyboard();

    await Future.delayed(const Duration(milliseconds: 150));

    if (!mounted) return;

    final fieldContext = fieldKey.currentContext;

    if (fieldContext != null) {
      await Scrollable.ensureVisible(
        fieldContext,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
        alignment: 0.25,
      );
    }
  }

  Future<void> _selectDate() async {
    _dismissKeyboard();

    await Future.delayed(const Duration(milliseconds: 150));

    if (!mounted) return;

    final now = DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: _theme.copyWith(
            colorScheme: _theme.colorScheme.copyWith(primary: _primary),
          ),
          child: child!,
        );
      },
    );

    if (!mounted || selected == null) return;

    setState(() {
      _dueDate = selected;

      if (_reminderAt != null) {
        _reminderAt = DateTime(
          selected.year,
          selected.month,
          selected.day,
          _reminderAt!.hour,
          _reminderAt!.minute,
        );
      }
    });

    _dismissKeyboard();
  }

  Future<void> _selectReminder() async {
    _dismissKeyboard();

    await Future.delayed(const Duration(milliseconds: 150));

    if (!mounted) return;

    final now = DateTime.now();

    final selected = await showTimePicker(
      context: context,
      initialTime: _reminderAt != null
          ? TimeOfDay.fromDateTime(_reminderAt!)
          : TimeOfDay.fromDateTime(now),
      builder: (context, child) {
        return Theme(
          data: _theme.copyWith(
            colorScheme: _theme.colorScheme.copyWith(primary: _primary),
          ),
          child: child!,
        );
      },
    );

    if (!mounted || selected == null) return;

    final date = _dueDate ?? now;

    setState(() {
      _reminderAt = DateTime(
        date.year,
        date.month,
        date.day,
        selected.hour,
        selected.minute,
      );
    });

    _dismissKeyboard();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.tr('Please enter task title');
    }

    if (value.trim().length < 3) {
      return context.tr('Title must be at least 3 characters');
    }

    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.tr('Please enter task description');
    }

    if (value.trim().length < 3) {
      return context.tr('Description must be at least 3 characters');
    }

    return null;
  }

  Future<void> _saveTask() async {
    if (_isSaving) return;

    _dismissKeyboard();

    final form = _formKey.currentState;

    if (form == null) return;

    if (!form.validate()) {
      if (_validateTitle(_titleController.text) != null) {
        await _scrollToField(_titleFieldKey);
        return;
      }

      if (_validateDescription(_descriptionController.text) != null) {
        await _scrollToField(_descriptionFieldKey);
        return;
      }

      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final controller = context.read<TaskController>();

      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();

      if (isEditing) {
        final updatedTask = widget.task!.copyWith(
          title: title,
          description: description,
          category: _category,
          priority: _priority,
          dueDate: _dueDate,
          reminderAt: _reminderAt,
          updatedAt: DateTime.now(),
        );

        await controller.updateTask(updatedTask);
      } else {
        await controller.addTask(
          title: title,
          description: description,
          category: _category,
          priority: _priority,
          dueDate: _dueDate,
          reminderAt: _reminderAt,
        );
      }

      if (!mounted) return;

      final successMessage = isEditing
          ? 'Task updated successfully!'
          : 'Task saved successfully!';

      await AppSnackBar.show(
        context,
        message: successMessage,
        type: SnackBarType.success,
        duration: const Duration(seconds: 3),
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (e, stackTrace) {
      debugPrint('SAVE TASK ERROR: $e');
      debugPrint('STACK TRACE: $stackTrace');

      if (!mounted) return;

      await AppSnackBar.show(
        context,
        message: 'Something went wrong',
        type: SnackBarType.error,
        duration: const Duration(seconds: 3),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        context.tr(text),
        style: _theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: _theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    return Scaffold(
      backgroundColor: _theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _theme.scaffoldBackgroundColor,
        foregroundColor: _theme.colorScheme.onSurface,
        title: Text(
          context.tr(isEditing ? 'Edit Task' : 'Create New Task'),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
            children: [
              AddTaskHeader(isEditing: isEditing),

              const SizedBox(height: 25),

              _label('Task Title *'),

              AppTextField(
                key: _titleFieldKey,
                controller: _titleController,
                hintText: context.tr('Enter task title'),
                prefixIcon: Icons.title_rounded,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                maxLength: 100,
                validator: _validateTitle,
              ),

              const SizedBox(height: 20),

              _label('Description *'),

              AppTextField(
                key: _descriptionFieldKey,
                controller: _descriptionController,
                hintText: context.tr('Write task details...'),
                prefixIcon: Icons.description_outlined,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.newline,
                maxLines: 4,
                minLines: 4,
                maxLength: 500,
                validator: _validateDescription,
              ),

              const SizedBox(height: 22),

              _label('Category'),

              TaskCategorySelector(
                selectedCategory: _category,
                onCategoryChanged: (value) {
                  setState(() {
                    _category = value;
                  });
                },
              ),

              const SizedBox(height: 22),

              _label('Priority'),

              TaskPrioritySelector(
                selectedPriority: _priority,
                onPriorityChanged: (value) {
                  setState(() {
                    _priority = value;
                  });
                },
              ),

              const SizedBox(height: 25),

              _label('Due Date'),

              TaskDateTile(
                icon: Icons.calendar_month_rounded,
                title: _dueDate == null
                    ? context.tr('Select due date')
                    : localizations.formatMediumDate(_dueDate!),
                onTap: _selectDate,
                onClear: _dueDate != null
                    ? () {
                        setState(() {
                          _dueDate = null;
                          _reminderAt = null;
                        });
                      }
                    : null,
              ),

              const SizedBox(height: 18),

              _label('Reminder Time'),

              TaskDateTile(
                icon: Icons.notifications_active_outlined,
                title: _reminderAt == null
                    ? context.tr('Set reminder time')
                    : TimeOfDay.fromDateTime(_reminderAt!).format(context),
                onTap: _selectReminder,
                onClear: _reminderAt != null
                    ? () {
                        setState(() {
                          _reminderAt = null;
                        });
                      }
                    : null,
              ),

              const SizedBox(height: 35),

              TaskSaveButton(
                isSaving: _isSaving,
                isEditing: isEditing,
                onPressed: _saveTask,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
