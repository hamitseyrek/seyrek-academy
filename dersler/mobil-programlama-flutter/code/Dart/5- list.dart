void main() {

  List<String> names = [];
  names.add("Alice");
  names.add("Bob");
  names.add("Charlie");

  names.removeAt(1);

  bool hasAlice = names.any((name) => name == "Alice");

  print(hasAlice);
  print(names[0]);

  names.forEach((name) {
    print(name);
  });

  for (String name in names) {
    print(name);
  } 

}