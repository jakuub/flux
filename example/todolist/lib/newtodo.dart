library newtodo;

import "package:flux/component.dart";
import 'package:tiles/tiles.dart' as tiles;
import 'package:tiles/tiles_browser.dart' as tiles;
import 'todostore.dart';
import 'package:flux/dispatcher.dart';
import 'package:vacuum_persistent/persistent.dart';

class NewTodo extends Component<PersistentMap> {
  NewTodo(props) : super(props);
  
  render() {
    return tiles.form(listeners: {"onSubmit": submit}, children: [
      tiles.input(
          props: {"value": data.get("newText", "")},
          listeners: {"onChange": newTextChange}),
      tiles.button(props: {"type": "submit"}, children: "submit")
    ]);
  }
  
  newTextChange(comp, ev) {
    dispatcher.dispatch({"event": "newtodo.change", "text": ev.target.value});
  }
  
  submit(comp, ev) {
    ev.preventDefault();
    dispatcher.dispatch({"event": "newtodo.submit"});
  }
}

tiles.ComponentDescriptionFactory newTodo = tiles.registerComponent(({props, children}) => new NewTodo(props));
