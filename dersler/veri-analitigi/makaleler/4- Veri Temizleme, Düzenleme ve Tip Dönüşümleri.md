# Veri Temizleme, Düzenleme ve Tip Dönüşümleri: Ham Kayıttan Güvenilir Analize

Geçen hafta sensörlerden, API'lerden ve kullanıcı girdilerinden nasıl veri toplandığını; her kaydın kaynağı ve zaman damgasıyla birlikte korunması gerektiğini konuşmuştuk. Ancak veriyi veritabanına indirdiğimiz an analiz hemen başlamaz. Gerçek dünyada veri; ağ kesintileri, donanım arızaları ve yazılım güncellemeleriyle dolu kusurlu bir süreçten süzülerek gelir. Bir sensör ölçüm alanını boş bırakmış, bir cihaz sıcaklığı sayı yerine metin olarak göndermiş ya da tarih bilgisini bambaşka bir formatta yazmış olabilir. Bu pürüzleri fark etmeden doğrudan hesaplamalara geçersek, kuracağımız en gelişmiş modeller bile yanıltıcı sonuçlar üretecektir.

İşte bu yüzden veri temizleme, tabloları "göze hoş göstermek" için yapılan kozmetik bir rötuş değildir. Temizliğin asıl amacı; kayıtlardaki kusurları görünür kılmak, elimizdeki analiz sorusuna göre tutarlı kararlar almak ve bu kararları başkalarının da tekrar çalıştırabileceği (tekrar üretilebilir) bir yapıda kurgulamaktır. Gelin, önceki yazımızdaki IoT ve sensör senaryosunu devam ettirelim ve bir endüstriyel cihazın sıcaklık, nem ve titreşim ölçümleri üzerinden bu süreci adım adım inceleyelim.

---

## Temizliğe Başlamadan Önce: Veri Neyi Temsil Ediyor?

Veriye tek bir satır bile müdahale etmeden önce durup sormamız gereken ilk soru şudur: **Bu ölçüm gerçek dünyada neye karşılık geliyor?** Sütunların anlamını, birimini, hangi cihazdan geldiğini ve fiziksel olarak hangi sınırlar içinde kalması gerektiğini bilmeden temizlik yapılamaz. 

Örneğimizde `temperature_c` santigrat cinsinden sıcaklığı, `humidity_pct` yüzde bağıl nemi, `vibration_mm_s` ise milimetre/saniye (mm/s) cinsinden titreşim hızını temsil etsin. Cihazın teknik kılavuzunu açtığımızda, sensörün **-40 ile 85 °C** arasında çalıştığını ve bağıl nemi **%0 ile %100** aralığında ölçtüğünü görüyorsak, artık elimizde çok güçlü bir referans var demektir. Bu sınırlar, gelen bir verinin makul olup olmadığını tartacağımız ilk terazidir.

| Sütun Adı | Beklenen Veri Tipi | Örnek Kayıt | İlk Kontrol Sorusu |
| --- | --- | --- | --- |
| `recorded_at` | Saat dilimli tarih-saat | `2026-04-06T09:00:00+03:00` | Tarih olarak okunabiliyor mu, hangi saat dilimine ait olduğu belli mi? |
| `device_id` | Metin (Kategorik Kimlik) | `DEV-01` | Başta/sonda gereksiz boşluklar var mı, büyük/küçük harf kullanımı tutarlı mı? |
| `temperature_c` | Ondalıklı sayı (Float) | `22.4` | Sorunsuzca sayıya dönüşüyor mu ve cihazın teknik sınırları (-40 / 85 °C) içinde mi? |
| `humidity_pct` | Ondalıklı sayı (Float) | `45.0` | Değer 0 ile 100 arasında mı? |
| `vibration_mm_s` | Ondalıklı sayı (Float) | `1.2` | Fiziksel olarak imkânsız (negatif) bir değer var mı, ani bir sıçrama görülüyor mu? |

