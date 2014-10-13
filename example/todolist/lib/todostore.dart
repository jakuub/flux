library todostore;
import "package:flux/store.dart";
import "package:vacuum_persistent/persistent.dart";
import 'package:flux/dispatcher.dart';

class TodoStore extends Store<PersistentMap> {
  TodoStore(Dispatcher dispatcher, {PersistentMap data}) : super(dispatcher, data: data) {
    dispatcher.stream
      //.where((ev) => ev["type"] == "newtodo.change")
      .listen(textChange);
  }
  
  textChange(event) {
    setData(data.update("newText", ([_]) => event["text"]));
  }
    
  
}
