import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myapp/domain/models/journal/journal.dart';

part 'journal_state.freezed.dart';

@freezed
class JournalState with _$JournalState {
  factory JournalState({
    required List<Journal> journals,
  }) = _JournalState;

  factory JournalState.initial() => _JournalState(journals: []);
}
