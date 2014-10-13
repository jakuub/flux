library component_props_test;

import 'package:unittest/unittest.dart';
import 'package:flux/component.dart';
import 'package:flux/dispatcher.dart';
import 'package:vacuum_persistent/persistent.dart';

main() {
  group("(Props)", () {
    Dispatcher dispatcher = new Dispatcher();
    Persistent data = new Persistent();

    test("should have dispacher required in constructor", () {
      expect(() => new Props(), throws);
      expect(() => new Props(dispatcher: new Dispatcher()), isNot(throws));
    });

    test("should have dispatcher setted in constructor", () {
      Props props = new Props(dispatcher: dispatcher);

      expect(props.dispatcher, equals(dispatcher));
    });

    test("should have data in constructor and offer them by getter", () {
      Props props = new Props(dispatcher: dispatcher, data: data);

      expect(props.data, equals(data));
    });

    test("should have final data and dispatcher", () {
      Props props = new Props(dispatcher: dispatcher, data: data);

      expect(() => props.data = new Persistent(), throws);
      expect(() => props.dispatcher = new Dispatcher(), throws);
      
      expect(props.data, equals(data));
      expect(props.dispatcher, equals(dispatcher));
    });
    
    test("should overload == operator to compare data AND dispatcher", () {
      expect(new Props(dispatcher: dispatcher), equals(new Props(dispatcher: dispatcher)));
    });
  });
}
