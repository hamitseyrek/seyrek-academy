void main() {
  int result = sumTwoNumbers(5, 10);
  print(result);

  List<int> numbers = [3, 7, 2, 9, 5, 6];
  int maxValue = findMaxInArray(numbers);
  print(maxValue);

  List<int> evenNumbers = findEvenNumbers(numbers);
  print(evenNumbers);

  String originalString = "Hello, World!";
  String reversedString = reverseString(originalString);
  print(reversedString);
}

// iki sayıyı toplayan bir fonksiyon
int sumTwoNumbers(int a, int b) {
  return a + b;
}

// bir diziyi parametre olarak alan ve maksimum değeri bulan bir fonksiyon
int findMaxInArray(List<int> numbers) {
  int max = numbers[0];
  for (int i = 1; i < numbers.length; i++) {
    if (numbers[i] > max) {
      max = numbers[i];
    }
  }
  return max;
}

// bir diziyi parametre olarak alan ve sadece çift sayıları içeren yeni bir dizi döndüren bir fonksiyon
List<int> findEvenNumbers(List<int> numbers) {
  List<int> result = [];

  for (int i = 0; i < numbers.length; i++) {
    if (numbers[i] % 2 == 0) {
      result.add(numbers[i]);
    }
  }

  return result;
}

// bit stringi parametre olarak alıp tersine çeviren bir fonksiyon
String reverseString(String input) {
  String reversed = "";
  for (int i = input.length - 1; i >= 0; i--) {
    reversed += input[i];
  }
  return reversed;
}
