import 'dart:html';
import 'package:tiles/tiles.dart' as tiles;
import 'package:tiles/tiles_browser.dart' as tiles;
import 'package:flux/dispatcher.dart';
import 'package:flux/component.dart';

import '../lib/todolist.dart';
import '../lib/todostore.dart';
import 'package:vacuum_persistent/persistent.dart';

main () {
  tiles.initTilesBrowserConfiguration();
  
  Dispatcher dispatcher = new Dispatcher();
  Reference _dataReference = new Reference(persist({}));
  
  /**
   * it is not needed to remember the reference to store in this app, because it just listen on dispatcher and manipulate with cursor.
   * 
   * TodoStore maintain the internal state of the application 
   */
  new TodoStore(dispatcher, _dataReference.cursor);
  
  /**
   * create the container for the TodoList and append it at the end of the body 
   */
  Element container = new DivElement();
  querySelector("body").append(container);
  
  /**
   * and finaly mount the component to the container.
   */
  tiles.mountComponent(todoList(props: new Props(dispatcher: dispatcher, data: _dataReference)), container);
  
}