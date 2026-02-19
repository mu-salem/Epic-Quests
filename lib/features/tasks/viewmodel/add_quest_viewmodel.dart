import 'package:flutter/foundation.dart';

import '../model/quest.dart';

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
    }
  }

  // Getters
  bool get isEditing => questToEdit != null;
  String get title => _title;
  String? get description => _description;
  QuestPriority get priority => _priority;
  DateTime? get deadline => _deadline;
  String? get titleError => _showValidationErrors ? _titleError : null;
  bool get isValid => _title.trim().isNotEmpty;

  /// Update title
  void updateTitle(String value) {
    _title = value;
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

  /// Validate title
  void _validateTitle() {
    if (_title.trim().isEmpty) {
      _titleError = 'Quest title is required';
    } else if (_title.trim().length < 3) {
      _titleError = 'Title must be at least 3 characters';
    } else {
      _titleError = null;
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
    if (!validate()) return null;

    if (isEditing) {
      // Update existing quest
      return questToEdit!.copyWith(
        title: _title.trim(),
        description: _description,
        deadline: _deadline,
        priority: _priority,
      );
    } else {
      // Create new quest
      return Quest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _title.trim(),
        description: _description,
        deadline: _deadline,
        priority: _priority,
      );
    }
  }

  /// Reset form
  void reset() {
    _title = '';
    _description = null;
    _priority = QuestPriority.medium;
    _deadline = null;
    _titleError = null;
    _showValidationErrors = false;
    notifyListeners();
  }
}
