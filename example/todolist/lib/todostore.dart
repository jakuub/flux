library todostore;
import "package:flux/store.dart";
import "package:vacuum_persistent/persistent.dart";
import 'package:flux/dispatcher.dart';

class TodoStore extends Store<PersistentMap> {
  TodoStore(Dispatcher dispatcher, {PersistentMap data})
      : super(dispatcher, data: data != null ? data : persistent({})) {
    listen({
      "newtodo.change": newTextChange,
      "newtodo.submit": newTodoSubmit,
      "list.checkedChange": checkChange,
      "list.textChange": textChange,
      "list.removeDone": removeDone,
    });

    insert(["newText"], "", notify: false);
    insert(["todos"], new PersistentVector(), notify: false);
  }

  newTextChange(Map event) {
    update(["newText"], ([_]) => event["text"]);
  }
  newTodoSubmit(Map event) {

    update(["todos"], ([PersistentVector todos]) => todos.push(per({
      "id": "id_${todos.length}",
      "text": data.get("newText"),
      "done": false,
    })), notify: false);
    insert(["newText"], "");

  }

  checkChange(Map event) {
    num index = event["index"];
    bool checked = event["checked"];

    insert(["todos", index, "done"], checked);
  }

  textChange(Map event) {
    num index = event["index"];
    String text = event["text"];

    insert(["todos", index, "text"], text);

  }

  removeDone(_) {
    List newTodos = [];
    data.get("todos").forEach((PersistentMap todo) {
      if (!todo.get("done")) {
        newTodos.add(todo);
      }
    });
    insert(["todos"], per(newTodos));
  }

}
