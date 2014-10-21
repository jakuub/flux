library list;

import "package:flux/component.dart";
import 'package:tiles/tiles.dart' as tiles;
import 'package:vacuum_persistent/persistent.dart';

class List extends Component<PersistentVector> {
  List(props) : super(props);
  
  render() {
    return tiles.div(children: [
      tiles.div(children: "${countDone()} done issues"),
      renderTodos(),
      tiles.button(children: "remove done todos", listeners: {"onClick": removeDone})
    ]);
  }
  
  renderTodos() {
    num counter = 0;
    return tiles.ul(children: data.map((PersistentMap todo) => renderTodo(todo, counter++)).toList());
  }
  
  renderTodo(PersistentMap todo, num index) {
    return tiles.li(key: todo.get("id"), children: [
      tiles.input(
        props: {"type": "checkbox"}..addAll(todo.get("done") ? {"checked": "checked"} : {}), 
        listeners: {"onChange": checked(index)}),
      tiles.input(
        props: {"type": "text", "value": todo.get("text")}, 
        listeners: {"onChange": textChange(index)}),
      tiles.span(children: todo.get("text"))
    ]);
  }
  
  num countDone() {
    num count = 0;
    data.forEach((PersistentMap todo) {
      if (todo.get("done")) {
        count++;
      }
      return todo;
    });
    
    return count;
  }
  
  checked(num i) {
    return (comp, ev) {
      dispatcher.dispatch({"type": "list.checkedChange", "index": i, "checked": ev.target.checked});
    };
  }
  
  textChange(num i) {
    return (comp, ev) {
      dispatcher.dispatch({"type": "list.textChange", "index": i, "text": ev.target.value});
    };
  }
  
  removeDone(comp, ev) {
    ev.preventDefault();
    dispatcher.dispatch({"type": "list.removeDone"});
  }
}

tiles.ComponentDescriptionFactory list = tiles.registerComponent(({props, children}) => new List(props));
