class Animal {
  void makeSound() {
    print("Bu hayvan ses çıkarır.");
  }
}

class Dog extends Animal {
  @override
  void makeSound() {
    print("Hav hav hav");
  }
}

class Cat extends Animal {
  @override
  void makeSound() {
    print("Miyav miyav miyav");
  }
}

void main() {
  Dog dog1 = Dog();
  dog1.makeSound();

  Cat cat1 = Cat();
  cat1.makeSound();
}