Veri mühendisliğinde bu tabloya **veri sözleşmesi (data contract)** veya **şema** adını veririz. İyi bir şema yalnızca sütun adlarını listelemez; verinin tipini, birimini, boş bırakılıp bırakılamayacağını ve kabul edilebilir sınırlarını da güvence altına alır. Örneğin tabloda `22.4` gibi gayet düzgün görünen bir sayıya rastlayabilirsiniz; ancak bu değerin Celsius mu yoksa Fahrenheit mı olduğunu bilmiyorsanız, o sayı tek başına hiçbir anlam ifade etmez. Birim bilgisi ya sütun adında (`temperature_c` gibi) ya da meta veride mutlaka veriyle birlikte taşınmalıdır.

---

## Eksik Değerler: Boş Hücre Tek Başına Açıklama Değildir

Beklenen bir ölçümün tabloda yer almamasına **eksik değer (missing value)** diyoruz. Ancak verinin "yokluğu" tabloya her zaman aynı şekilde yansımaz. Hücre tamamen boş bırakılmış olabilir; `NULL`, `NaN`, `N/A`, `-` veya `-999` gibi yer tutucu ifadelerle doldurulmuş olabilir; hatta cihaz o dakika hiç veri paketi göndermediği için satır komple eksik olabilir. 

Üstelik bu işaretlerin her biri sahada farklı bir duruma işaret edebilir: `N/A` "sensör o an ölçüm yapamadı" anlamına gelirken, boş hücre "veri iletimde kayboldu" demek olabilir. Bazı eski tip endüstriyel sensörler ise ölçüm alamadığında hata kodu olarak `-999` veya `9999` gönderir; eğer siz bunu gerçek bir sayı sanıp ortalamaya katarsanız tüm analizi baştan çökertirsiniz.

Örneğin her dakika veri gönderen bir sensörde saat `09:12` kaydının olmadığını düşünelim. Bu boşluk anlık bir Wi-Fi kopmasından mı kaynaklandı, yoksa makine aşırı ısınıp kapandığı için mi veri kesildi? İki farklı cihazın nem ölçümlerini karşılaştırırken boş satırları "nasıl olsa eksik" diyerek sessizce silmek, bağlantı sorunu yaşayan veya sık arızalanan cihazın analizde olduğundan çok daha sorunsuz görünmesine (**temsil yanlılığına**) yol açar.

Veri biliminde eksikliğin doğasını anlamak için üç temel senaryoyu göz önünde bulundururuz:

* **Tamamen Rastgele Eksiklik (MCAR):** Verinin kaybolması, ne ölçülen değerin kendisiyle ne de sistemdeki başka bir değişkenle ilişkilidir. Örneğin fabrikadaki ağ anahtarının (switch) anlık bir elektrik dalgalanmasıyla 10 saniyeliğine yeniden başlaması gibi.
* **Başka Bir Değişkene Bağlı Eksiklik (MAR):** Eksiklik, tablodaki başka bir özellikle doğrudan ilişkilidir. Örneğin yalnızca eski model (`DEV-01` serisi) cihazların kablosuz antenleri zayıf olduğu için verilerinin sık sık kopması veya sadece gece vardiyasında yapılan bakım saatlerinde veri gelmemesi.
* **Değerin Kendisine Bağlı Eksiklik (MNAR - En Tehlikelisi):** Eksiklik, bizzat ölçmeye çalıştığımız değerin büyüklüğünden kaynaklanır. Örneğin sıcaklık sensörünün 80 °C'nin üzerine çıktığında lehimlerinin genleşip temassızlık yapması ve tam da en kritik yüksek sıcaklıkları kaydedememesi. Böyle bir durumda "boşluklar rastgeledir" varsayımıyla hareket etmek, fabrikanın en büyük riskini gözden kaçırmak demektir.

Bu kategoriler teorik birer etiket gibi görünse de aslında veriye nasıl müdahale edeceğimizi belirleyen pusulalardır. Sütun bazında eksiklik oranlarını çıkardıktan ve mümkünse sistem log'larından kesintinin kök nedenini araştırdıktan sonra, analiz amacımıza en uygun stratejiyi seçeriz:

