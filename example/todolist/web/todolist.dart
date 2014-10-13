import 'dart:html';
import 'package:tiles/tiles.dart' as tiles;
import 'package:tiles/tiles_browser.dart' as tiles;
import 'package:flux/dispatcher.dart';
import 'package:flux/component.dart';

import '../lib/todostore.dart';
import '../lib/todolist.dart';

main () {
  tiles.initTilesBrowserConfiguration(); 
  
  Element container = new DivElement();
  querySelector("body").append(container);
  
  tiles.mountComponent(todoList(props: new Props(dispatcher: new Dispatcher())), container);
  
}