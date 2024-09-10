import 'package:flutter_test/flutter_test.dart';
import 'package:inherited_rxdart/inherited_rxdart.dart';

class ReleasableTestHelper {
  const ReleasableTestHelper(this.releasableSubject);

  final ReleasableSubjects releasableSubject;

  List<Subject<dynamic>> acquireSubjects() {
    return releasableSubject.subjects;
  }
}

class ReleasableSubjectTest with ReleasableSubjects {
  final PublishSubject publishSubject;
  final BehaviorSubject behaviorSubject;

  const ReleasableSubjectTest(this.publishSubject, this.behaviorSubject);

  @override
  List<Subject> get subjects => [publishSubject, behaviorSubject];
}

// coverage test on mixin seems to be messed up with the current Dart SDK
// version https://github.com/flutter/flutter/issues/119906
void main() {
  test("retrieve subjects", () {
    final subject1 = PublishSubject();
    final subject2 = BehaviorSubject();
    final releasable = ReleasableSubjectTest(subject1, subject2);
    final helper = ReleasableTestHelper(releasable);

    addTearDown(() {
      subject1.close();
      subject2.close();
    });

    final subjects = helper.acquireSubjects();

    expect(subjects.length, 2);
    expect(subjects[0], subject1);
    expect(subjects[1], subject2);
  });
}