| Yaklaşım | Hangi Durumda Tercih Edilmeli? | Pratik Örnek ve Barındırdığı Risk |
| --- | --- | --- |
| **Olduğu gibi bırakıp ilgili analizden hariç tutma** | Eksik olan alan o analiz için hayati önem taşıyorsa ve dışarıdan tahmin edilerek doldurulması yanıltıcı olacaksa. | Zaman damgası (`recorded_at`) olmayan bir satır zaman serisi grafiğine giremez; ancak cihazın genel sıcaklık dağılımı incelenirken hâlâ kullanılabilir. |
| **Ortalama veya medyan ile doldurma (Imputation)** | Kayıp oranı çok düşükse, zaman boyutu kritik değilse ve değişkenin dağılımı buna uygunsa. | Sıcaklık için **medyan** kullanmak aşırı uç değerlerden etkilenmeyi önler. Ancak çok fazla boşluğu tek bir sabit sayıyla doldurmak, verideki doğal dalgalanmayı (varyansı) yapay biçimde düşürür. |
| **Zaman serisinde enterpolasyon veya öteleme (FFill)** | Aynı cihazın düzenli ölçümleri arasında çok kısa bir kopukluk varsa ve fiziksel sürecin ani değişmediği biliniyorsa. | `09:11`'de 22.0 °C, `09:13`'te 22.2 °C ölçülmüşse, aradaki `09:12` boşluğu doğrusal enterpolasyonla `22.1 °C` yapılabilir. Ancak 3 saatlik bir kesintiyi bu şekilde doldurmak, o sırada yaşanan gerçek bir soğuma/ısınma dalgasını gizler. |
| **Eksiklik bayrağı (Flag) ekleme** | Verinin eksik olmasının kendisi, sahadaki arıza veya süreç hakkında değerli bir ipucu taşıyorsa. | Boşluğu enterpolasyonla doldursanız bile yanına `temp_was_missing = True` şeklinde yeni bir sütun açarsınız. Böylece hem seriyi bozmazsınız hem de "burada bir kopukluk olmuştu" bilgisini korursunuz. |

Burada sık düşülen bir tuzağa dikkat çekelim: **Ortalama**, aşırı uç değerlerden çok çabuk etkilenir; **medyan** (ortanca değer) ise sıralı verinin tam ortasında durduğu için uç ölçümlere karşı çok daha dirençlidir. Ancak ikisi de her derde deva birer sihirli değnek değildir. Örneğin 10 farklı makineden gelen veri setinde, 3 numaralı makinenin boş sıcaklık değerlerini *tüm fabrikadaki makinelerin genel ortalamasıyla* doldurmak büyük bir hatadır; çünkü makineler arasındaki çalışma farklarını ve zaman içindeki ısınma eğilimini silip süpürür. Ayrıca gelecekteki verileri kullanarak geçmişteki bir boşluğu doldurmak (**veri sızıntısı / data leakage**), tahmin modellerinde gerçekte sahip olmadığınız bir bilgiyi kullanmanıza yol açar. Unutmayın, bazen veriyi hiç doldurmadan eksik bırakmak, yanlış bir varsayımla doldurmaktan çok daha dürüst ve doğru bir mühendislik kararıdır.

---

## Hatalı, Tutarsız ve Yinelenen (Mükerrer) Kayıtlar

Sahadan gelen verideki tek sorun boşluklar değildir. Karşımıza sıkça üç farklı kirlilik türü daha çıkar:

