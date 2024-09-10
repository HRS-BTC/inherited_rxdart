import 'dart:async';
import 'base_view_model.dart';
import 'package:rxdart/rxdart.dart';

/// To be used with [BaseViewModel.closeReleasableLater] to release [Subject]s
/// later. Effectively disposing its [StreamController]
mixin ReleasableSubjects {
  /// Retrieval for properties which are [Subject] to dispose later
  List<Subject<dynamic>> get subjects {
    return [];
  }
}
