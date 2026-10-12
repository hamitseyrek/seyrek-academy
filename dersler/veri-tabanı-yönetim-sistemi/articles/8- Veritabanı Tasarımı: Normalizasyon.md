# Veritabanı Tasarımı: Normalizasyon

Normalizasyonu en sade haliyle şöyle anlatmak mümkündür:
Veritabanında aynı bilgiyi farklı yerlere yazmamak ve bir bilgiyi güncellemek için tek bir doğru noktaya sahip olmak.

Bu yaklaşım olmazsa sistem ilk gün çalışsa bile zamanla tutarsızlık üretir.
Aynı müşteri adı bir yerde "Ayşe Kaya", başka yerde "Ayse Kaya" olur; raporlar bölünür, kararlar hatalı çıkar.

## Normalizasyonu sade bir çerçeveyle düşünmek

Normalizasyonu üç cümlede özetleyelim:

1. Her hücre tek bir bilgi taşımalı.
2. Her bilgi ait olduğu tabloya yazılmalı.
3. Bir bilgi değiştiğinde tek yer güncellenmeli.

Bu üç cümle aslında `1NF`, `2NF` ve `3NF` kurallarının pratik karşılığıdır.

## Tek örnekle adım adım: 1NF, 2NF, 3NF

Tek bir problemli tabloyla başlayalım:

```text
SALES_DRAFT(
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

Bundan sonraki tüm problemler ve dönüşüm adımları bu tablo üzerinden ilerleyecek.

## Normalizasyon yapılmazsa ne olur?

Normalizasyonun değerini görmek için önce problemi net görmek gerekir.
Kötü tasarımda şu dört sorun ortaya çıkar:

- **Tekrarlı veri:** Aynı bilgi çok satıra yazılır.  
  Örnek: `SALES_DRAFT` tablosunda `customer_id = 101` olan müşteri 3 farklı sipariş verirse, her satırda tekrar `customer_name = "Ayşe Kaya"` ve `customer_city = "İstanbul"` tutulur.
- **Güncelleme anomalisi:** Bir yerde güncellenen bilgi diğer satırlarda eski kalır.  
  Örnek: `customer_id = 101` için ad bilgisi "Ayşe Demir" olarak güncellenirken 3 sipariş satırının yalnızca 2'si güncellenirse, tabloda hem `"Ayşe Kaya"` hem `"Ayşe Demir"` birlikte kalır.
- **Ekleme anomalisi:** Asıl kayıt olmadan bağlı bilgi eklenemez.  
  Örnek: Yeni ürün (`product_id = 900`, `product_name = "Mocha"`, `unit_price = 120`) tanımlanmak istenir; ancak `SALES_DRAFT` satırı aynı anda `order_no` da beklediği için sipariş olmadan ürün kaydı açılamaz.
- **Silme anomalisi:** Bir satır silinince başka kritik bilgi de kaybolur.  
  Örnek: `staff_id = 12` için tabloda tek satır varsa ve o sipariş satırı silinirse, `staff_name` bilgisi de tamamen kaybolur.

Bu sorunlar sadece depolama maliyeti değildir; doğrudan veri güvenilirliği problemidir.

### 1NF: Bir hücrede tek değer

`1NF` (First Normal Form), evet, pratikte "her hücrede tek değer" kuralıdır.
Buradaki kritik nokta şudur: Bir hücre liste, dizi veya virgülle birleştirilmiş çoklu değer taşımamalıdır.
Yani bir hücrede tek bir ürün, tek bir şehir, tek bir tarih gibi tek anlamlı veri bulunur.
`SALES_DRAFT` örneği bu kuralı büyük ölçüde sağladığı için, 1NF ihlalini ayrı kısa bir tabloyla göstermek daha nettir.

Örnek:

- Doğru: `product_name = Latte`
- Hatalı: `products = Latte, Cheesecake, Tea`

Hatalı kullanımda filtreleme, sayma ve güncelleme zorlaşır.
Bu nedenle siparişte birden fazla ürün varsa, ürünler aynı hücreye yazılmaz; her ürün ayrı satıra taşınır.

Kısa dönüşüm:

```text
YANLIŞ:
ORDERS(order_no, customer_name, products)
1001, "Ayşe", "Latte, Cheesecake"

DOĞRUYA YAKLAŞIM:
ORDER_ITEM(order_no, customer_name, product_name)
1001, "Ayşe", "Latte"
1001, "Ayşe", "Cheesecake"
```

### 2NF: Kolon, anahtarın tamamına bağlı olmalı

`2NF` (Second Normal Form), önce `1NF` sağlandıktan sonra kontrol edilir.
Kritik soru şudur: "Anahtar olmayan kolon, birleşik anahtarın tamamına mı bağlı?"

Sipariş kalemi için tipik anahtar `(order_no, product_id)` olur.
Bu durumda:

- `customer_name` yalnızca `order_no` ile ilgilidir.
- `product_name` yalnızca `product_id` ile ilgilidir.

Bu durum **kısmi bağımlılık** (partial dependency) üretir ve tablo `2NF` değildir.

Çözüm:

- Siparişe ait alanlar: `ORDERS`
- Ürüne ait alanlar: `PRODUCT`
- Sipariş-ürün ilişkisi: `ORDER_ITEM`

Yani tabloyu "bilginin sahibi kim?" sorusuna göre ayırırız.

### 3NF: Anahtar olmayan kolon, başka anahtar olmayan kolona bağlı olmamalı

`3NF` (Third Normal Form), geçişli bağımlılığı temizler.
Geçişli bağımlılık (transitive dependency), bir alanın anahtara değil aradaki başka bir alana bağlı olmasıdır.

Örnek:

```text
ORDERS(order_no, customer_id, staff_id, staff_name)
```

Burada `staff_name`, doğrudan `order_no` ile değil `staff_id` ile ilişkilidir.
Yani `staff_name` bu tabloda tutulmamalıdır.

Doğru ayrım:

- `STAFF(staff_id, staff_name)`
- `ORDERS(order_no, customer_id, staff_id)`

Böylece personel adı değiştiğinde tek tablo güncellenir.

## Son tasarım nasıl görünür?

`1NF`, `2NF`, `3NF` sonrası pratik yapı şu şekildedir:

```text
CUSTOMER(customer_id, customer_name, customer_city)
PRODUCT(product_id, product_name, unit_price)
STAFF(staff_id, staff_name)
ORDERS(order_no, order_date, customer_id, staff_id)
ORDER_ITEM(order_no, product_id, quantity)
```

Bu yapıda her tablonun sorumluluğu nettir:

- Müşteri bilgisi sadece `CUSTOMER` içinde yaşar.
- Ürün bilgisi sadece `PRODUCT` içinde yaşar.
- Personel bilgisi sadece `STAFF` içinde yaşar.
- Sipariş kalemi ilişkisi `ORDER_ITEM` ile yönetilir.

## Sonuç

Normalizasyon, tablo sayısını artırmak için değil, veri doğruluğunu korumak için uygulanır.
Özellikle `1NF`, `2NF`, `3NF` adımlarını "tek değer, doğru sahiplik, tek güncelleme noktası" olarak düşünmek, konuyu hem öğrenmeyi hem uygulamayı belirgin biçimde kolaylaştırır.
