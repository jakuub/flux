import 'package:unittest/unittest.dart';
import "store/store.dart" as store;
import "dispatcher/dispatcher.dart" as dispatcher;
import "component/component.dart" as component;
import "component/props.dart" as props;
import "helpers/if_null.dart" as ifNull;

main() {

  group("(store)", () {
    store.main();
  });
  group("(dispatcher)", () {
    dispatcher.main();
  });
  group("(component)", () {
    component.main();
    props.main();
  });
  group("(helpers)", () {
    ifNull.main();
  });

}
