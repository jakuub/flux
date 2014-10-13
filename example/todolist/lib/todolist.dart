library todolist;

import "package:flux/component.dart";
import 'package:tiles/tiles.dart' as tiles;
import 'package:tiles/tiles_browser.dart' as tiles;
import 'todostore.dart';
import 'newtodo.dart';
import 'package:flux/dispatcher.dart';
import 'package:vacuum_persistent/persistent.dart';


class TodoList extends Component {
  TodoStore _store;
  
  TodoList(props) : super(props) {
    _store = new TodoStore(dispatcher, data: new PersistentMap());
    _store.updated.listen(redraw);
  }
  
  render() {
    return tiles.div(children: [
      newTodo(props: cp(_store.data))
    ]);
  }
  
}

tiles.ComponentDescriptionFactory todoList = tiles.registerComponent(({props, children}) => new TodoList(props));