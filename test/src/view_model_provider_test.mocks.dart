// Mocks generated by Mockito 5.4.4 from annotations
// in inherited_rxdart/test/src/view_model_provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:inherited_rxdart/inherited_rxdart.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeCompositeSubscription_0 extends _i1.SmartFake
    implements _i2.CompositeSubscription {
  _FakeCompositeSubscription_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePublishSubject_1<T> extends _i1.SmartFake
    implements _i2.PublishSubject<T> {
  _FakePublishSubject_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [BaseViewModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockBaseViewModel extends _i1.Mock implements _i2.BaseViewModel {
  @override
  _i2.CompositeSubscription get compositeSubscription => (super.noSuchMethod(
        Invocation.getter(#compositeSubscription),
        returnValue: _FakeCompositeSubscription_0(
          this,
          Invocation.getter(#compositeSubscription),
        ),
        returnValueForMissingStub: _FakeCompositeSubscription_0(
          this,
          Invocation.getter(#compositeSubscription),
        ),
      ) as _i2.CompositeSubscription);

  @override
  List<_i2.Subject<dynamic>> get rxSubjects => (super.noSuchMethod(
        Invocation.getter(#rxSubjects),
        returnValue: <_i2.Subject<dynamic>>[],
        returnValueForMissingStub: <_i2.Subject<dynamic>>[],
      ) as List<_i2.Subject<dynamic>>);

  @override
  _i2.PublishSubject<dynamic> get stateChangedSubject => (super.noSuchMethod(
        Invocation.getter(#stateChangedSubject),
        returnValue: _FakePublishSubject_1<dynamic>(
          this,
          Invocation.getter(#stateChangedSubject),
        ),
        returnValueForMissingStub: _FakePublishSubject_1<dynamic>(
          this,
          Invocation.getter(#stateChangedSubject),
        ),
      ) as _i2.PublishSubject<dynamic>);

  @override
  void registerForStateChanged(_i3.Stream<dynamic>? stream) =>
      super.noSuchMethod(
        Invocation.method(
          #registerForStateChanged,
          [stream],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void registerEventHandler<T>(
    _i3.Stream<T>? stream,
    _i2.RxEventHandler<T>? handler,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #registerEventHandler,
          [
            stream,
            handler,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void closeLater(List<_i2.Subject<dynamic>>? subjects) => super.noSuchMethod(
        Invocation.method(
          #closeLater,
          [subjects],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void closeReleasableLater(List<_i2.ReleasableSubjects>? subjects) =>
      super.noSuchMethod(
        Invocation.method(
          #closeReleasableLater,
          [subjects],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void init() => super.noSuchMethod(
        Invocation.method(
          #init,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i3.Future<void> dispose() => (super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
