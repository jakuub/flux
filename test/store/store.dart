library store_test;
import 'package:unittest/unittest.dart';
import 'package:flux/store.dart';
import 'package:flux/dispatcher.dart';
import 'package:flux/helpers.dart';
import 'package:vacuum_persistent/persistent.dart';
import 'dart:async';
import 'package:mock/mock.dart';

main() {
  group("(Store)", () {

    Store store;
    PersistentMap oldData;
    PersistentMap newData;
    StreamController controller;
    Reference dataRef;


    setUp(() {
      newData = persist({
        "key": {
          "key2": {
            "key3": 2
          }
        }
      });
      oldData = persist({
        "key": {
          "key2": {
            "key3": 1
          }
        }
      });
      dataRef = new Reference(oldData);
      dataRef.cursor;
      controller = new StreamController();
      store = new Store(null, dataRef.cursor);
    });

    test("should have constructor with dispatcher", () {
      new Store(new Dispatcher(), dataRef.cursor);
    });

    test("should have persitend data", () {
      expect(store.data, isNotNull);
      expect(store.data is PersistentIndexedCollection, isTrue);
    });

    test("should have required param in constructor for cursor", () {
      store = new Store(null, dataRef.cursor);

      expect(() => new Store(null, null), throws);
    });


    test("should have method setData which set data", () {
      store.setData(newData);

      expect(store.data, equals(newData));
    });

    test("should return old data when call setData", () {
      expect(oldData, isNot(equals(newData)));

      expect(store.setData(newData), equals(oldData));

      expect(store.data, equals(newData));
    });

    test("should call modifier with data and set resutl as new data when call apply", () {
      store.apply((_) => newData);

      expect(store.data, equals(newData));
    });

    test("should have method update which update adequate key of passed PersistentIndexedCollection object", () {
      newData = store.update(["key"], (_) => 2);

      expect(oldData, equals(newData));
      expect(store.data.get("key"), equals(2));
      expect(store.data, isNot(equals(newData)));
    });

    test("should update deep reference when used update with longer path", () {
      newData = store.update(["key", "key2", "key3"], (_) => 2);

      expect(store.data.get("key").get("key2").get("key3"), equals(2));
    });

    test("should insert deep reference when used insert with longer path", () {
      newData = store.insert(["key", "key2", "key3"], 2);

      expect(newData.get("key").get("key2").get("key3"), equals(1));
      expect(store.data.get("key").get("key2").get("key3"), equals(2));
    });

    test("should have public dispatcher", () {
      DispatcherMock dispatcher = new DispatcherMock();
      store = new Store(dispatcher, dataRef.cursor);

      expect(store.dispatcher, equals(dispatcher));
    });

    group("(listen)", () {

      dynamic filter;
      dynamic callback;
      StreamMock dispatcherStream;
      StreamMock filteredDispatcherStream;
      DispatcherMock dispatcher;

      setUp(() {
        filter = (ff) => ff == filter;
        callback = new Mock();

        dispatcherStream = new StreamMock();
        filteredDispatcherStream = new StreamMock();

        dispatcherStream.when(callsTo("where")).alwaysReturn(filteredDispatcherStream);

        dispatcher = new DispatcherMock();

        dispatcher.when(callsTo("get stream")).alwaysReturn(dispatcherStream);

        store = new Store(dispatcher, dataRef.cursor);

      });

      test("should have method listen, which accepts map and apply listen from map correctly: key => listen filter, value => callback", () {
        store.listen({
          filter: callback
        });

        dispatcherStream.getLogs(callsTo("where", filter)).verify(happenedOnce);
        filteredDispatcherStream.getLogs(callsTo("listen", callback)).verify(happenedOnce);
      });

      test("should replace filter by compare function if filter is String", () {
        store.listen({
          "something to compare": callback
        });

        dispatcherStream.getLogs(callsTo("where", (filter) {
          return filter("something to compare") && !filter("something else");
        })).verify(happenedOnce);
      });

      test("should filter by type if event is Map and filter is String", () {
        store.listen({
          "something to compare": callback
        });

        dispatcherStream.getLogs(callsTo("where", (filter) {
          return filter({
            TYPE: "something to compare"
          }) && !filter({
            TYPE: "something else"
          });
        })).verify(happenedOnce);
      });

      test("should filter by attribute type if event is PersistentMap and filter is String", () {
        store.listen({
          "something to compare": callback
        });

        dispatcherStream.getLogs(callsTo("where", (filter) {
          return filter(persist({
            TYPE: "something to compare"
          })) && !filter(persist({
            TYPE: "something else"
          }));
        })).verify(happenedOnce);
      });

    });

  });
}

class StreamControllerMock extends Mock implements StreamController {}
class StreamMock extends Mock implements Stream {}
class DispatcherMock extends Mock implements Dispatcher {}
