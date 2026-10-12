# Proje Yönetimi ve Uygulama: Robotikte Plan, Entegrasyon ve Teslim

Bir robotik projede kontrol döngüsü stabil, sensör verisi temiz ve gömülü yazılım derlenebilir durumda olabilir; buna rağmen teslim tarihi uzayabilir, entegrasyon haftalarca sürerebilir ve saha testinde sistem beklenmedik şekilde davranabilir. Bu tablo çoğu zaman “kötü kod”dan değil, **paralel disiplinlerin** (mekanik, elektronik, yazılım, test) aynı takvimde senkronize edilmemesinden çıkar.

Robotikte başarı yalnızca algoritma veya PCB tasarımıyla ölçülmez. Donanım tedariki, erken entegrasyon ritmi ve kabul ölçütleri birlikte yönetilmediğinde aynı teknik kalite farklı sonuç üretir. **Proje yönetimi** bu bağlamda bürokrasi değil; gereksinimin ölçülebilir olması ve teslimin sürdürülebilir kalması için kullanılan mühendislik disiplinidir.

Bu yazıda robotik projelerde uygulanabilir bir yaşam döngüsü, gereksinim yazımı, erken entegrasyon, test katmanları, kapsam kontrolü ve ekip ritmi ele alınır.

## 1. Proje yönetimi ne işe yarar?

Proje yönetimi, ekip için üç soruya sürekli net cevap üretmeyi hedefler:


| Soru                | Robotikte neden kritik?                                                    |
| ------------------- | -------------------------------------------------------------------------- |
| Ne yapılacak?       | Belirsiz gereksinim, belirsiz test ve geç teslim üretir                    |
| Ne zaman yapılacak? | Mekanik gecikme, yazılım doğrulamasını ve saha testini zincirle etkiler    |
| Kim yapacak?        | Aynı modüle iki ekip dokunursa entegrasyon ve hata ayıklama maliyeti artar |


Çizgi izleyen küçük bir mobil robot için dört haftalık bir teslim planı kurulduğunda, mekanik ekibin şasi ve tekerlek montajının bir hafta geride kalması yalnızca “mekanik gecikti” anlamına gelmez. Elektronik taraf motor sürücüsünü ve sensör kablolarını sabitleyecek gövdeyi bulamaz; yazılım tarafı kontrol kodunu simülasyonda veya breadboard üzerinde doğrular, fakat robotun zeminde güvenle durup durmadığı sahada ölçülemez. Pist testi ertelenir. Teslim haftasında alt sistemler ayrı ayrı sağlam görünse bile ilk entegrasyonda motor ters polaritede bağlanmış çıkabilir, sensör yüksekliği çizgiyi hiç okumayabilir — kalan süre bu sürprizleri sindirmeye yetmez.

Buradaki kırılma çoğu zaman kötü algoritmadan değil, **disiplinler arası takvimin kopmasından** kaynaklanır. Tek bir gecikme zinciri etkiler; planın haftalık ve güncel tutulması, “modül hazır” ile “sistem entegre ve test edilebilir” ayrımının görünür kalması gerekir.

Kötü yönetilen projelerde sık görülen belirtiler şunlardır: takvimin sürekli kayması, “büyük birleştirme” haftasının yığılması, testlerin son faza kalması, teslim sonrası bakım için yeterli dokümantasyonun olmaması. Bu belirtiler teknik yetersizlikten bağımsız olarak da ortaya çıkabilir.

## 2. Basit yaşam döngüsü

Çoğu akademik veya endüstriyel robotik proje için altı adımlık bir döngü yeterlidir. Adımlar sıralı ilerler; gerektiğinde kontrollü geri dönüş (örneğin saha testinden gereksinime) yapılır.

```mermaid
flowchart LR
  A[Gereksinim] --> B[Mimari]
  B --> C[Geliştirme]
  C --> D[Erken entegrasyon]
  D --> E[Test ve düzeltme]
  E --> F[Teslim ve dokümantasyon]
  E -.->|geri bildirim| A
```



*Şekil 1: Robotik projede tipik yaşam döngüsü; test aşamasından gereksinime kontrollü geri dönüş mümkündür.*


