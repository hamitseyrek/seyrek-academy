void main() {
  Student student1 = Student("Ali", 25);
  student1.printInfo();

}

class Student {
  String name;
  int age;

  Student(this.name, this.age);

  Student.onlyName(this.name) : age = 0;

  void printInfo() {
    print("Name: $name, Age: $age");
  }
}