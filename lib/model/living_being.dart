class LivingBeing {

  bool isAlive = true;
  String _nickname = "Mai Zinda hun";

  String get name => _nickname;

  set name(String name) {
    if (name == "") {
      throw Exception("name cannot be null");
    }
    _nickname = name;
  }

  String format() {
    return "name: $_nickname and isAlive: $isAlive";
  }

  @override
  String toString() {
    return format();
  }
}

class Human extends LivingBeing {}
