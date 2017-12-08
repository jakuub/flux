part of flux_component;

class Props<T> {
  final Dispatcher dispatcher;
  final T data;

  get int hashCode => data.hashCode * dispatcher.hashCode;

  Props({this.dispatcher, this.data}) {
    if (dispatcher == null) {
      throw "dispatcher should not be null";
    }
  }

  @override
  operator ==(Props other) {
    return this.data.hashCode == other.data.hashCode && this.dispatcher.hashCode == other.dispatcher.hashCode;
  }
}
