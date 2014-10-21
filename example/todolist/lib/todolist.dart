library todolist;

import "package:flux/component.dart";
import 'package:tiles/tiles.dart' as tiles;
import 'todostore.dart';
import 'newtodo.dart';
import 'list.dart';


class TodoList extends Component {
  TodoStore _store;
  
  TodoList(props) : super(props) {
    _store = new TodoStore(dispatcher);
    _store.updated.listen(redraw);
  }
  
  render() {
    return tiles.div(children: [
      newTodo(props: cp(_store.data)),
      list(props: cp(_store.data.get("todos")))
    ]);
  }
  
}

tiles.ComponentDescriptionFactory todoList = tiles.registerComponent(({props, children}) => new TodoList(props));