| Adım                 | Odak                 | Çıktı örneği                 |
| -------------------- | -------------------- | ---------------------------- |
| 1. Gereksinim        | Ölçülebilir hedef    | Kabul ölçütü listesi         |
| 2. Mimari            | Modül sınırları      | Arayüz tanımı, blok diyagram |
| 3. Geliştirme        | Paralel ilerleme     | Modül prototipleri           |
| 4. Erken entegrasyon | Küçük birleştirmeler | Haftalık çalışan alt sistem  |
| 5. Test ve düzeltme  | Katmanlı doğrulama   | Test raporu, hata listesi    |
| 6. Teslim            | Sürdürülebilirlik    | Mimari özet, bakım notları   |


Aşağıdaki bölümlerde her adım robotik bağlamında açılır.

## 3. Gereksinim yazımı

**Gereksinim**, sistemin ne yapması gerektiğini ve “başarılı” sayılması için hangi ölçütlerin sağlanması gerektiğini tanımlayan ifadeler bütünüdür. Belirsiz gereksinim, test üretilemeyen ve tartışmaya açık hedefler doğurur; bu da proje ortasında kapsam patlamasına yol açar.

Zayıf ve güçlü ifade karşılaştırması:


| Tür   | Örnek                                                                                  | Sorun / avantaj                                 |
| ----- | -------------------------------------------------------------------------------------- | ----------------------------------------------- |
| Zayıf | “Robot hızlı olsun.”                                                                   | Ölçülemez; test yazılamaz                       |
| Güçlü | “Robot 10 kg yük ile 1 m/s hıza ulaşsın; engel algılandığında 300 ms içinde duraksın.” | Sayısal; modül ve saha testine dönüştürülebilir |


Güçlü gereksinimde şu başlıklar net olmalıdır:

- **Fonksiyon:** Robot ne yapacak (taşıma, durma, loglama)?
- **Performans:** Hız, yük, gecikme, görev tamamlama oranı?
- **Emniyet:** Engel, acil durdurma, güvenli bekleme modu?
- **Çevresel koşullar:** Zemin, sıcaklık, aydınlatma, Wi-Fi kapsaması?
- **Kabul ölçütü:** Teslimde hangi testler geçilmiş sayılacak?

Gereksinim mümkün olduğunca proje başında yazılır; saha testinden gelen bulgularla güncellenir.

## 4. Erken entegrasyon

Sık yapılan hata, tüm alt sistemlerin ayrı ayrı “tam bitmiş” sayılması ve birleştirmenin proje sonuna bırakılmasıdır. Bu modelde ilk gerçek birleşmede haberleşme uyumsuzluğu, güç yetersizliği veya zamanlama hataları üst üste biner; debug süresi haftalara uzar.

Doğru yaklaşım: Parçaları **erken ve küçük adımlarla** birleştirmek — önce motor + sürücü, sonra sensör + okuma, ardından kontrol döngüsü, en son görev mantığı. Haftada en az bir entegrasyon denemesi (entegrasyon günü veya “demo cuma”) birçok ekipte sürdürülebilir ritim oluşturur.

Erken entegrasyon aynı zamanda gereksinimi doğrular: Kağıt üzerinde mümkün görünen hedef, birleşik sistemde ölçülebilir veya ölçülemez hale gelir.

## 5. Test yönetimi

**Test**, projenin son adımı değil; geliştirme boyunca süren doğrulama faaliyetidir. Robotikte test katmanları üst üste inşa edilir:


| Katman             | Ne doğrulanır?            | Örnek                             |
| ------------------ | ------------------------- | --------------------------------- |
| Modül testi        | Tek bileşen               | Sensör kalibrasyonu, motor yanıtı |
| Entegrasyon testi  | İki veya daha fazla modül | Lidar + duruş komutu              |
| Uçtan uca test     | Görev akışı               | Rota + yükleme + engel            |
| Gerçek ortam testi | Hedef sahada davranış     | Depo zemini, aydınlatma, Wi-Fi    |


