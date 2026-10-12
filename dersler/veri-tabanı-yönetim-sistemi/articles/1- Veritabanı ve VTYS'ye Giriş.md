# Veritabanı ve VTYS'ye Giriş

Veri her yerde: okul sistemlerinde, e-ticarette, bankacılıkta, mobil uygulamalarda, hatta basit bir rehber uygulamasında bile.  
Asıl soru şu: Bu veriyi nasıl saklayip yöneteceğiz ki hem tutarlı olsun hem de büyüdükçe kontrolü kaybetmeyelim?

Bu yazı, veritabanına neden ihtiyaç duyulduğunu ve VTYS'nin (Veritabanı Yönetim Sistemi) neden kritik olduğunu netleştirir.

---

## Veri, bilgi ve kayıt farkı

Bu üç kavram sık karışır:

- **Veri**: Ham degerdir. Örnek: `70`, `2023001`, `Ali`.
- **Bilgi**: İşlenmiş ve anlam kazanmış veridir. Örnek: "Ali'nin ortalaması 3.10".
- **Kayit**: Bir varliga ait alanların bir araya gelmiş hâlidir. Örnek: bir ogrencinin numara, ad, soyad ve bolum bilgisi.

Kısa bir özet:

```text
Veri -> Isleme / Yorumlama -> Bilgi
```

---

## Dosya sistemi neden bir noktada yetersiz kalir?

Başlangıçta her şey Excel veya CSV dosyalarıyla kolay görünür.  
Ama veri büyüdükçe sorunlar açığa çıkmaya başlar.

Örnek:

```text
ogrenciler.xlsx
id | first_name | department
1  | Ali        | Computer Engineering
2  | Ayse       | Computer Engineering

borclar.xlsx
id | customer_name | debt_amount
1  | Ali           | 500
3  | Mehmet        | 300
```

Bu yapiyla karşılaşılan tipik problemler:

- **Veri tekrarı**: Aynı kisi birden fazla dosyada tekrar eder.
- **Tutarsızlık**: Bir dosyada güncellenen bilgi diğerinde eski kalir.
- **Güvenlik sorunu**: Kim neyi değiştirdi takibi zayıf olur.
- **Yedekleme zorluğu**: Dosya bozulmasi veya silinmesi büyük kayıp yaratir.
- **Ölçekleme sorunu**: Dosya sayısı arttıkça yönetim karmaşıklaşır.

---

## Veritabanı neyi çözer?

Veritabanı, birbiriyle ilişkili verileri merkezi ve kurallı şekilde saklar.  
Amaç sadece depolamak değil; veriyi doğru, güvenli ve yönetilebilir tutmaktır.

Karşılaştırma:

```text
Dosya Sistemi                | Veritabanı
----------------------------|-----------------------------
Daginik dosyalar            | Merkezi yapi
Yuksek tekrar riski         | Tek kaynak mantigi
Tutarsızlık olasılığı       | Bütünlük kuralları
Sinirli erisim kontrolu     | Rol ve yetki yonetimi
```

---

## VTYS (DBMS) nedir?

Veritabanını yöneten yazılıma **VTYS** denir.  
Kullanıcılar genelde veritabanıyla doğrudan değil, uygulamalar ve VTYS üzerinden iletişime geçer.

Akış:

```text
Kullanici -> Uygulama -> VTYS -> Veritabanı
```

VTYS'nin temel gorevleri:

- Veriyi güvenli saklamak
- Eşzamanlı erişimi yönetmek
- Yedekleme ve geri yükleme sunmak
- Yetki ve rol yönetimi yapmak
- Veri bütünlüğünü korumak

---

## Popüler VTYS örnekleri

- **MySQL**: Web projelerinde çok yaygın
- **PostgreSQL**: Güçlü açık kaynak ve kurumsal kullanım
- **SQL Server**: Microsoft ekosisteminde yaygın
- **Oracle**: Büyük kurumsal sistemlerde tercih edilir
- **SQLite**: Mobil ve gömülü uygulamalarda hafif çözüm

Bu sistemler farklı ihtiyaçlara hitap etse de ortak hedef aynıdır: veriyi doğru ve güvenli yönetmek.

---

## Gerçek hayat senaryosu: market stok takibi

Sadece dosyayla stok takibi yapıldığını düşün:

- Ürün miktarı bir dosyada,
- Alım-satım hareketi başka dosyada,
- Tedarikçi bilgisi başka dosyada.

Kısa sürede şunlar olur:
- Aynı ürün farklı yerlerde farklı isimle geçmeye başlar,
- Stok miktarları birbiriyle uyuşmaz,
- Hata olduğunda sorunun kaynağını bulmak zorlaşır.

Aynı senaryo veritabanıyla kurulduğunda:
- Ürün tek yerde tanımlanır,
- İlişkili tablolar tutarlilikla bağlanır,
- Raporlama ve kontrol daha sağlıklı olur.

---

## Sonuç

Veritabanı konusu SQL komutlarini ezberlemekten önce bir **ihtiyaç problemi**dir.
Neden veritabanı kullandığını netleştirdiğinde, ilişkisel model, SQL ve sorgulama konuları çok daha anlamlı hale gelir.
