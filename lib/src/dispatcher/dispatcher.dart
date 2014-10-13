part of dispatcher;

class Dispatcher<E> {
  /**
   * broadcast stream controller
   */
  StreamController<E> _controller;
  
  /**
   * stream offered to listeners
   */
  Stream<E> get stream => _controller.stream;
  
  Dispatcher([StreamController<E> controller]): _controller = ifNull(controller, new StreamController<E>.broadcast());
  
  void dispatch(E event) {
    _controller.add(event);
  }
}

