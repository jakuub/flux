flux
====
[![Build Status](https://drone.io/github.com/jakuub/flux/status.png)](https://drone.io/github.com/jakuub/flux/latest)

The simple implementation of facebook Flux in Dart language.

> This is a simple, maybe not totally correct implementation of Flux patter by Facebook.

The *flux* package contains 3 main parts of the Flux pattern, store, dispatcher and views. 

Store
------
Store is represented by the class `Store`, which contain `data` as some Persistent structure.
Store is directly dependent on [Persistent package by VacuumLabs](https://github.com/vacuumlabs/persistent). The store maintain the state of the application in persistent structure stored in data. It offers api for manipulating with the Store. Here is some example of the store:

```dart
class TodoStore extends Store<PersistentMap> {
  TodoStore(Dispatcher dispatcher, {PersistentMap data}) : super(dispatcher, data) {
    listen({
      "newtodo.change": newTextChange,
      "newtodo.submit": newTodoSubmit,
      "list.checkedChange": checkChange,
    });
    
    setData(persistent({
      "newText": "",
      "todos": [],
    }), notify: false); // default empty data
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

}
```
More focus on store is in the wiki [Store].

Dispatcher
-------------
Dispatcher is mainly implemented by default `dart:async` `Stream`. It create the wrapper around the `StreamController` and `Stream`. The whole api is
```dart
class Dispatcher<E> {
  Stream stream;
  void dispatch(E event);
  Dispatcher([StreamController<E> controller])
}
```

The `stream` is the stream of events passed to the `dispatch` method. Everything, the the `dispatch` method only do `.add(event)` on the `StreamController` passed as argument to its contructor. If no controller is passed, the Dispatcher create one for itself.

Views = tiles
---------------
Views are implemented by [tiles library](https://github.com/cleandart/tiles). 
Tiles is dart implementation of design pattern of the [Facebook React](http://facebook.github.io/react/) library.
The only aditional functionality implemented in this library is the `Component` class which extends `tiles.Component` and add functionality of persistent `props` and easy passing of `Dispatcher` instance from the parent to children in the virtual DOM.

`Component` optimize speed by using persistent data to store props and implement `shouldUpdate` as comparision of old and new `props`. If the `props` are same, the component don't need to be updated. 

*This relies on the fact, that all components are stateless and all application state is stored in the stores.*

Disclaimer
------------
This package is purposely not published in the [pub.dartlang.org](pub.dartlang.org), because it is in highly development mode and have very unstable API. 
If you have any questions or proposals, please feel free to write an issue :-).