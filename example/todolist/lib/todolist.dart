library todolist;

import "package:flux/component.dart";
import 'package:tiles/tiles.dart' as tiles;
import 'newtodo.dart';
import 'list.dart';


class TodoList extends Component {

  TodoList(props) : super(props) {

    data.onChange.listen((_) => redraw());
  }

  render() {
    return tiles.div(children: [newTodo(props: cp(data.deref())), list(props: cp(data.deref().get("todos")))]);
  }

}

tiles.ComponentDescriptionFactory todoList = tiles.registerComponent(({props, children}) => new TodoList(props));
