void main() {
  print("Hamit");
  printName(name: "Hamit", surname: null);

  int square(int x) => x * x;

  var aa = square(5);

  print(aa);
}

// int square(int x) {
//   return x * x;
// }

void printName({String? name, required String? surname}) {
  print(name);
}




