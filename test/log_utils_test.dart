import 'package:flutter_test/flutter_test.dart';

import 'package:log_utils/log_utils.dart';

void main() {
  test('adds one to input values', () {
    final log = LogUtils()..init("/Users/jinxiaobing/Log", "operation", maxLength: 10240, maxFileCount: 2);
    for (int i = 0; i < 1000; i++) {
      log.log(
          "$i abcdefafasdfahdfasfkjhasdfkjlhasdfjkahdfkjhakjlhfkalhdgkjahgjkhakgjhakshgkahdkgfhaskldghaklsghkljahdkghaskdjghakjshdgklajhsdgkjlasdg");
    }
  });
}
