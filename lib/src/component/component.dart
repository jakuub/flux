part of flux_component;

class Component<T> extends tiles.Component {
  T get data => super.props != null ? super.props.data : null;
  Dispatcher get dispatcher => super.props != null ? super.props.dispatcher : null;

  Component(Props<T> props, [children]) : super(props, children) {
  }

  Props<T> createProps(T data) {
    return new Props<T>(data: data, dispatcher: super.props.dispatcher);
  }

  Props<T> cp(T data) => createProps(data);

  @override
  shouldUpdate(Props<T> newProps, Props<T> oldProps) => newProps != oldProps;

}
