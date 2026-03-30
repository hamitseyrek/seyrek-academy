# Veritabanı Tasarımı: Normalizasyon

İlişkisel veritabanlarında en kritik hedeflerden biri, veriyi tekrar etmeden ve tutarlılığı bozmadan saklamaktır.
Normalizasyon, bu hedefe ulaşmak için kullanılan sistematik tasarım yaklaşımıdır.

Konuya yeni başlıyorsan normalizasyonu şöyle düşünebilirsin:
Dağınık bir dolabı düzenlemek gibi. Aynı eşya birden fazla yere konursa bulmak zorlaşır, birini düzeltince diğerini unutursun.
Veritabanı da benzer şekilde, düzenli olmadığında zamanla hata üretmeye başlar.

## Normalizasyon neden gerekli?

Normalizasyon (normalization), tablo tasarımını belirli kurallara göre düzenleyerek veri tekrarını azaltma ve veri bütünlüğünü artırma sürecidir.
Buradaki veri bütünlüğü, "sistemdeki bilginin birbiriyle çelişmemesi" anlamına gelir.

Normalizasyon yapılmadığında tipik problemler:

- **tekrarlı veri:** aynı bilgi birden fazla satırda tutulur
- **güncelleme anomalisi:** bir bilgi bir yerde güncellenir, diğer yerde unutulur
- **ekleme anomalisi:** bağımlı bir bilgi olmadan veri eklenemez
- **silme anomalisi:** bir kayıt silindiğinde farklı ve gerekli bir bilgi de kaybolur

Bu problemler sadece depolama maliyeti değil, raporlama ve operasyon kararlarında da hataya neden olur.

## Normal Formlar : 1NF, 2NF, 3NF

Normal form, bir tablo tasarımının belirli kalite kurallarını ne kadar sağladığını gösteren seviyedir.
Bu makalede kullandığımız üç temel seviye şunlardır:

- `1NF`: Hücrelerde tek değer kuralını sağlar.
- `2NF`: Kısmi bağımlılıkları temizler.
- `3NF`: Geçişli bağımlılıkları temizler.

Kısaca:
Her adım bir öncekinin üzerine eklenir ve tabloyu daha tutarlı hale getirir.

### 1NF (Birinci Normal Form)

`1NF`, "bir hücrede tek bilgi" ilkesidir.
Buradaki **atomik değer**, bir hücreye yazılan bilginin daha fazla parçaya bölünmeden tek bir anlam ifade etmesi demektir.

Basit anlatımla:

- doğru: `product_name = Latte`
- problemli: `products = Latte, Cheesecake, Filtre Kahve`

Neden problemli?

- Belirli bir ürünü filtrelemek zorlaşır (`Defter` geçen satırları bulmak için metin parçala gerekir).
- Sayma ve toplama işlemleri güvenilmez hale gelir (kaç ürün satıldı sorusu net cevaplanamaz).
- Veri düzenleme hataya açık olur (listedeki bir ürünü silerken diğerlerini bozma riski vardır).

Kısa bir "yanlış -> doğru" örneği:

```text
YANLIŞ (1NF değil):
ORDERS( order_no, customer_name, products )
1001, "Ayşe", "Latte, Cheesecake, Filtre Kahve"

DOĞRUYA YAKLAŞIM (1NF):
ORDER_ITEM( order_no, customer_name, product_name )
1001, "Ayşe", "Latte"
1001, "Ayşe", "Cheesecake"
1001, "Ayşe", "Filtre Kahve"
```

Görüldüğü gibi, her satır tek ürün kalemini temsil ettiğinde tablo `1NF` mantığına yaklaşır.

### 2NF (İkinci Normal Form)

`2NF`, `1NF` sağlandıktan sonra değerlendirilir.
Bu adımda ana soru şudur:
"Bu kolon, satırı benzersiz yapan anahtarın tamamına mı bağlı, yoksa sadece bir parçasına mı?"

Özellikle birleşik anahtarlı tablolarda:

- anahtar olmayan kolonlar, birleşik anahtarın sadece bir parçasına değil, tamamına bağımlı olmalı

Bu kurala uymayan durum, **kısmi bağımlılık** (partial dependency) olarak adlandırılır.

Sade örnek:

```text
ORDER_ITEM(
  order_no,
  product_id,
  customer_name,
  product_name,
  quantity
)
```

Bu tabloda olası anahtar `(order_no, product_id)` ise:

- `customer_name` sadece `order_no` ile ilgilidir
- `product_name` sadece `product_id` ile ilgilidir

Yani bu iki kolon anahtarın tamamına değil, bir parçasına bağlıdır.
Sonuç: tablo `2NF` değildir.

Nasıl düzeltiriz?

- siparişle ilgili kolonları `ORDERS` tablosuna
- ürünle ilgili kolonları `PRODUCT` tablosuna
- `quantity` gibi "ikisinin ilişkisini" anlatan kolonları `ORDER_ITEM` tablosuna taşırız.

### 3NF (Üçüncü Normal Form)

`3NF`, `2NF` üstüne kurulur.
Bu adımda kontrol ettiğimiz şey, tabloda "aracı kolonlar üzerinden bağımlılık" olup olmadığıdır:

- anahtar olmayan bir kolon, başka bir anahtar olmayan kolona bağımlı olmamalı

Bu kurala aykırı durum, **geçişli bağımlılık** (transitive dependency) olarak adlandırılır.