1. **Hatalı değer (Invalid data):** Bir alanın anlamına, doğasına veya veri tipine tamamen aykırı girdilerdir. Sıcaklık sütununda sayı yerine `"twenty-three"` veya `"HATA"` yazması, tarih alanında `"yarın sabah"` ifadesinin bulunması ya da cihaz kimliği sütununun yalnızca boşluk karakterlerinden (`"   "`) oluşması buna örnektir.
2. **Tutarsızlık (Inconsistency):** Aynı gerçeğin farklı biçimlerde yazılmasıdır. Örneğin tabloda geçen `dev-01`, `DEV-01` ve ` DEV-01 ` ifadeleri gerçekte aynı makineyi anlatır; ancak bilgisayar bunları üç ayrı cihaz olarak algılar. Kenardaki boşlukları kırpmak (`trim/strip`) ve tüm harfleri büyük harfe çevirmek bu karmaşayı anında çözer.
3. **Biçim ve ayraç karmaşası:** Sayısal bir sütunda `"twenty-three"` gibi bir metin gördüğümüzde bunu sessizce sıfıra çeviremeyiz; bu değeri `NULL` (geçersiz) olarak işaretleyip neden oluştuğunu araştırmamız gerekir. Öte yandan, Avrupa standardında çalışan bir sensörden `"22,4"` şeklinde virgüllü bir metin geliyorsa, buradaki virgülün ondalık ayracı olduğundan eminsek bunu `"22.4"` biçimine dönüştürebiliriz. Fakat kaynak sistemi tanımadan her virgülü noktaya çevirmek çok tehlikelidir: `"1,234"` ifadesi İngiliz/Amerikan sisteminde **bin iki yüz otuz dördü** temsil ederken, Türkiye ve Avrupa sistemlerinde **bir tam binde iki yüz otuz dördü** anlatır. Bağlamı bilmeden yapılan otomatik metin değiştirme işlemleri, doğru veriyi bir anda bozar.

**Yinelenen (mükerrer) kayıtlar** ise üzerinde ayrıca düşünülmesi gereken bir konudur. Aynı cihazdan (`DEV-01`), aynı saniye içinde (`09:00:00`) iki satır veri geldiğini varsayalım. Eğer bu iki satırın tüm sütunları birebir aynıysa, muhtemelen ağdaki bir gecikme yüzünden aynı veri paketi sunucuya iki kez yazılmıştır; bu durumda kopyalardan birini güvenle silebiliriz. 

Peki ya zaman damgası ve cihaz aynıyken, bir satırda sıcaklık `22.4 °C`, diğerinde `25.1 °C` yazıyorsa? İşte burada **"zaman damgası aynı olanları tekilleştir ve ilkini tut"** kuralı tehlikeli hale gelir. Belki de sensör saniyede iki ölçüm yapıyordur ama veritabanı milisaniyeleri yuvarladığı için ikisi de aynı saniyeye düşmüştür; ya da fabrikada gerçekten aynı `DEV-01` kimliğiyle yapılandırılmış iki ayrı cihaz vardır. Bu tür çelişkili tekrarlar ezbere silinmez, ayrı bir tabloya ayrılıp kaynak sistem yöneticisiyle birlikte incelenir.

---

## Aykırı Değer ve Anomali: Her Sıra Dışı Ölçüm Hata Değildir

Veri analizinde en sık karıştırılan kavramların başında **aykırı değer (outlier)**, **anomali** ve **kayıt hatası** gelir. Bu üçü birbiriyle kesişebilir ama kesinlikle eş anlamlı değildir:

* **Aykırı Değer (Outlier):** İstatistiksel bir kavramdır; bir gözlemin, veri dağılımının geri kalanından belirgin biçimde uzakta durmasını ifade eder.
* **Anomali:** Fiziksel veya iş süreçleri açısından beklenmedik, olağandışı bir davranışı veya örüntüyü anlatır.
* **Kayıt/Ölçüm Hatası (Noise/Error):** Sensör arızası, kablo kopukluğu veya yazılımsal bir hata nedeniyle gerçeği yansıtmayan geçersiz veridir.

Bir ölçüm istatistiksel olarak çok uçta görünebilir ama **tamamen gerçek bir olayı** temsil edebilir. Örneğin motor rulmanı dağılmak üzere olan bir makinenin titreşim değerinin aniden fırlaması istatistiksel bir aykırı değerdir, ancak bir ölçüm hatası değildir; tam tersine, bakım ekibinin yakalamaya çalıştığı **en değerli anomalidir**. Buna karşılık, oda sıcaklığındaki bir depoda sensörün bir saniyeliğine `150 °C` göstermesi (cihazın üst sınırı `85 °C` iken) fiziksel bir anomali değil, bariz bir **sensör veya iletim hatasıdır**.

Şüpheli ölçümleri yakalamak için pratikte üç farklı merceği bir arada kullanırız:

