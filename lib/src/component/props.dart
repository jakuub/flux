part of component;

class Props<T> {
  final Dispatcher dispatcher;
  final T data;
  
  Props({this.dispatcher, this.data}) {
    if (dispatcher == null) {
      throw "dispatcher should not be null";
    }
  }
  
  @override
  operator ==(Props other) {
    return this.data == other.data && this.dispatcher == other.dispatcher;
  }
}