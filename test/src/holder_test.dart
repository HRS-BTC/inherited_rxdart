import 'package:flutter_test/flutter_test.dart';
import 'package:inherited_rxdart/src/holder.dart';

void main() {
  test("get raw value", () {
    const value = 5;
    const holder = Holder(value);
    final raw = holder.raw;
    expect(raw, value);
  });

  test("cast success", () {
    const value = 5;
    const holder = Holder(value);
    final casted = holder.cast<int>();
    expect(casted, value);
    expect(casted, isA<int>());
  });

  test("cast failed", () {
    const value = 5;
    const holder = Holder(value);
    expect(
        () => holder.cast<String>(), throwsA(const TypeMatcher<TypeError>()));
  });

  test("tryCast success", () {
    const value = 5;
    const holder = Holder(value);
    final result = holder.tryCast<int>();
    expect(result, value);
  });

  test("tryCast failed", () {
    const value = 5;
    const holder = Holder(value);
    final result = holder.tryCast<String>();
    expect(result, null);
    expect(result, isA<String?>());
  });
}
