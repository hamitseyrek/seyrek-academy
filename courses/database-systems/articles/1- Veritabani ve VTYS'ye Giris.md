# Veritabani ve VTYS'ye Giris

Veri her yerde: okul sistemlerinde, e-ticarette, bankacilikta, mobil uygulamalarda, hatta basit bir rehber uygulamasinda bile.  
Asil soru su: Bu veriyi nasil saklayip yonetecegiz ki hem tutarli olsun hem de buyudukce kontrolu kaybetmeyelim?

Bu yazi, veritabanina neden ihtiyac duyuldugunu ve VTYS'nin (Veritabani Yonetim Sistemi) neden kritik oldugunu netlestirir.

---

## Veri, bilgi ve kayit farki

Bu uc kavram sik karisir:

- **Veri**: Ham degerdir. Ornek: `70`, `2023001`, `Ali`.
- **Bilgi**: Islenmis ve anlam kazanmis veridir. Ornek: "Ali'nin ortalamasi 3.10".
- **Kayit**: Bir varliga ait alanlarin bir araya gelmis halidir. Ornek: bir ogrencinin numara, ad, soyad ve bolum bilgisi.

Kisa bir ozet:

```text
Veri -> Isleme / Yorumlama -> Bilgi
```

---

## Dosya sistemi neden bir noktada yetersiz kalir?

Baslangicta her sey Excel veya CSV dosyalariyla kolay gorunur.  
Ama veri buyudukce sorunlar aciga cikmaya baslar.

Ornek:

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

Bu yapiyla karsilasilan tipik problemler:

- **Veri tekrari**: Ayni kisi birden fazla dosyada tekrar eder.
- **Tutarsizlik**: Bir dosyada guncellenen bilgi digerinde eski kalir.
- **Guvenlik sorunu**: Kim neyi degistirdi takibi zayif olur.
- **Yedekleme zorlugu**: Dosya bozulmasi veya silinmesi buyuk kayip yaratir.
- **Olcekleme sorunu**: Dosya sayisi arttikca yonetim karmasiklasir.

---

## Veritabani neyi cozer?

Veritabani, birbiriyle iliskili verileri merkezi ve kuralli sekilde saklar.  
Amaç sadece depolamak değil; veriyi doğru, güvenli ve yönetilebilir tutmaktır.

Karsilastirma:

```text
Dosya Sistemi                | Veritabani
----------------------------|-----------------------------
Daginik dosyalar            | Merkezi yapi
Yuksek tekrar riski         | Tek kaynak mantigi
Tutarsizlik olasiligi       | Butunluk kurallari
Sinirli erisim kontrolu     | Rol ve yetki yonetimi
```

---

## VTYS (DBMS) nedir?

Veritabaniyi yoneten yazilima **VTYS** denir.  
Kullanıcılar genelde veritabanıyla doğrudan değil, uygulamalar ve VTYS üzerinden iletişime geçer.

Akis:

```text
Kullanici -> Uygulama -> VTYS -> Veritabani
```

VTYS'nin temel gorevleri:

- Veriyi guvenli saklamak
- Eszamanli erisimi yonetmek
- Yedekleme ve geri yukleme sunmak
- Yetki ve rol yonetimi yapmak
- Veri butunlugunu korumak

---

## Populer VTYS ornekleri

- **MySQL**: Web projelerinde cok yaygin
- **PostgreSQL**: Guclu acik kaynak ve kurumsal kullanim
- **SQL Server**: Microsoft ekosisteminde yaygin
- **Oracle**: Buyuk kurumsal sistemlerde tercih edilir
- **SQLite**: Mobil ve gomulu uygulamalarda hafif cozum

Bu sistemler farklı ihtiyaçlara hitap etse de ortak hedef aynıdır: veriyi doğru ve güvenli yönetmek.

---

## Gercek hayat senaryosu: market stok takibi

Sadece dosyayla stok takibi yapildigini dusun:

- Urun miktari bir dosyada,
- Alim-satim hareketi baska dosyada,
- Tedarikci bilgisi baska dosyada.

Kisa surede sunlar olur:
- Ayni urun farkli yerlerde farkli isimle gecmeye baslar,
- Stok miktarlari birbiriyle uyusmaz,
- Hata oldugunda sorunun kaynagini bulmak zorlasir.

Ayni senaryo veritabaniyla kuruldugunda:
- Urun tek yerde tanimlanir,
- Iliskili tablolar tutarlilikla baglanir,
- Raporlama ve kontrol daha saglikli olur.

---

## Sonuc

Veritabani konusu SQL komutlarini ezberlemekten once bir **ihtiyac problemi**dir.  
Neden veritabani kullandigini netlestirdiginde, iliskisel model, SQL ve sorgulama konulari cok daha anlamli hale gelir.
