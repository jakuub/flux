library component_component_test;

import 'package:unittest/unittest.dart';
import 'package:flux/component.dart';
import 'package:flux/dispatcher.dart';
import 'package:vacuum_persistent/persistent.dart';
import 'package:tiles/tiles.dart' as tiles;

main() {
  group("(Component)", () {
    Dispatcher dispatcher = new Dispatcher();
    Persistent data = new Persistent();
    Persistent newData = new Persistent();
    Props props = new Props(dispatcher: dispatcher, data: data);
    Component component;
    
    setUp(() {
      component = new Component(props);
    });

    test("should have default constructor", () {
    });
    
    test("should extends tiles.Component", () {
      expect(component is tiles.Component, isTrue);
    });
    
    test("should have getter data which get super.props.data", () {
      expect(component.data, equals(props.data));
    });
    
    test("should have method createProps which create props from dispatcher and argumetn", () {
      Props newProps = component.createProps(newData);
      
      expect(newProps.dispatcher, equals(props.dispatcher));
      expect(newProps.data, equals(newData));
    });
    
    test("should compare old and new props by simple ==  in shouldUpdate method", () {
      Props oldProps = props;
      Props newProps = new Props(dispatcher: dispatcher, data: data);
      
      expect(component.shouldUpdate(oldProps, newProps), isFalse);
      
      newProps = new Props(dispatcher: dispatcher, data: new Persistent());
      expect(component.shouldUpdate(oldProps, newProps), isTrue);
      
      newProps = new Props(dispatcher: new Dispatcher(), data: data);
      expect(component.shouldUpdate(oldProps, newProps), isTrue);
    });
    
    test("should contain shortcut cp for createProps", () {
      expect(component.cp(newData).data, equals(component.createProps(newData).data));
      expect(component.cp(newData).dispatcher, equals(component.createProps(newData).dispatcher));
    });
    
    test("should offer passing children in constructor", () {
      var children = [tiles.div()];
      expect(() => component = new Component(props, children), isNot(throws));
      
      expect(component.children, equals(children));
    });
    
    test("should have getter dispatcher which get dispatcher from super.props", () {
      expect(component.dispatcher, equals(props.dispatcher));
    });
    
    test("should get data as null when prop are null", () {
      component = new Component(null);
      expect(component.data, isNull);
    });

    test("should get dispatcher as null when prop are null", () {
      component = new Component(null);
      expect(component.dispatcher, isNull);
    });
  });
}