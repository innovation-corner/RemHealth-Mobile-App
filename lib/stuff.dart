//define class to test
class WeTest {
  String text = "Hey, I am getting the number: ";

  populateText(int a, int b) {
    int value = a + b;

    text = text + value.toString();
  }
}
