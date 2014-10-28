part of store;

class Store<P extends PersistentIndexedCollection> {
  
  final StreamController _updateController; 

  P _data;

  P get data => _data;
  
  Stream get updated => _updateController.stream;
  
  final Dispatcher _dispatcher;

  Store(this._dispatcher, {P data, StreamController updateController}) : 
    _data = data, 
    _updateController = ifNull(updateController, new StreamController());
  
  P setData(P data, {bool notify: true}) {
    P oldData = _data; 
    _data = data;
    
    if (notify) {
      _updateController.add(data != oldData);
    }
    
    return oldData;
  }
  
  apply(modifier, {bool notify: true}) {
    setData(modifier(data), notify: notify);
  }
  
  P update(List path, Function updater, {bool notify: true}) {
    return setData(insertIn(data, path, updater(lookupIn(data, path))), notify: notify);
  }
  
  P insert(List path, dynamic value, {bool notify: true}) {
    return setData(insertIn(data, path, value), notify: notify);
  }
  
  void listen(Map listeners) {
    listeners.forEach((filter, callback) {
      if(!(filter is Function)) {
        filter = _compare(filter);
      }
      _dispatcher.stream.where(filter).listen(callback);
    });
  }
  
  _compare (valueToCompare) {
    return (value) {
      if(value is Map && value[TYPE] == valueToCompare) {
        return true;
      } else if (value is PersistentMap && value.get(TYPE, null) == valueToCompare) {
        return true;
      }
      return value == valueToCompare;
    };
  }

}

const String TYPE = "type";