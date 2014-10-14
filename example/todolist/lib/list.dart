library list;

import "package:flux/component.dart";
import 'package:tiles/tiles.dart' as tiles;
import 'package:tiles/tiles_browser.dart' as tiles;
import 'todostore.dart';
import 'package:flux/dispatcher.dart';
import 'package:vacuum_persistent/persistent.dart';

class List extends Component<PersistentVector> {
  List(props) : super(props);
  
  render() {
    num count = 0;
    data.forEach((PersistentMap todo) {
      if (todo.get("done")) {
        count++;
      }
      return todo;
    });
    num counter = 0;

    return tiles.div(children: [
      tiles.div(children: "$count done issues"),
      tiles.ul(children: data.map((PersistentMap todo) => tiles.li(children: [
        tiles.input(
          props: {"type": "checkbox"}..addAll(todo.get("done") ? {"checked": "checked"} : {}), 
          listeners: {"onChange": checked(counter)}),
        tiles.input(
          props: {"type": "text", "value": todo.get("text")}, 
          listeners: {"onChange": textChange(counter++)}),
        tiles.span(children: todo.get("text"))
      ])).toList()),
      tiles.button(children: "remove done todos", listeners: {"onClick": removeDone})
    ]);
  }
  
  checked(num i) {
    return (comp, ev) {
      dispatcher.dispatch({"event": "list.checkedChange", "index": i, "checked": ev.target.checked});
    };
  }
  
  textChange(num i) {
    return (comp, ev) {
      dispatcher.dispatch({"event": "list.textChange", "index": i, "text": ev.target.value});
    };
  }
  
  removeDone(comp, ev) {
    ev.preventDefault();
    dispatcher.dispatch({"event": "list.removeDone"});
  }
}

tiles.ComponentDescriptionFactory list = tiles.registerComponent(({props, children}) => new List(props));