1. **Fiziksel ve Teknik Sınırlar (Domain Rules):** Negatif bağıl nem (`-5%`) veya sensörün erime noktasını aşan sıcaklıklar gibi doğa yasalarına ve cihaz kılavuzuna aykırı değerler doğrudan geçersiz kabul edilir.
2. **İstatistiksel Sınırlar (IQR Yöntemi):** Verinin dağılımına dayanır. Veriyi küçükten büyüğe sıraladığımızda, ilk %25'lik dilimin bittiği noktaya birinci çeyrek ($Q_1$), %75'lik dilimin bittiği noktaya üçüncü çeyrek ($Q_3$) deriz. Bu ikisi arasındaki fark bize **Çeyrekler Arası Aralığı (IQR)**, yani verinin ana gövdesinin genişliğini verir:
   $$\text{IQR} = Q_3 - Q_1$$
   Genel kabul gören kurala göre, $Q_1 - 1.5 \times \text{IQR}$ sınırının altına düşen veya $Q_3 + 1.5 \times \text{IQR}$ sınırının üzerine çıkan değerler "incelemeye değer uç gözlemler" olarak işaretlenir.
3. **Zamansal Bağlam ve Değişim Hızı:** Bir ölçüm tek başına normal sınırlar içinde görünebilir ama zamansal bağlamda anomali olabilir. Örneğin bir soğuk hava deposunda sıcaklığın `18 °C` olması genel istatistikte göre normal görünebilir; ancak sıcaklık 1 dakika içinde `-4 °C`'den `18 °C`'ye fırlamışsasa burada büyük bir anormallik vardır. Sadece genel dağılım grafiğine (histogram) bakmak bu zamansal sıçramaları gizler; bu yüzden **kayan pencere (rolling window)** ortalamaları ve ardışık ölçümler arasındaki farklar mutlaka kontrol edilmelidir.

Özetle; normalde 1–2 mm/s bandında seyreden titreşim verisinde `38 mm/s` gibi bir değer yakaladığımızda, IQR formülü bize "burada sıra dışı bir durum var" diye bayrak kaldırır. Ancak bu bayrak **"bu satırı sil"** demek değildir! Eğer bu gerçek bir makine sarsıntısıysa, o satırı silmek aradığımız arıza sinyalini kendi ellerimizle çöpe atmak anlamına gelir. Doğru yaklaşım, ham ölçümü olduğu gibi koruyup yanına `is_anomaly = True` gibi bir işaret sütunu eklemek ve sahadaki bakım kayıtlarıyla durumu doğrulamaktır.

| Yakalanan Gözlem | Olası Teknik Yorum | Güvenli Mühendislik Yaklaşımı |
| --- | --- | --- |
| Sıcaklık `150 °C` (Cihaz üst sınırı `85 °C`) | Sensör arızası, voltaj dalgalanması veya birim karışıklığı (Fahrenheit olabilir mi?). | Ham değeri koru; analiz sütununda geçersiz (`NULL`) olarak işaretle ve donanım ekibine bildir. |
| Titreşim `38 mm/s` (Normal seyir `1–2 mm/s`) | Makinede gerçek bir mekanik darbe/arıza veya sensörün yerinden oynaması. | Satırı kesinlikle silme! `is_anomaly` bayrağı ekle; o saatteki vardiya ve arıza kayıtlarıyla karşılaştır. |
| Bağıl nem `130%` | Fiziksel olarak imkânsız (kalibrasyon kayması). | Geçersiz ölçüm olarak işaretle; standart nem ortalamalarına dahil etme. |
| 1 dakikalık veri kopukluğu (Öncesi ve sonrası stabil) | Kısa süreli ağ veya paket kaybı. | Analiz amacına göre boş bırak veya doğrusal enterpolasyonla doldurup yanına eksiklik bayrağı ekle. |

Bazı analizlerde uç değerlerin ortalamayı bozmasını engellemek için **baskılama (Winsorization / Clipping)** adı verilen bir yöntem kullanılır. Bu yöntemde, belirlenen alt ve üst eşiği (örneğin %1 ve %99'luk dilimleri) aşan değerler silinmez; o sınır değerlere sabitlenir (örneğin 38 mm/s olan değer, üst sınır olan 5 mm/s'ye çekilir). Bu yöntem bazı istatistiksel modelleri rahatlatabilir; ancak gerçek arızanın şiddetini maskelediği için her veri temizleme sürecine ezbere eklenmemelidir.

