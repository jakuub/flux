library store_test;
import 'package:unittest/unittest.dart';
import 'package:flux/store.dart';
import 'package:flux/dispatcher.dart';
import 'package:vacuum_persistent/persistent.dart';
import 'dart:async';
import 'package:mock/mock.dart';

main() {
  group("(Store)", () {

    Store<PersistentMap> store;
    PersistentMap oldData;
    PersistentMap newData;
    StreamControllerMock mock;
    StreamController controller;


    setUp(() {
      newData = persistent({"key": {"key2": {"key3": 2}}});
      oldData = persistent({"key": {"key2": {"key3": 1}}});
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
    
    test("should have method update which update adequate key of passed Persistent object", () {
      newData = store.update(["key"], (_) => 2);
      
      expect(oldData, equals(newData));
      expect(store.data.get("key"), equals(2));
      expect(store.data, isNot(equals(newData)));
    });
    
    test("should update deep reference when used update with longer path", () {
      newData = store.update(["key", "key2", "key3"], (_) => 2);
      
      expect(store.data.get("key").get("key2").get("key3"), equals(2));
    });
    
    test("should add event to updated stream when called update", () {
      store.setData(persistent({"key": 1}));
      mock.clearLogs();
      store.update(["key"], (_) => 2);
      mock.getLogs(callsTo("add")).verify(happenedOnce);
    });
    
    test("should not create updated event if setData have attr notify false", () {
      store.setData(persistent({1:2}), notify: false);
      mock.getLogs(callsTo("add")).verify(neverHappened);
    });
    
    test("should not create updated event if apply have attr notify false", () {
      store.apply((_) => newData, notify: false);
      
      mock.getLogs(callsTo("add")).verify(neverHappened);
    });
    
    test("sould not create updated event if update have attr notify false", () {
      store.update(["key"], (_) => 2, notify: false);
      
      mock.getLogs(callsTo("add")).verify(neverHappened);
    });

    test("should insert deep reference when used insert with longer path", () {
      newData = store.insert(["key", "key2", "key3"], 2);
      
      expect(newData.get("key").get("key2").get("key3"), equals(1));
      expect(store.data.get("key").get("key2").get("key3"), equals(2));
    });
    
    test("should notify on insert method", () {
      newData = store.insert(["key", "key2", "key3"], 2);
      mock.getLogs(callsTo("add")).verify(happenedOnce);
    });

    test("sould not create updated event if insert have attr notify false", () {
      store.insert(["key"], 2, notify: false);
      mock.getLogs(callsTo("add")).verify(neverHappened);
    });
    
    group("(listen)", () {
      
      dynamic filter;
      dynamic callback;
      StreamMock dispatcherStream;
      StreamMock filteredDispatcherStream;
      DispatcherMock dispatcher; 
      
      setUp(() {
        filter =  (ff) => ff == filter;
        callback = new Mock();

        dispatcherStream = new StreamMock();
        filteredDispatcherStream = new StreamMock();
        
        mock
          .when(callsTo("get stream"))
            .alwaysReturn(dispatcherStream);
        dispatcherStream
          .when(callsTo("where"))
            .alwaysReturn(filteredDispatcherStream);
        
        dispatcher = new DispatcherMock();
        
        dispatcher
          .when(callsTo("get stream"))
            .alwaysReturn(dispatcherStream);

        store = new Store(dispatcher, updateController: mock, data: oldData);

      });
      
      test("should have method listen, which accepts map and apply listen from map correctly: key => listen filter, value => callback", () {
        store.listen({filter: callback});
        
        dispatcherStream.getLogs(callsTo("where", filter)).verify(happenedOnce);
        filteredDispatcherStream.getLogs(callsTo("listen", callback)).verify(happenedOnce);
      });
      
      test("should replace filter by compare function if filter is String", () {
        store.listen({"something to compare": callback});
        
        dispatcherStream.getLogs(callsTo("where", (filter) {
          return filter("something to compare") && !filter("something else"); 
        })).verify(happenedOnce);
      });

      test("should filter by type if event is Map and filter is String", () {
        store.listen({"something to compare": callback});
        
        dispatcherStream.getLogs(callsTo("where", (filter) {
          return filter({TYPE: "something to compare"}) && !filter({TYPE: "something else"}); 
        })).verify(happenedOnce);
      });
      
      test("should filter by attribute type if event is PersistentMap and filter is String", () {
        store.listen({"something to compare": callback});
        
        dispatcherStream.getLogs(callsTo("where", (filter) {
          return filter(persistent({TYPE: "something to compare"})) 
              && !filter(persistent({TYPE: "something else"})); 
        })).verify(happenedOnce);
      });

    });
    
  });
}

class StreamControllerMock extends Mock implements StreamController {}
class StreamMock extends Mock implements Stream {}
class DispatcherMock extends Mock implements Dispatcher {}
