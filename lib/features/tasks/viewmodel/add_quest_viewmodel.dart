import 'package:flutter/foundation.dart';
import '../model/quest.dart';
import '../model/recurring_quest.dart';

/// ViewModel for Add/Edit Quest functionality
///
/// Handles all business logic for creating and editing quests
/// Separated from TasksViewModel to follow Single Responsibility Principle
class AddQuestViewModel extends ChangeNotifier {
  // Quest being edited (null for new quest)
  final Quest? questToEdit;

  // Form state
  String _title = '';
  String? _description;
  QuestPriority _priority = QuestPriority.medium;
  DateTime? _deadline;
  RecurrenceType? _recurrenceType;

  // Validation
  String? _titleError;
  bool _showValidationErrors = false;

  // Constructor
  AddQuestViewModel({this.questToEdit}) {
    if (questToEdit != null) {
      _title = questToEdit!.title;
      _description = questToEdit!.description;
      _priority = questToEdit!.priority;
      _deadline = questToEdit!.deadline;
      // Note: We don't have recurrence logic on edit right now for single quests,
      // but if an existing edit structure needs it, we would load the bound recurrence here.
    }
  }

  // Getters
  bool get isEditing => questToEdit != null;
  String get title => _title;
  String? get description => _description;
  QuestPriority get priority => _priority;
  DateTime? get deadline => _deadline;
  RecurrenceType? get recurrenceType => _recurrenceType;
  String? get titleError => _showValidationErrors ? _titleError : null;
  bool get isValid => _title.trim().isNotEmpty;

  /// Update title
  void updateTitle(String value) {
    debugPrint('📝 [AddQuestVM] updateTitle called with: "$value"');
    _title = value;
    debugPrint('📝 [AddQuestVM] _title is now: "$_title"');
    if (_showValidationErrors) {
      _validateTitle();
    }
    notifyListeners();
  }

  /// Update description
  void updateDescription(String value) {
    _description = value.trim().isEmpty ? null : value.trim();
    notifyListeners();
  }

  /// Update priority
  void updatePriority(QuestPriority value) {
    _priority = value;
    notifyListeners();
  }

  /// Update deadline
  void updateDeadline(DateTime? value) {
    _deadline = value;
    notifyListeners();
  }

  /// Update recurrence
  void updateRecurrence(RecurrenceType? value) {
    _recurrenceType = value;
    notifyListeners();
  }

  /// Validate title
  void _validateTitle() {
    debugPrint(
      '🔍 [AddQuestVM] _validateTitle called, current _title: "$_title"',
    );
    if (_title.trim().isEmpty) {
      _titleError = 'Quest title is required';
      debugPrint('❌ [AddQuestVM] Title is empty');
    } else if (_title.trim().length < 3) {
      _titleError = 'Title must be at least 3 characters';
      debugPrint('❌ [AddQuestVM] Title too short');
    } else {
      _titleError = null;
      debugPrint('✅ [AddQuestVM] Title is valid');
    }
  }

  /// Validate all fields
  bool validate() {
    _showValidationErrors = true;
    _validateTitle();
    notifyListeners();
    return isValid;
  }

  /// Create or update quest
  Quest? saveQuest() {
    debugPrint('🎯 [AddQuestVM] saveQuest called');
    debugPrint('🎯 [AddQuestVM] Title: "$_title"');
    debugPrint('🎯 [AddQuestVM] Validating...');

    if (!validate()) {
      debugPrint('❌ [AddQuestVM] Validation failed!');
      debugPrint('❌ [AddQuestVM] Title error: $_titleError');
      return null;
    }

    debugPrint('✅ [AddQuestVM] Validation passed');

    if (isEditing) {
      debugPrint('📝 [AddQuestVM] Updating existing quest: ${questToEdit!.id}');
      // Update existing quest
      // We don't change recurrence on an existing instantiated quest, only the template.
      return questToEdit!.copyWith(
        title: _title.trim(),
        description: _description,
        deadline: _deadline,
        priority: _priority,
      );
    } else {
      debugPrint('✨ [AddQuestVM] Creating new quest');
      // Create new quest
      final newQuest = Quest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _title.trim(),
        description: _description,
        deadline: _deadline,
        priority: _priority,
        // If they pick a recurrence, we temporarily attach an ID so the TasksViewModel handles generating the RecurringQuest later
        recurrenceId: _recurrenceType != null
            ? '${_recurrenceType!.name}_recurring'
            : null,
      );
      debugPrint(
        '✨ [AddQuestVM] New quest created: ${newQuest.id} - ${newQuest.title}',
      );
      return newQuest;
    }
  }

  /// Reset form
  void reset() {
    _title = '';
    _description = null;
    _priority = QuestPriority.medium;
    _deadline = null;
    _recurrenceType = null;
    _titleError = null;
    _showValidationErrors = false;
    notifyListeners();
  }
}
