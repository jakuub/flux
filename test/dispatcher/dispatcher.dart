library flux_dispatcher_test;

import 'package:unittest/unittest.dart';
import 'package:flux/dispatcher.dart';
import 'package:flux/helpers.dart';
import 'dart:async';
import 'package:mock/mock.dart';
import 'package:vacuum_persistent/persistent.dart';

main() {
  group("(Dispatcher)", () {
    Dispatcher dispatcher;

    test("should have default creator", () {
      new Dispatcher();
    });

    test("should accept stream controller as attribute", () {
      new Dispatcher(new StreamController());
    });

    test("should create default stream when no controller passed to constructor", () {
      expect(new Dispatcher().stream, isNotNull);
    });

    test("should have getter stream which returns stream of streamcontroller", () {
      StreamController controller = new StreamController();
      dispatcher = new Dispatcher(controller);

      expect(dispatcher.stream, equals(controller.stream));
    });

    test("should call add on controller when called dispatch with same param", () {
      StreamControllerMock mock = new StreamControllerMock();
      dispatcher = new Dispatcher(mock);
      var event = {};

      dispatcher.dispatch(event);

      mock.getLogs(callsTo("add")).verify(happenedOnce);
    });

    test("should contain method dispatchAsync", () {
      dispatcher = new Dispatcher(new StreamControllerMock());

      dispatcher.dispatchAsync(new Future.value(null), "type", "field");
    });

    test("should add event to stream when future in dispatchAsync is resolved", () {
      dispatcher = new Dispatcher(new StreamController());

      dispatcher.dispatchAsync(new Future.value("value"), "type", "field");

      dispatcher.stream.listen(expectAsync((PersistentMap event) {
        expect(event[TYPE], equals("type"));
        expect(event.containsKey("field"), isTrue);
        expect(event["field"], equals("value"));
      }));
    });

  });
}

class StreamControllerMock extends Mock implements StreamController {}
