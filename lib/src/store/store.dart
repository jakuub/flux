part of store;

class Store<P extends PersistentIndexedCollection> {
  final Cursor cursor;

  P get data => cursor.deref();

  final Dispatcher _dispatcher;

  Store(this._dispatcher, this.cursor) {
    if (cursor == null) {
      throw "cursor is required for Store constructor";
    }
  }

  P setData(P data) {
    P oldData = cursor.deref();

    cursor.update((_) => data);

    return oldData;
  }

  apply(modifier) {
    setData(modifier(data));
  }

  P update(List path, Function updater) {
    return setData(insertIn(data, path, updater(lookupIn(data, path))));
  }

  P insert(List path, dynamic value) {
    return setData(insertIn(data, path, value));
  }

  void listen(Map listeners) {
    listeners.forEach((filter, callback) {
      if (!(filter is Function)) {
        filter = _compare(filter);
      }
      _dispatcher.stream.where(filter).listen(callback);
    });
  }

  _compare(valueToCompare) {
    return (value) {
      if (value is Map && value[TYPE] == valueToCompare) {
        return true;
      } else if (value is PersistentMap && value.get(TYPE, null) == valueToCompare) {
        return true;
      }
      return value == valueToCompare;
    };
  }

}

const String TYPE = "type";
