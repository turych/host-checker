

import '../lib/hostchecker.dart';

void main(List<String> arguments) {

  if (arguments.length != 2) {
    print("wrong agruments");
    return;
  }

  var type = CheckType.values.byName(arguments[0]);
  var host = arguments[1];

  HostChecker(type, host).run();
}
