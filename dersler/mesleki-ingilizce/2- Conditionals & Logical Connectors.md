# Mesleki İngilizcede Şart Yapıları ve Mantıksal Bağlaçlar (Conditionals & Logical Connectors)

Yazılım geliştirme, kontrol sistemleri ve robotik algoritmalarında karar mekanizmaları doğrudan şart yapılarına dayanır. Bir mikrodenetleyicinin sensörden aldığı veriye göre motora güç vermesi veya bir yapay zekâ modelinin belirli bir olasılık eşiğini geçtiğinde nesneyi sınıflandırması, algoritmik düzeyde `if / else` bloklarıyla ifade edilir.

Teknik dokümanlarda, şartnamelerde ve sistem kılavuzlarında bu algoritmik mantığı eksiksiz aktarmak için İngilizce şart cümlecikleri (*Conditionals*) ve mantıksal bağlaçlar (*Logical Connectors*) kullanılır. Bu makalede; teknik metinlerde kullanılan sıfırıncı ve birinci tip şart yapıları, karşılaştırma ifadelerinin İngilizce karşılıkları, mantıksal bağlaçlar ile hata yönetimi terminolojisi incelenmektedir.

---

## 1. Teknik Metinlerde Şart Cümleleri (Conditionals)

Genel İngilizcede varsayımlar veya hayali durumlar için çeşitli şart tipleri bulunurken, mesleki ve teknik metinlerde iki temel yapı öne çıkar: **Zero Conditional** (Değişmez Sistem Kuralları) ve **First Conditional** (Geleceğe Yönelik Koşullu Durumlar).

### 1.1. Zero Conditional (Değişmez Kurallar ve Donanım Tepkileri)

Sistem mimarisinde fiziksel yasalar, donanım kuralları veya anlık geri besleme mekanizmaları anlatılırken her iki cümlecikte de Geniş Zaman (*Simple Present Tense*) kullanılır.

* **Formül 1 (Şart Cümlesi Başta):**
`If + Şart Cümlesi (Geniş Zaman), + Ana Eylem / Sonuç (Geniş Zaman)`
* **Formül 2 (Şart Cümlesi Sonda):**
`Ana Eylem / Sonuç (Geniş Zaman) + if + Şart Cümlesi (Geniş Zaman)`

*Noktalama Kuralı:* Şart ifadesi (`If`) cümlenin başındaysa iki cümlecik arasına virgül konur. Şart ifadesi cümlenin ortasındaysa virgül kullanılmaz.