---

## Veri Tipi Dönüşümleri ve Standardizasyon

Bilgisayarlar veriyi bizim gördüğümüz gibi görmez. Ekranda gördüğümüz `"22.4"` ifadesi, tırnak içinde bir metin (string) olarak saklanıyorsa, yazılım bununla matematiksel işlem yapamaz; hatta bazı dillerde iki metni toplamaya kalktığınızda `"22.4" + "10.0"` işleminin sonucu `32.4` değil, `"22.410.0"` çıkar! Aynı şekilde `"2026-04-06T09:00:00+03:00"` ifadesi metin olarak kaldığı sürece iki kayıt arasında kaç dakika geçtiğini hesaplayamazsınız; bunun gerçek bir tarih-saat (`datetime`) nesnesine dönüştürülmesi şarttır.

| Ham Kayıttaki Değer | Dönüştürülecek Hedef Tip | Dönüşüm Sırasında Dikkat Edilecek Nokta |
| --- | --- | --- |
| `"22.4"` veya `"22,4"` | Ondalıklı sayı (`float`) | Ondalık ayracı (nokta/virgül) standartlaştırılmalı, birim doğrulanmalı. |
| `"2026-04-06T09:00:00+03:00"` | Saat dilimli zaman damgası (`datetime`) | Saat dilimi bilgisi korunmalı veya tüm sistem ortak bir dilime (ör. UTC) çevrilmeli. |
| `" true "`, `"1"`, `"Aktif"` | Mantıksal değer (`boolean`) | Hangi metinlerin `True`, hangilerinin `False` sayılacağı net bir kuralla tanımlanmalı. |
| `" dev-01 "` | Kategorik metin (`string` / `category`) | Kenar boşlukları silinmeli, büyük/küçük harf uyumu sağlanmalı (`"DEV-01"`). |

Burada **biçim standardizasyonu** kavramı devreye girer. Farklı kaynaklardan gelen tarih formatlarını, ölçü birimlerini ve metin etiketlerini tek bir ortak dilde buluşturma işlemine biçim standardizasyonu diyoruz. Özellikle IoT projelerinde en kritik adım **zaman dilimi (timezone)** yönetimidir. Farklı şehirlerdeki veya bulut sunucularındaki cihazlardan gelen verileri ortak bir referansa —genellikle **UTC (Eşgüdümlü Evrensel Zaman)** standardına— çevirmek, olayları gerçek kronolojik sırasına dizmemizi sağlar. Ancak burada çok kritik bir kural vardır: **Saat dilimi bilgisi içermeyen (naive) bir zaman damgasını, kaynağını doğrulamadan ezbere UTC varsaymak büyük bir hatadır.** Türkiye'deki yerel saatle (`+03:00`) kayıt yapan ama sonuna saat dilimini yazmayan bir cihazın verisini doğrudan UTC kabul ederseniz, tüm olayları 3 saat kaydırmış olursunuz.

*Küçük ama önemli bir terminoloji uyarısı:* Veri temizlemedeki bu "biçim standartlaştırma" işlemini, istatistik ve makine öğrenmesindeki **sayısal standartlaştırma (standardization / scaling)** ile karıştırmamak gerekir. İstatistiksel standartlaştırma (Z-skoru dönüşümü), sayısal bir sütundaki değerleri ortalaması $0$, standart sapması $1$ olacak şekilde yeniden ölçeklendirir:

$$z = \frac{x - \mu}{\sigma}$$

Burada $x$ gözlem değerini, $\mu$ ortalamayı, $\sigma$ ise standart sapmayı temsil eder. Benzer şekilde **Min–Max ölçekleme**, değerleri genellikle $0$ ile $1$ arasına sıkıştırır. Bu matematiksel işlemler veri temizleme adımı değildir; bozuk formatları onarmaz, yanlış birimleri düzeltmez. Üstelik `22.4 °C` olan sıcaklığı `-0.45` gibi bir Z-skoruna dönüştürdüğünüzde, sayının fiziksel yorumlanabilirliğini (santigrat bilgisini) kaybedersiniz. Bu nedenle ölçeklendirme işlemleri, veri temizlenip doğrulandıktan çok sonra, yalnızca makine öğrenmesi algoritması böyle bir matematiksel ölçek talep ediyorsa modelleme aşamasında uygulanmalıdır.