Basit örnek:

```text
ORDERS(
  order_no,
  customer_id,
  staff_id,
  staff_name
)
```

Burada `staff_name`, doğrudan `order_no`'ya değil, önce `staff_id`'ye bağlıdır.
Yani anahtar olmayan bir kolon (`staff_name`), başka anahtar olmayan bir kolona (`staff_id`) bağlıdır.
Bu nedenle tablo `3NF` değildir.

Düzeltme:

- `STAFF(staff_id, staff_name)`
- `ORDERS(order_no, customer_id, staff_id)`

## Tek tablo üzerinden adım adım dönüşüm

Aşağıdaki tasarım kasıtlı olarak problemlidir:

```text
CAFE_ORDER_DRAFT(
  order_no,
  order_date,
  customer_id,
  customer_name,
  customer_city,
  product_id,
  product_name,
  unit_price,
  quantity,
  staff_id,
  staff_name
)
```

Bu yapıda:

- müşteri bilgisi her satırda tekrar eder
- ürün bilgisi her satırda tekrar eder
- satış temsilcisi bilgisi satır satır yinelenir

### Adım 1: 1NF

İlk adımda, tabloyu "her satır tek olayı anlatsın" prensibiyle sadeleştiririz.
Kafe siparişi örneğinde bu olay, tek bir ürün kalemidir.

Bu nedenle:

- bir satırda birden fazla ürün tutmayız
- `products` gibi liste kolonlarını satırlara böleriz
- her hücreye tek değer yazarız

Bu adımdan sonra sorgular daha tahmin edilebilir hale gelir.
Örneğin "bu üründen kaç tane satıldı?" sorusu, metin parçala yerine doğrudan `SUM(quantity)` ile cevaplanabilir.

Bu adımdan sonra tablo hâlâ tekrarlı veri üretebilir; ancak artık `1NF` uyumludur.

### Adım 2: 2NF

Sipariş kalemi seviyesinde doğal anahtar çoğu zaman şu olur:
`(order_no, product_id)`.

Bu durumda:

- `customer_name`, `customer_city`, `order_date` yalnızca `order_no`'ya bağlıdır
- `product_name`, `unit_price` yalnızca `product_id`'ye bağlıdır

Yani kısmi bağımlılık vardır.
Bu durumu yeni başlayan biri için şu şekilde okuyabilirsin:
"Müşteri bilgisi ürüne bağlı değil; ürün bilgisi de siparişe bağlı değil."
Bu nedenle hepsini tek tabloda tutmak doğal değildir.

Bunu çözmek için tabloyu ayırırız:

- `ORDERS(order_no, order_date, customer_id, staff_id)`
- `ORDER_ITEM(order_no, product_id, quantity)`
- `CUSTOMER(customer_id, customer_name, customer_city)`
- `PRODUCT(product_id, product_name, unit_price)`

### Adım 3: 3NF

Şimdi geçişli bağımlılıkları kontrol ederiz.
Örneğin `ORDERS` tablosunda şu kolonlar olsun:

`staff_id, staff_name`

Burada `staff_name`, anahtar olmayan `staff_id`'ye bağlıdır.
Bu nedenle ayırmak gerekir:

- `STAFF(staff_id, staff_name)`
- `ORDERS(..., staff_id)` (yalnızca FK tutulur)

Bu adımla birlikte tasarım `3NF` seviyesine gelir.

Bu noktadaki pratik kazanc şu olur:

- temsilci adı değişirse tek yerden güncellersin
- typo ve tutarsız yazım riski azalır
- raporlarda aynı temsilci farklı adlarla görünmez

## Nerede zorlanılır, nasıl kolaylaştırılır?

Yeni başlayanlar genelde şu iki noktada zorlanır:

1. "Bu kolon nereye ait?" sorusu
2. "Bu tabloyu fazla mı bölüyorum?" endişesi

Pratik bir karar yöntemi:

- Bir kolonun anlamı hangi varlığa aitse, o varlığın tablosuna koy.
- Aynı bilgi birden fazla satırda tekrar ediyorsa ayırmayı düşün.
- Bir bilgiyi güncellediğinde birden fazla satıra dokunman gerekiyorsa tasarım tekrar gözden geçirilmeli.

## Pratikte normalizasyon kontrol listesi

Gerçek projelerde normalizasyon uygularken şu sırayla ilerlemek iş görmektedir:

1. ilk taslak tabloda tekrar eden alanları işaretle
2. olası anahtarı belirle (tekil veya birleşik)
3. `1NF` için hücrelerde liste/değer karmaşası var mı kontrol et
4. kısmi bağımlılıkları ayırarak `2NF`'e geç
5. geçişli bağımlılıkları ayırarak `3NF`'e geç
6. son tablolar arasındaki PK/FK ilişkilerini doğrula

Bu kontrol listesi, hem tasarım kararlarını daha şeffaf hâle getirir hem de ileride veri tutarsızlığı riskini azaltır.

## Sonuç

Normalizasyon, sadece "tablo bölme" tekniği değildir.
Asıl hedef; verinin mantığını netleştirmek, tekrarlı veriyi azaltmak ve sistem büyüdükçe bakımı kolaylaştırmaktır.

Doğru uygulanan `1NF`, `2NF`, `3NF` adımları, SQL performansı ve veri güvenilirliği için sağlam bir temel oluşturur.