* **Örnek Cümle Analizi:**
* *İngilizce:* *If the distance is less than 10 cm, the robot stops the motors.*
* *Bileşen Ayrımı:*
* `Şart Bağlacı`: **If** *(Eğer)*
* `Koşul Cümlesi`: **the distance is less than 10 cm** *(mesafe 10 cm'den küçükse)*
* `Noktalama`: **, (virgül)**
* `Ana Cümle / Sonuç`: **the robot stops the motors** *(robot motorları durdurur)*


* *Ters Dizilim:* *The robot stops the motors if the distance is less than 10 cm.*
* *Türkçe Çeviri:* Mesafe 10 cm'den küçükse, robot motorları durdurur.



### 1.2. First Conditional (Olası Durumlar ve Sistem Müdahaleleri)

Gelecekte gerçekleşmesi muhtemel bir parametre değişiminde sistemin alacağı aksiyonu veya bir koruma moduna geçeceğini bildirmek için `will` veya zorunluluk bildiren kipler (`must, should`) kullanılır:

* **Formül:**
`If + Şart Cümlesi (Geniş Zaman), + Subject + will / must + Fiil (Yalın)`
* **Örnek Cümle:**
*If the core temperature exceeds 85°C, the controller will shut down the system.*
*(Eğer çekirdek sıcaklığı 85°C'yi aşarsa, denetleyici sistemi kapatacaktır.)*

### 1.3. "Unless", "When" ve "Otherwise" Yapıları

Teknik şartnamelerde yalnızca `if` yeterli değildir; mantıksal terslemeler ve zaman tetikleyicileri için farklı bağlaçlar kullanılır:

* **Unless (`if not` / ...olmadıkça / ...olmazsa):**
Bir koşul sağlanmadığı sürece durumun devam ettiğini veya bir eylemin yapılmayacağını bildirir.
* *Formül:* `Unless + Olumlu Cümle, + Ana Cümle`
* *Örnek:* *Unless the user presses the start button, the motor does not run.*
* *Türkçe:* Kullanıcı başlatma butonuna basmadıkça motor çalışmaz.


* **When (...olduğunda / anında):**
Kesin bir olayın veya kesme (*interrupt*) sinyalinin gerçekleşme anını belirtir.
* *Örnek:* *When the buffer receives a new frame, the processor triggers the filter.*
* *Türkçe:* Arabellek yeni bir kare aldığında, işlemci filtreyi tetikler.


* **Otherwise (Aksi takdirde / `else` dengi):**
Önceki koşulun sağlanmadığı senaryoda devreye giren alternatif eylemi bağlar.
* *Örnek:* *The voltage must remain at 5V; otherwise, the sensor produces incorrect data.*
* *Türkçe:* Gerilim 5V seviyesinde kalmalıdır; aksi takdirde sensör hatalı veri üretir.



---

## 2. Mantıksal Karşılaştırmaların İngilizce Sözdizimi

Kod bloklarında sembollerle ifade edilen `<, >, ==, !=` işleçleri, teknik İngilizce metinlerde ve dokümantasyonlarda kelime öbekleriyle ifade edilir:

| Mantıksal İşleç | İngilizce Sözlü İfade | Örnek Cümle | Türkçe Anlamı |
| --- | --- | --- | --- |
| `==` | **is equal to** | The current value **is equal to** zero. | Mevcut değer sıfıra eşittir. |
| `!=` | **is not equal to** | The received ID **is not equal to** the target ID. | Alınan kimlik hedef kimliğe eşit değildir. |
| `>` | **is greater than / exceeds** | The pressure **is greater than** the safe limit. | Basınç güvenli sınırdan büyüktür (aşar). |
| `<` | **is less than / falls below** | The battery level **falls below** 20 percent. | Batarya seviyesi yüzde 20'nin altına düşer. |
| `>=` | **is greater than or equal to** | The voltage **is greater than or equal to** 3.3V. | Gerilim 3.3V'a eşit veya daha büyüktür. |
| `<=` | **is less than or equal to** | The error margin **is less than or equal to** 0.05. | Hata payı 0.05'e eşit veya daha küçüktür. |

### Çoklu Mantık Bağlaçları: AND, OR, NOT

Robotik algoritmalarında birden fazla koşulun aynı anda kontrol edildiği durumlarda mantık bağlaçları kullanılır:

* **AND (ve):** İki koşulun da aynı anda sağlanmasını zorunlu kılar.
*If the power switch is on **and** the connection is active, the transmission begins.*
*(Eğer güç anahtarı açıksa ve bağlantı aktifse iletim başlar.)*
* **OR (veya):** Koşullardan en az birinin sağlanması yeterlidir.
*If an obstacle is detected **or** the timeout expires, the routine stops.*
*(Eğer bir engel algılanırsa veya zaman aşımı dolarsa rutin durur.)*
* **NOT (değil / tersleme):** Koşulun olumsuz durumunu kontrol eder.
*If the device is **not** calibrated, the reading is invalid.*
*(Eğer cihaz kalibre edilmemişse okuma geçersizdir.)*

---

## 3. Karar ve Şart Mekanizmalarında Temel Fiil Bankası

Karar bloklarında, akış diyagramlarında (*flowcharts*) ve hata durumlarında en sık başvurulan 10 temel eylem:

| Fiil | Türkçe Anlamı | Teknik Kullanım Örneği | Türkçe Karşılığı |
| --- | --- | --- | --- |
| **exceed** | aşmak, üzerine çıkmak | The current **exceeds** the rated capacity. | Akım anma kapasitesini aşar. |
| **fall below** | altına düşmek | The supply voltage **falls below** the threshold. | Besleme gerilimi eşik değerin altına düşer. |
| **remain** | kalmak, sürdürmek | The signal **remains** stable for 10 milliseconds. | Sinyal 10 milisaniye boyunca kararlı kalır. |
| **terminate** | sonlandırmak | The system **terminates** the execution loop. | Sistem yürütme döngüsünü sonlandırır. |
| **halt** | durdurmak (aniden/acil) | The controller **halts** all moving parts. | Denetleyici tüm hareketli parçaları durdurur. |
| **reset** | sıfırlamak, başa almak | The watchdog timer **resets** the board. | İzleme zamanlayıcısı kartı sıfırlar. |
| **trigger** | tetiklemek | A falling edge **triggers** the counter. | Düşen kenar sayıcıyı tetikler. |
| **indicate** | belirtmek, göstermek | The red LED **indicates** a communication failure. | Kırmızı LED haberleşme arızasını gösterir. |
| **ignore** | yok saymak, yoksaymak | The algorithm **ignores** noisy sensor values. | Algoritma gürültülü sensör değerlerini yok sayar. |
| **prevent** | engellemek, önlemek | The safety limit switch **prevents** mechanical damage. | Güvenlik sınır anahtarı mekanik hasarı önler. |

---

## 4. Uygulama ve Metin Analizi (Case Studies)

### 4.1. Algoritmik Kod Yorumu ve Pseudocode Analizi

Otonom bir robotun karar mekanizmasını anlatan Python kod bloğu ve içindeki İngilizce şart açıklamaları:

```python
# If the confidence score is greater than 0.85, the model detects a target.
# Unless the path is clear, the navigation controller halts movement.
# Otherwise, the system updates motor coordinates.
def process_navigation(confidence: float, path_clear: bool) -> None:
    if confidence > 0.85 and path_clear:
        update_coordinates()
    else:
        halt_motors()

```

* **1. Satır Analizi:** `# If the confidence score is greater than 0.85, the model detects a target.`
* *Şart Yapısı:* `If` ile başlayan Zero Conditional yapısı.
* *İşleç:* `is greater than` (`>` işlecinin sözlü hali).
* *Özne/Fiil Uyumu:* `the model` (tekil özne) $\rightarrow$ `detects` (fiil `-s` takısı almıştır).
* *Türkçe Anlamı:* Eğer güven skoru 0.85'ten büyükse, model bir hedef tespit eder.


* **2. Satır Analizi:** `# Unless the path is clear, the navigation controller halts movement.`
* *Şart Yapısı:* `Unless` (`if not` / yol açık olmadıkça).
* *Özne/Fiil Uyumu:* `the navigation controller` (tekil özne) $\rightarrow$ `halts` (fiil `-s` takısı almıştır).
* *Türkçe Anlamı:* Yol açık olmadıkça, navigasyon denetleyicisi hareketi durdurur.


* **3. Satır Analizi:** `# Otherwise, the system updates motor coordinates.`
* *Şart Yapısı:* `Otherwise` (Aksi takdirde / diğer tüm durumlarda).
* *Özne/Fiil Uyumu:* `the system` (tekil özne) $\rightarrow$ `updates` (fiil `-s` takısı almıştır).
* *Türkçe Anlamı:* Aksi takdirde sistem motor koordinatlarını günceller.



### 4.2. Donanım Güvenlik Şartnamesi (Safety Specification) Analizi

Endüstriyel bir motor sürücüsü kılavuzundan uyarlanmış teknik güvenlik uyarıları metni:

> "The module operates continuously when the ambient temperature is between 0°C and 50°C. If the load current exceeds 2.0A, the driver enters protection mode. Do not disconnect the power lines while the output stage is active; otherwise, transient voltages will permanently damage the semiconductor gates."

* **Cümle 1:** *"The module operates continuously when the ambient temperature is between 0°C and 50°C."*
* *Gramer Yapısı:* `Ana Cümle + when + Zaman/Koşul Cümlesi`
* *Ayrıştırma:* `when` tetikleyici/zaman bağlacı olarak kullanılmıştır. Şart sağlandığı süre boyunca modülün sürekli çalışacağı (`operates`) belirtilir.
* *Türkçe Çeviri:* Ortam sıcaklığı 0°C ile 50°C arasında olduğunda modül sürekli olarak çalışır.


* **Cümle 2:** *"If the load current exceeds 2.0A, the driver enters protection mode."*
* *Gramer Yapısı:* `If + Tekil Özne + Fiil-s (exceeds), + Tekil Özne + Fiil-s (enters)`
* *Ayrıştırma:* Zero Conditional kuralıdır. Akımın 2.0A değerini aşması durumunda sürücünün otomatik koruma moduna geçeceği kural olarak tanımlanmıştır.
* *Türkçe Çeviri:* Yük akımı 2.0A değerini aşarsa, sürücü koruma moduna girer.


* **Cümle 3:** *"Do not disconnect the power lines while the output stage is active; otherwise, transient voltages will permanently damage the semiconductor gates."*
* *Gramer Yapısı:* `Emir Kipi (Olumsuz) + while + Durum Cümlesi; + otherwise, + Gelecek Zaman (will)`
* *Ayrıştırma:* `while` sürecin devamını (*çıkış katı aktifken*) belirtir. `otherwise` noktalı virgülden sonra alternatif tehlikeli senaryoyu bağlar ve geleceğe dönük kesin hasarı `will damage` ile ifade eder.
* *Türkçe Çeviri:* Çıkış katı aktifken güç hatlarının bağlantısını kesmeyiniz; aksi takdirde geçici gerilimler yarı iletken kapılara kalıcı olarak hasar verecektir.



---

## 5. Uygulama Alıştırmaları (Exercises)

### S1: Boşluk Doldurma (Conditionals & Verbs)

Aşağıdaki cümlelerde parantez içinde verilen fiil ve bağlaçları teknik şart kurallarına göre doğru biçimde yazınız:

1. If the camera resolution ____________ *(be)* low, the algorithm cannot detect facial features accurately.
2. The emergency relay trips if the circuit current ____________ *(exceed)* 10 amperes.
3. Unless the operator ____________ *(reset)* the alarm flag, the conveyor belt does not restart.
4. When the ultrasonic sensor ____________ *(detect)* an object, the LED turns red.
5. The system must maintain stable pressure; otherwise, the pneumatic valve ____________ *(not / close)* properly.

### S2: Cümle Sıralama (Syntax Egzersizi)

Karışık sırada verilen kelimeleri kurallı bir teknik İngilizce şart cümlesi haline getiriniz:

1. `[the controller]` / `[stops]` / `[the motor]` / `[if]` / `[the temperature]` / `[exceeds 70°C]`
2. `[unless]` / `[the data is valid,]` / `[the algorithm]` / `[discards]` / `[the packet]`
3. `[the red light]` / `[turns on]` / `[when]` / `[the sensor]` / `[is]` / `[disconnected]`

### S3: Türkçeden İngilizceye Teknik Çeviri

Aşağıdaki mühendislik karar ifadelerini `if`, `unless` veya `otherwise` kullanarak İngilizceye çeviriniz:

1. Eğer mesafe 15 santimetreden küçükse, sistem motorları durdurur.
2. Butona basılmadıkça robot hareket etmez. *(hareket etmek: move, basılmak: be pressed)*
3. Gerilim 3.3V seviyesinde kalmalıdır; aksi takdirde mikrodenetleyici sıfırlanır (resetlenir). *(kalmak: remain, sıfırlanmak: reset)*

