library store_test;
import 'package:unittest/unittest.dart';
import 'package:flux/store.dart';
import 'package:flux/dispatcher.dart';
import 'package:vacuum_persistent/persistent.dart';
import 'dart:async';
import 'package:mock/mock.dart';

main() {
  group("(Store)", () {

    Store<Persistent> store;
    Persistent oldData;
    Persistent newData;
    Mock mock;
    StreamController controller;


    setUp(() {
      newData = new Persistent();
      oldData = new Persistent();
      mock = new StreamControllerMock();
      controller = new StreamController();
      store = new Store(null, updateController: mock, data: oldData);

    });

    test("should have constructor with dispatcher", () {
      new Store<Persistent>(new Dispatcher());
    });

    test("should have persitend data", () {
      expect(store.data, isNotNull);
      expect(store.data is Persistent, isTrue);
    });

    test("should have optional named param in constructor for data", () {
      store = new Store(null, data: new Persistent());
    });

    test("should have stream updated", () {
      store.updated;
    });

    test("should have streamcontroller in constructor", () {
      new Store(null, updateController: controller);
    });

    test("should use streamcontroller from constructor to create stream updated", () {
      Stream stream = controller.stream;
      mock.when(callsTo("get stream")).thenReturn(stream);

      expect(store.updated, equals(stream));
    });

    test("should have method setData which set data", () {
      store.setData(newData);

      expect(store.data, equals(newData));
    });

    test("should add event to updateStream when set data", () {
      store.setData(new Persistent());

      mock.getLogs(callsTo("add")).verify(happenedOnce);
    });

    test("should add true t oupdateStream if data is changed", () {
      store.setData(new Persistent());

      mock.getLogs(callsTo("add", true)).verify(happenedOnce);
    });

    test("should add false to updateStream if data is not changed", () {
      store.setData(store.data);

      mock.getLogs(callsTo("add", false)).verify(happenedOnce);
    });
    
    test("should change data before push to updateStream", () {
      expect(oldData, isNot(equals(newData)));

      mock.when(callsTo("add")).thenCall(expectAsync((_) {
        expect(store.data, equals(newData));
      }));
      
      store.setData(newData);
    });
    
    test("should return old data when call setData", () {
      expect(oldData, isNot(equals(newData)));

      mock.when(callsTo("add")).thenCall(expectAsync((_) {
        expect(store.data, equals(newData));
      }));
      
      expect(store.setData(newData), equals(oldData));
    });
    
    test("should call modifier with data and set resutl as new data when call apply", () {
      store.apply((_) => newData);
      
      expect(store.data, equals(newData));
    });
  });
}

class StreamControllerMock extends Mock implements StreamController {}
