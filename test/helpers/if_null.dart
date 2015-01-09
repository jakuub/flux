library flux_helpers_if_null_test;

import "package:unittest/unittest.dart";
import "package:flux/helpers.dart";

main() {
  group("(ifNull)", () {

    test("should return first param if both are not null", () {
      expect(ifNull(1, 2), equals(1));
    });

    test("should return first param, if first is not null, and second is null", () {
      expect(ifNull(1, null), equals(1));
    });

    test("should return second param if is not null and first is null", () {
      expect(ifNull(null, 2), equals(2));
    });

    test("should return null if both params are null", () {
      expect(ifNull(null, null), isNull);
    });
  });
}
