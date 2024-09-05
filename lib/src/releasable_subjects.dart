import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

mixin ReleasableSubjects {
  List<Subject<dynamic>> get subjects {
    return [];
  }
}