---

## Kararları Belgelemek ve Ham Veriyi Korumak

İyi bir veri hazırlama sürecinin en büyük sırrı, veriyi sessiz sedasız değiştirmek değil; **hangi kaydın, neden ve nasıl değiştirildiğini geriye dönük olarak izlenebilir (denetlenebilir) kılmaktır.** Profesyonel bir veri hattında (pipeline) şu altın kurallar sırasıyla uygulanır:

1. **Ham veriye asla dokunma (Immutability):** İlk gelen ham dosyayı (veya veritabanı tablosunu) salt okunur biçimde saklayın; işlemleri her zaman bir kopya veya yeni bir katman üzerinde yürütün. Yanlış bir dönüşüm kuralı yazdığınızı fark ettiğinizde geri dönebileceğiniz tek güvenli liman ham veridir.
2. **Keşif ve profil çıkarma:** Sütun tiplerini, birimlerini, min-maks değerlerini ve sütun bazlı eksiklik oranlarını raporlayın.
3. **Yapısal temizlik:** Mükerrer kayıtları, metin boşluklarını ve format/tip dönüşümlerini açıkça tanımlanmış kurallarla standartlaştırın.
4. **Anomali ve sınır kontrolü:** Fiziksel sınırları aşan hatalı veriler ile istatistiksel olarak uçta kalan şüpheli gözlemleri birbirinden ayırıp bayraklayın (`flagging`).
5. **Müdahale ve gerekçelendirme:** Silme, boş bırakma veya doldurma (imputation) kararlarını analiz sorusuna göre uygulayın ve her müdahalenin gerekçesini kodda/dokümanda belirtin.
6. **Son sağlamalar (Sanity Check):** Dönüşüm bittikten sonra satır sayılarını, ortalama/medyan kaymalarını ve veri tiplerini işlem öncesiyle karşılaştırarak beklenmedik bir veri kaybı olmadığından emin olun.

Temizlik bittiğinde tablonuzda tek bir boş hücrenin veya uç değerin kalmamış olması, elinizdeki verinin "mükemmel ve doğru" olduğu anlamına gelmez. Eğer sahadaki bir sensör her gün %40 oranında hatalı ölçüm gönderiyorsa, çözüm o boşlukları zekice formüllerle doldurmak değil, sahadaki donanım ekibini uyarıp o sensörü değiştirmektir. Bu nedenle temizlik sürecinin çıktısı yalnızca "temizlenmiş tablo" değil; aynı zamanda kaç satırın elendiğini, hangi varsayımların yapıldığını ve hangi cihazların sorunlu olduğunu gösteren bir **veri kalitesi raporudur**.

---

## Sonuç

Özetle veri temizleme; eksik, hatalı, tutarsız ve sıra dışı kayıtları tespit edip, elimizdeki probleme en uygun mühendislik kararlarını verme sanatıdır. Boş hücreleri körlemesine ortalamayla doldurmak, her uç değeri "hatalıdır" diyerek silmek ya da birimini bilmediğimiz sayıları tek bir formata zorlamak analizi kurtarmaz; aksine hatayı kurumsallaştırır. 

Verinin neyi temsil ettiğini, sahadaki fiziksel karşılığını ve analiz amacımızı bir bütün olarak değerlendirdiğimizde; ham veriyi koruyup attığımız her adımı belgelediğimizde, hem herkesin güvenebileceği şeffaf sonuçlar üretiriz hem de verinin içinde gizlenen gerçek hikayeleri kaybetmemiş oluruz.

Serinin bir sonraki yazısında, burada konuştuğumuz tüm prensipleri gerçekçi bir sensör veri seti üzerinde **Python ve Pandas** kullanarak adım adım kodlayacağız.
