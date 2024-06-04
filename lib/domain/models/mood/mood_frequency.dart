// ignore_for_file: collection_methods_unrelated_type

import 'package:myapp/data/models/journal/journal.dart';
import 'package:myapp/domain/models/mood/mood.dart';

typedef Frequency = int;

class MoodFrequency {
  late Map<Mood, Frequency> info;

  MoodFrequency.fromJournal({required List<Journal> journals}) {
    info = {};
    for (final journal in journals) {
      final mood = journal.mood;
      if (info.containsKey(mood)) {
        info[Mood.fromLSMood(mood)] = info[mood]! + 1;
      } else {
        info[Mood.fromLSMood(mood)] = 1;
      }
    }
  }
}