Laboratuvarda stabil çalışan navigasyon, sahada farklı sürtünme veya parazit nedeniyle sapabilir. Gerçek ortam testi bu yüzden ayrı planlanır; kabul ölçütlerinin bir kısmı bilinçli olarak saha koşullarına bağlanır.

Test planı gereksinimle birlikte başlar: Her güçlü gereksinim maddesi en az bir test maddesine karşılık gelmelidir.

## 6. Teslim ve dokümantasyon

Teslim, “demo günü çalıştı” ile sınırlı değildir. Sistem teslim sonrası bakım, güncelleme ve hata analizi için anlaşılır olmalıdır. Minimum dokümantasyon seti:

- **Mimari özeti:** Katmanlar, veri akışı, yazılım sürümü
- **Bağlantı şeması:** Güç, haberleşme, sensör pinleri
- **Test çıktıları:** Geçen/kalan maddeler, ölçüm değerleri
- **Hata ve bakım notları:** Bilinen sınırlamalar, sık arızalar, kalibrasyon adımları

Dokümantasyon teslim haftasında sıfırdan yazılmaz; entegrasyon ve test sırasında güncellenir. Bu alışkanlık, üç ay sonra aynı projeye dönen ekip için kritik zaman kazandırır.

## 7. Kapsam kontrolü

“Bunu da ekleyelim” talepleri robotik projelerde olağandır: ek sensör, gelişmiş UI, tam otonom planlama. Kontrol edilmediğinde **kapsam genişlemesi** takvimi dağıtır ve ilk sürüm hiç çıkmaz.

Basit ve etkili yöntem:

1. Özellikleri önceliklendir (Must / Should / Could veya benzeri)
2. Kritik olmayanları açıkça “Faz 2” listesine al
3. Kapsam değişikliğini yazılı onayla (tek satırlık değişiklik kaydı bile yeterli)

Bu yaklaşım ilk teslimi gerçekçi tutar; ekip “eksik” hissetmek yerine “planlı erteleme” ile çalışır.

## 8. Ekip iletişimi

Teknik olarak güçlü bir ekip, zayıf iletişimle yine yavaşlar: Aynı kablo iki kez değiştirilir, test senaryosu paylaşılmaz, “bitmiş” ile “entegre edilebilir” karışır.

Sürdürülebilir ritim örneği:

- **Günlük kısa durum:** Engel, bugünkü hedef (15 dakikayı geçmemeli)
- **Haftalık teknik değerlendirme:** Entegrasyon sonucu, kapsam
- **Kritik olayda hızlı kanal:** Emniyet veya saha arızası için net muhatap

Toplantı sayısından önemli olan, **kararların yazılı ve tek anlamlı** kalmasıdır: “Yarın deneriz” yerine “Cuma 14:00 entegrasyon: lidar + duruş, sorumlu X”.

## 9. Sık yapılan üç hata


| Hata                              | Sonuç                                  | Alternatif                          |
| --------------------------------- | -------------------------------------- | ----------------------------------- |
| Tüm özellikleri ilk sürüme koymak | Hiç teslim etmemek veya kalitesiz demo | Çekirdek değer + Faz 2 listesi      |
| Testi en sona bırakmak            | Geç ve pahalı debug                    | Gereksinimle birlikte test planı    |
| Dokümantasyonu ertelemek          | Teslim sonrası bilgi kaybı             | Entegrasyon haftalarında güncelleme |


Doğru yaklaşım özeti: önce ölçülebilir çekirdek, paralel test, haftalık entegrasyon, dokümanın canlı tutulması.

## Sonuç

Robotik projede proje yönetimi, teknik çalışmanın rakibi değil tamamlayıcısıdır. Ölçülebilir gereksinim, erken entegrasyon, katmanlı test ve sürdürülebilir dokümantasyon bir araya geldiğinde zaman, maliyet ve belirsizlik daha öngörülebilir dengelenir.

Sade ve disiplinli bir akış — altı adımlı yaşam döngüsü, haftalık entegrasyon ritmi, yazılı kapsam sınırı — krizleri ortadan kaldırmaz; ancak kriz anında neyin değişeceğini ve kimin karar vereceğini netleştirir. Böylece teslim süreci hem ekip hem paydaşlar için daha güvenilir hale gelir.