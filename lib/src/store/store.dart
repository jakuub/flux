part of store;

class Store<P extends Persistent> {
  
  final StreamController _updateController; 

  P _data;

  P get data => _data;
  
  Stream get updated => _updateController.stream;

  Store(Dispatcher dispatcher, {P data, StreamController updateController}) : 
    _data = data, 
    _updateController = ifNull(updateController, new StreamController());
  
  P setData(P data) {
    P oldData = _data; 
    _data = data;
    _updateController.add(data != oldData);
    return oldData;
  }
  
  apply(modifier) {
    setData(modifier(data));
  }

}
