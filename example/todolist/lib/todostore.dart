library todostore;
import "package:flux/store.dart";
import "package:vacuum_persistent/persistent.dart";
import 'package:flux/dispatcher.dart';

class TodoStore extends Store<PersistentMap> {
  TodoStore(Dispatcher dispatcher, {PersistentMap data}) : super(dispatcher, data: data) {
    dispatcher.stream
      ..where((ev) => ev["event"] == "newtodo.change")
        .listen(newTextChange)
      ..where((ev) => ev["event"] == "newtodo.submit")
        .listen(newTodoSubmit)
      ..where((ev) => ev["event"] == "list.checkedChange")
        .listen(checkChange)
      ..where((ev) => ev["event"] == "list.textChange")
        .listen(textChange)
      ..where((ev) => ev["event"] == "list.removeDone")
        .listen(removeDone);
    
    if(data.get("newText", "") == "") {
      setData(data.update("newText", () => ""));
    }
    if(data.get("todos", "") == "") {
      setData(data.update("todos", () => new PersistentVector()));
    }
  }
  
  newTextChange(Map event) {
    setData(data.update("newText", ([_]) => event["text"]));
  }
  newTodoSubmit(Map event) {
    TransientMap transData = data.asTransient();
    
    transData.doUpdate("todos", ([PersistentVector todos]) => todos.push(new PersistentMap.fromMap({"text": data.get("newText"), "done": false})));
    transData.doUpdate("newText", ([_]) => "");
    
    setData(transData.asPersistent());
  }
  
  checkChange(Map event) {
    num index = event["index"];
    bool checked = event["checked"];
    PersistentMap todo = data.get("todos").get(index);
    PersistentMap newTodo = todo.update("done", (_) => checked);
        
    setData(data.update("todos", (PersistentVector todos) => todos.set(index, newTodo)));
  }
  
  textChange(Map event) {
    num index = event["index"];
    String text = event["text"];
    PersistentMap todo = data.get("todos").get(index);
    PersistentMap newTodo = todo.update("text", (_) => text);
        
    setData(data.update("todos", (PersistentVector todos) => todos.set(index, newTodo)));
  }
  
  removeDone(_) {
    List newTodos = [];
    data.get("todos").forEach((PersistentMap todo) {
      if(!todo.get("done")) {
        newTodos.add(todo);
      }
    });
    setData(data.update("todos", (PersistentVector todos) => new PersistentVector.from(newTodos)));
  }
  
}
