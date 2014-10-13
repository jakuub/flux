library dispatcher_test;

import 'package:unittest/unittest.dart';
import 'package:flux/dispatcher.dart';
import 'dart:async';
import 'package:mock/mock.dart';

main() {
  group("(Dispatcher)", () {
    
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
      var dispatcher = new Dispatcher(controller);
      
      expect(dispatcher.stream, equals(controller.stream));
    });
    
    test("should call add on controller when called dispatch with same param", () {
      Mock mock = new StreamControllerMock();
      var dispatcher = new Dispatcher(mock);
      var event = {};
      
      dispatcher.dispatch(event);
      
      mock.getLogs(callsTo("add")).verify(happenedOnce);
    });
    
  });
}

class StreamControllerMock extends Mock implements StreamController {}