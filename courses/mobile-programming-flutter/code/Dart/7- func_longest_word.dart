/*
Girilen metin içerisindeki en uzun kelimeyi bulan fonksiyonu yazınız.
*/

String findLongestWord(String sentence) {
  List<String> wordList = sentence.split(" ");
  String longestWord = "";

  wordList.forEach((word) {
    if (word.length > longestWord.length) {
      longestWord = word;
    }
  });

  return longestWord;
}

void main() {
  String result = findLongestWord('''String findLongestWord(String sentence) {
  List<String> wordList = sentence.split(" ");
  String longestWord = "";

  wordList.forEach((word) {
    if (word.length > longestWord.length) {
      longestWord = word;
    }
  });

  return longestWord;
}''');

print(result);
}