//import the test package
import 'package:flutter_test/flutter_test.dart';
import 'package:immunization_mobile/stuff.dart';

void main() {
  //write tests
  test("text string should change", () {
    final weTest = WeTest();

    weTest.populateText(2, 3);

    expect(weTest.text, "Hey, I am getting the number: 5");
  });
}
