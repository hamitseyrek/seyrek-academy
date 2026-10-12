void main() {
  /*
  maps
  key-value pairs
  anahtar-değer çiftleri
  */
  Map<String, int> ages = {"Ali": 30, "Ayşe": 25, "Mehmet": 35};
  print(ages["Ali"]);
  print(ages["Ayşe"]);
  print(ages["Mehmet"]);

  print(ages["Zeynep"]); // null döner, çünkü Zeynep map'te yok

  ages["Zeynep"] = 28; // Zeynep'i map'e ekler

  ages.entries.forEach((entry) {
    print("${entry.key}: ${entry.value}");
  });

  ages.addAll({"Ahmet": 40, "Fatma": 22}); // Birden fazla anahtar-değer çifti ekler

  ages.addEntries([MapEntry("Can", 32), MapEntry("Deniz", 27)]); // Birden fazla anahtar-değer çifti ekler

  ages.update("Ali", (value) => value + 1); // Ali'nin yaşını 1 artırır
  ages["Ali"] = 31; // Ali'nin yaşını doğrudan günceller

}