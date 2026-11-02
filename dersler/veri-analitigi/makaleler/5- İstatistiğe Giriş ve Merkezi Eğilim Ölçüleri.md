# İstatistiğe Giriş ve Merkezi Eğilim Ölçüleri: Binlerce Kaydı Doğru Özetleme Sanatı

Dijital sistemlerde her gün milyonlarca satır veri birikir: bir e-ticaret sitesindeki sipariş tutarları, bir mobil uygulamanın yanıt süreleri, kargo teslimat dakikaları veya bir üretim hattındaki kalite ölçümleri... Veriyi kayıpsız toplamak ve temizlemek işin ilk adımıdır; ancak karar vericinin ya da bir algoritmanın önüne yüz binlerce satırlık ham tabloyu olduğu gibi koyamazsınız. İnsan zihni binlerce sayıyı aynı anda okuyup kıyaslayamaz; veriyi konuşabilir ve karara dönüşebilir hale getirmek için onu **doğru özetlemeye** ihtiyacımız vardır.

İşte **istatistik**, tam bu noktada devreye girer. İstatistik yalnızca formüllerden ibaret soyut bir matematik dalı değildir; belirsizlik ve değişkenlik içeren veri yığınlarından anlamlı özetler çıkarma, örüntüleri yakalama ve bu özetlere dayanarak güvenilir kararlar alma disiplinidir. Bu yazıda, veri setlerini analitik olarak yorumlayabilmemiz için gereken temel istatistiksel kavramları kuracak; ardından büyük veri yığınlarının "tipik" davranışını özetleyen **merkezi eğilim ölçülerini (ortalama, medyan, mod)** ve bu ölçülerle analize hazır özet veri setlerinin nasıl kurgulandığını inceleyeceğiz.

---

## Temel İstatistiksel Kavramlar: Tablodaki Sayılar Neyi Temsil Ediyor?

Bir veri tablosuna herhangi bir özet formülü uygulamadan önce, elimizdeki kayıtların büyük resmin neresinde durduğunu netleştirmemiz gerekir. Veri analitiğinde en sık düşülen yanılgılardan biri, *"Elimde 50.000 satırlık bir tablo var, demek ki tüm gerçeğe sahibim"* düşüncesidir. Oysa elimizdeki veri çoğu zaman gerçeğin tamamı değil, belirli bir zaman aralığında ve belirli koşullar altında çekilmiş bir fotoğrafıdır.

Bir çevrimiçi yemek ve market teslimat platformunu yönettiğimizi düşünelim. Bu senaryo üzerinden istatistiğin yapı taşlarını tanımlayalım:

* **Gözlem Birimi ve Değişken:** Tablomuzda ölçüm yaptığımız her bir varlığa veya olaya **gözlem birimi (unit of observation)**, bu birimlerin ölçülen her bir özelliğine ise **değişken (variable)** deriz. Örneğin siparişler tablomuzda her bir satır (tamamlanan bir sipariş) bir gözlem birimidir; `teslimat_suresi_dk`, `sepet_tutari_tl`, `odeme_yontemi` ve `bolge` sütunları ise birer değişkendir.
* **Anakütle (Popülasyon / Population):** Araştırma veya iş sorumuzun hedeflediği **tüm birimlerin tamamıdır**. Sorumuz *"Platformumuzun Türkiye genelindeki teslimat hızı nedir?"* ise, anakütle platformdaki tüm kuryelerin yaptığı ve yapacağı tüm teslimatlardır.
* **Örneklem (Sample):** Anakütlenin tamamını ölçmek çoğu zaman imkânsız, çok maliyetli veya zaman açısından olanaksız olduğu için, anakütleden seçilip fiilen incelenen **alt kümedir**. Örneğin kasım ayının ilk haftasında İstanbul'daki 5.000 siparişi incelemeye aldığımızda, bu 5.000 kayıt bir örneklemdir.
* **Parametre ve İstatistik:** Anakütlenin gerçek (ama çoğunlukla tam olarak bilinemeyen) sayısal özeti **parametre** olarak adlandırılır ve genellikle Yunan harfleriyle gösterilir (örneğin anakütle ortalaması $\mu$, anakütle büyüklüğü $N$). Örneklemden hesapladığımız ve parametreyi tahmin etmek için kullandığımız sayısal özete ise **istatistik** denir ve Latin harfleriyle gösterilir (örneğin örneklem ortalaması $\bar{x}$, örneklem büyüklüğü $n$).

| Kavram | Neyi Temsil Eder? | Sembol Örneği | Teslimat Platformu Senaryosundaki Karşılığı |
| --- | --- | --- | --- |
| **Anakütle (Popülasyon)** | Sorumuzun ilgilendiği tüm olası gözlemler kümesi | $N$ (Birim sayısı) | Platformda yıl boyunca gerçekleşen tüm siparişler |
| **Örneklem** | Elimizdeki tabloda fiilen yer alan, incelenen alt küme | $n$ (Satır sayısı) | Kasım ayının ilk haftasında kaydedilen 5.000 sipariş |
| **Parametre** | Anakütlenin gerçek sayısal karakteristiği (hedef) | $\mu$ (Anakütle ortalaması) | Platformun tüm siparişlerdeki gerçek ortalama teslimat süresi |
| **İstatistik** | Örneklemden hesaplanan sayısal özet (tahmin) | $\bar{x}$ (Örneklem ortalaması) | Elimizdeki 5.000 siparişten hesapladığımız `34.2 dakika` ortalama |

Buradan istatistiğin iki ana çalışma alanına ulaşırız:
1. **Betimsel İstatistik (Descriptive Statistics):** Elimizdeki mevcut veriyi tablo, grafik veya merkezi eğilim/dağılım ölçüleriyle özetleyip *"Elimizdeki kayıtlarda ne oldu?"* sorusuna yanıt verir.
2. **Çıkarımsal İstatistik (Inferential Statistics):** Örneklemden elde edilen istatistikleri kullanarak, tamamını göremediğimiz anakütle hakkında olasılıksal genellemeler yapar ve *"Bu haftaki teslimat süresindeki 3 dakikalık düşüş tesadüf mü, yoksa yeni rota algoritmamız gerçekten işe yaradı mı?"* sorusunu yanıtlar.

### Neden ve Nasıl Örneklem Alırız? Başlıca Örnekleme Türleri

Peki dijital çağda neden anakütlenin tamamını değil de bir örneklemi inceleriz? Bazen anakütlenin tamamına ulaşmak fiziksel olarak imkânsızdır: Örneğin bir pil üreticisi, ürettiği pillerin ömrünü test etmek için fabrikadaki tüm pilleri bitene kadar çalıştıramaz; aksi halde satacak pil kalmaz! Bazen de tüm veriyi işlemek gereksiz yere zaman ve kaynak tüketir. Tıpkı bir tencere çorbanın tuzunu kontrol etmek için bütün tencereyi içmemize gerek olmaması gibi; **tencereyi iyi karıştırdığımız sürece** alacağımız tek bir kaşık (örneklem), tüm tencere (anakütle) hakkında bize oldukça doğru bilgi verir.

Elbette sadece bir alt kümeye baktığımız için, örneklemden hesapladığımız istatistik ($\bar{x}$) ile gerçek anakütle parametresi ($\mu$) arasında küçük bir fark olması doğaldır; buna **örnekleme hatası (sampling error)** denir. Örnekleme yaparken asıl korktuğumuz şey bu doğal fark değil, örneklemi yanlış seçerek **temsil yanlılığına (sampling bias)** düşmektir (yani tencerenin sadece dibinden veya üstünden kaşık almaktır).

Analizlerde anakütleyi doğru temsil edebilmek için en sık başvurulan örnekleme yöntemleri şunlardır:

* **Basit Rastgele Örnekleme (Simple Random Sampling):** Anakütledeki her bir birimin örnekleme seçilme şansının tamamen eşit ve birbirinden bağımsız olduğu yöntemdir.
  * *Örnek:* Yıl boyunca tamamlanan 1 milyon siparişin bulunduğu veritabanından, hiçbir bölge, saat veya tutar ayrımı gözetmeksizin bilgisayarın rastgele sayı üreteciyle (`random`) kura çeker gibi 5.000 sipariş seçmesi.
* **Tabakalı Örnekleme (Stratified Sampling):** Anakütle kendi içinde farklı karakterde alt gruplara (**tabakalara**) ayrılıyorsa, tamamen rastgele seçim yapmak küçük ama önemli grupların örneklemde yeterince yer almamasına yol açabilir. Bu yöntemde anakütle önce homojen alt tabakalara ayrılır, ardından her tabakadan kendi büyüklüğü oranında rastgele seçim yapılır.
  * *Örnek:* Teslimat platformumuzdaki siparişlerin %70'i İstanbul, %20'si Ankara, %10'u ise Eskişehir'den geliyorsa; seçeceğimiz 1.000 siparişlik örneklemin de tam olarak 700'ünü İstanbul'dan, 200'ünü Ankara'dan ve 100'ünü Eskişehir'den rastgele çekmek. Böylece büyük şehrin verisi küçük şehirlerin karakteristiğini ezmemiş olur.
* **Sistematik Örnekleme (Systematic Sampling):** Sıralı bir listeden veya veri akışından belirli bir sabit aralıkla ($k$ adımda bir) birim seçilmesidir. Uygulaması çok pratiktir.
  * *Örnek:* Bir üretim bandından çıkan her 50. paketi kalite kontrol için ayırmak veya bir web sunucusuna gelen her 100. isteğin (`request`) yanıt süresini performans tablosuna kaydetmek. *(Dikkat: Eğer sistemde her 100. işlemde bir çalışan otomatik bir yedekleme görevi varsa, sistematik örnekleme hep bu yavaşlatıcı ana denk gelip yanıltıcı sonuç üretebilir.)*
* **Convenience Sampling ve Yanlılık Tuzağı (Selection Bias):** İstatistiksel kurallara uymadan, ulaşılması en kolay veya o an hazırda bulunan bir kesiti tüm anakütle varsaymaktır.
  * *Örnek:* Teslimat hızını ölçmek için yalnızca güneşli bir salı öğleden sonrasının kayıtlarını örneklem olarak seçmek (cuma akşamı yağmur ve trafik saatlerini dışarıda bırakmak) ya da uygulama memnuniyetini ölçmek için yalnızca uygulamayı her gün açan sadık kullanıcılara anket göndermek.

| Örnekleme Yöntemi | Temel Mantığı | Pratik Örnek | Güçlü Yanı / Dikkat Edilecek Nokta |
| --- | --- | --- | --- |
| **Simple Random (Basit Rastgele)** | Her birimin seçilme olasılığı eşittir. | 1 milyon sipariş içinden rastgele 5.000 kayıt çekmek. | Tarafsızdır; ancak çok küçük alt gruplar şans eseri dışarıda kalabilir. |
| **Stratified (Tabakalı)** | Anakütle alt gruplara bölünür, her gruptan orantılı örnek alınır. | Şehirlerin veya müşteri tiplerinin oranını koruyarak örnek seçmek. | Alt grupların (ör. küçük şubelerin) örneklemde kesin olarak temsil edilmesini garanti eder. |
| **Systematic (Sistematik)** | Sıralı akıştan her $k$'ıncı birim seçilir. | Banttan geçen her 50. ürünü veya her 100. sunucu isteğini seçmek. | Kodlaması ve uygulaması çok kolaydır; ancak veride periyodik bir döngü varsa yanılabilir. |
| **Convenience (Yanlı Seçim)** | En kolay ulaşılan veriyi seçmek (Kaçınılmalıdır). | Sadece öğle saatlerindeki siparişlere veya sadık müşterilere bakmak. | Hızlıdır ama **selection bias (seçim yanlılığı)** üretir; en doğru formül bile yanlış sonuç verir. |

---

## Merkezi Eğilim Ölçüleri: "Tipik" Değeri Bulmak

Binlerce satırlık bir veri setini tek bir sayıyla özetlemek istediğimizde aslında şu soruyu sorarız: **"Bu verinin merkezi neresi, yani 'tipik' veya 'olağan' bir gözlem kaç civarında?"** İstatistikte verinin etrafında toplandığı bu merkezi konumu gösteren metriklere **merkezi eğilim ölçüleri (measures of central tendency)** adını veririz. En yaygın üç merkezi eğilim ölçüsü **aritmetik ortalama**, **medyan (ortanca)** ve **mod (tepe değer)** olarak karşımıza çıkar. 

Bu üç ölçünün her biri "merkez" kavramını farklı bir açıdan tanımlar ve veri setindeki uç değerlere karşı çok farklı tepkiler verir.

### 1. Aritmetik Ortalama (Mean): Verinin Ağırlık Merkezi

Günlük hayatta ve iş raporlarında "ortalama" dediğimizde kastettiğimiz şey **aritmetik ortalamadır**. Elimizdeki $n$ adet sayısal gözlemin ($x_1, x_2, \dots, x_n$) toplamının, gözlem sayısına bölünmesiyle elde edilir:

$$\bar{x} = \frac{x_1 + x_2 + \dots + x_n}{n} = \frac{1}{n} \sum_{i=1}^{n} x_i$$

Eğer elimizdeki veri bir örneklem değil de ilgilendiğimiz anakütlenin tamamıysa, aynı formül anakütle büyüklüğü $N$ ile yazılır ve $\mu = \frac{1}{N}\sum_{i=1}^{N} x_i$ olarak gösterilir.

Aritmetik ortalamanın en güçlü yanı, veri setindeki **her bir gözlemi hesaba katmasıdır**. Fiziksel olarak düşündüğümüzde ortalama, sayı doğrusu üzerine yerleştirilmiş ağırlıkların tam denge noktasıdır (ağırlık merkezidir): Ortalamanın solunda kalan değerlerin ortalamaya olan uzaklıklarının toplamı, sağında kalanların uzaklıkları toplamına tam olarak eşittir ($\sum (x_i - \bar{x}) = 0$).

Ancak ortalamanın bu "herkesi hesaba katma" özelliği, aynı zamanda onun en büyük zaafıdır: **Aritmetik ortalama, aşırı uç değerlere (outliers) karşı son derece hassastır.**

Küçük bir yazılım ekibinde çalışan 5 kişinin aylık gelirlerini (bin TL cinsinden) düşünelim:
* Dört geliştiricinin maaşı sırasıyla: `45`, `48`, `50` ve `52` bin TL olsun. (Bu dört kişinin ortalaması `48.75` bin TL'dir.)
* Beşinci kişi ise şirketin kurucu ortağı olsun ve aylık geliri `355` bin TL olsun.

Şimdi bu 5 kişilik ekibin aritmetik ortalama gelirini hesaplayalım:

$$\bar{x} = \frac{45 + 48 + 50 + 52 + 355}{5} = \frac{550}{5} = 110\text{ bin TL}$$

Sonuca dikkat edin: Bulduğumuz `110 bin TL` değeri, ne ekipteki geliştiricilerin gerçek gelir düzeyini (`45–52 bin TL`) temsil ediyor ne de kurucu ortağın gelirini (`355 bin TL`) anlatıyor! Tek bir uç gözlem, ağırlık merkezini kendi tarafına doğru şiddetle çekmiş ve ortalamayı "tipik çalışan geliri" olmaktan tamamen çıkarmıştır. Aynı durum e-ticarette de yaşanır: Normalde `200–500 TL` arası alışveriş yapılan bir sitede tek bir kurumsal müşterinin `250.000 TL`'lik toplu sipariş vermesi, o günün "ortalama sepet tutarını" bir anda yapay biçimde şişirir.

> **Analitik Uyarı — Ortalamaların Ortalaması Tuzağı (Ağırlıklı Ortalama):**
> Pratikte sık yapılan bir diğer hata, farklı büyüklükteki grupların ortalamalarını alıp bunların doğrudan aritmetik ortalamasını hesaplamaktır. Örneğin A şubesinde **200 sipariş** teslim edilmiş ve ortalama süre `30 dakika` çıkmış olsun; yeni açılan B şubesinde ise yalnızca **20 sipariş** teslim edilmiş ve ortalama süre `52 dakika` çıkmış olsun. Şirket genelindeki ortalama teslimat süresini $\frac{30 + 52}{2} = 41\text{ dakika}$ olarak raporlamak büyük bir hatadır; çünkü 20 siparişlik küçük şubeye, 200 siparişlik büyük şubeyle eşit söz hakkı vermiş olursunuz. Doğru yaklaşım, her grubu kendi işlem hacmiyle ($w_i$) tartarak **ağırlıklı ortalama (weighted average)** almaktır:
> $$\bar{x}_w = \frac{\sum w_i \bar{x}_i}{\sum w_i} = \frac{(200 \times 30) + (20 \times 52)}{200 + 20} = \frac{7040}{220} = 32\text{ dakika}$$

### 2. Medyan (Ortanca): Sıralı Verinin Dirençli Merkezi

Aritmetik ortalamanın uç değerler karşısında nasıl savrulduğunu gördük. Peki uçlarda ne yaşanırsa yaşansın, verinin "tam ortasında" duran değeri nasıl buluruz? İşte **medyan (ortanca)**, tüm gözlemler küçükten büyüğe (veya büyükten küçüğe) sıralandığında dizinin tam ortasında yer alan değerdir. Verinin %50'si medyanın altında veya ona eşit, %50'si ise üstünde veya ona eşittir.

Gözlemleri küçükten büyüğe sıraladığımızda ($x_{(1)} \le x_{(2)} \le \dots \le x_{(n)}$), medyanın hesabı gözlem sayısının ($n$) tek veya çift olmasına göre iki basit kuralla yapılır:

$$\text{Medyan} = \begin{cases} x_{\left(\frac{n+1}{2}\right)} & \text{eğer } n \text{ tek ise} \\[8pt] \dfrac{x_{\left(\frac{n}{2}\right)} + x_{\left(\frac{n}{2}+1\right)}}{2} & \text{eğer } n \text{ çift ise} \end{cases}$$

Az önceki 5 kişilik maaş örneğimizi (`45, 48, 50, 52, 355`) küçükten büyüğe sıralayalım:
`45`, `48`, **`50`**, `52`, `355`

Gözlem sayımız $n = 5$ (tek sayı) olduğu için, ortanca sıra $\frac{5+1}{2} = 3$. sıradır. Dizinin 3. sırasındaki değer **`50 bin TL`**'dir! Bakın, kurucu ortağın geliri `355` değil de `3.550 bin TL` bile olsaydı, sıralamadaki yeri değişmeyeceği için medyan yine `50 bin TL` kalacaktı ve ekipteki tipik bir çalışanın gelirini çok daha dürüst biçimde temsil edecekti. (Eğer 6. bir kişi olarak `56 bin TL` maaşla bir çalışan daha eklenseydi, $n=6$ çift olacağı için ortadaki 3. ve 4. değerlerin ortalamasını alacak ve medyanı $\frac{50 + 52}{2} = 51\text{ bin TL}$ olarak bulacaktık.)

İstatistikte uç değerlerden etkilenmeyen bu tür metriklere **dirençli (robust) istatistikler** denir. Emlak fiyatları, hane halkı gelirleri, sunucu yanıt süreleri (latency) veya kargo teslimat süreleri gibi aşırı uçların doğal olarak bulunduğu alanlarda medyan, ortalamadan çok daha güvenilir bir pusuladır.

### 3. Mod (Tepe Değer): En Sık Karşılaşılan Durum

**Mod**, bir veri setinde **en yüksek frekansla (en sık) tekrar eden değerdir**. Ortalama ve medyan yalnızca sayısal (veya sıralanabilir) verilerde hesaplanabilirken, **mod hem sayısal hem de kategorik (metin/etiket) verilerde kullanılabilir.**

Örneğin sipariş tablomuzdaki `odeme_yontemi` sütununda yer alan `"Kredi Kartı"`, `"Dijital Cüzdan"` ve `"Kapıda Ödeme"` ifadelerinin ortalamasını veya medyanını alamazsınız; ancak en sık hangi ödeme yönteminin tercih edildiğini (modunu) bulabilirsiniz. Benzer şekilde bir ayakkabı mağazasının stok planlamasında *"Ortalama satılan ayakkabı numarası `41.37`'dir"* bilgisi üretime hiçbir fayda sağlamaz; mağazanın asıl bilmek istediği şey en çok satılan numaranın (modun) `42` olduğudur.

Sayısal verilerde mod kullanılırken iki önemli özelliğe dikkat edilmelidir:
* **Mod her zaman tek bir değer olmak zorunda değildir:** Küsuratlı sürekli verilerde (örneğin `142.38 TL`, `89.12 TL` gibi sepet tutarlarında) hiçbir sayı birebir aynı değerle tekrar etmeyebilir; bu durumda veri setinin modu yoktur (veya veriyi `0–100 TL`, `100–200 TL` gibi aralıklara bölerek "modal sınıf" bulmak gerekir). Tersine, iki farklı değer aynı en yüksek sıklıkla tekrar ediyorsa veri **çift tepeli (bimodal)**, daha fazla tepe noktası varsa **çok tepeli (multimodal)** olarak adlandırılır.
* **Çok tepelilik verinin içindeki farklı müşteri veya sistem gruplarını ele verir:** Örneğin bir restoranın sipariş saatleri incelendiğinde hem saat `12:30` civarında hem de `19:30` civarında iki ayrı zirve (bimodal dağılım) görülür. Bu iki tepe noktasının ortalamasını alıp *"En yoğun saatimiz `16:00`'dır"* demek, restoranın en boş olduğu ikindi vaktini en yoğun saat sanmanıza yol açar!

---

## Dağılımın Şekli: Ortalama ve Medyan Neden Ayrışır?

Bir veri setinde ortalama, medyan ve modun birbirine göre konumu, bize verinin grafiğini bile çizmeden **dağılımın şekli (simetrisi veya çarpıklığı / skewness)** hakkında çok güçlü bir ipucu verir:

1. **Simetrik Dağılım:** Veriler merkezin sağında ve solunda dengeli biçimde dağılmışsa (örneğin standart bir üretim bandından çıkan paketlerin ağırlıkları veya yetişkin insanların boy uzunlukları), **Ortalama $\approx$ Medyan $\approx$ Mod** olur. Bu durumda aritmetik ortalama veriyi mükemmel temsil eder.
2. **Sağa Çarpık (Pozitif Çarpık) Dağılım:** Gözlemlerin büyük çoğunluğu düşük/normal değerlerde kümelenmişken, az sayıda çok yüksek uç değer dağılımın sağ kuyruğunu uzatıyorsa oluşur. Yüksek uç değerler ortalamayı kendi yönüne (sağa) çekerken, medyan ortada dirençli kalır: **Mod $<$ Medyan $<$ Ortalama**. Bilişim ve iş dünyasında **web servisi yanıt süreleri (API latency)**, **kargo teslimat süreleri**, **müşteri sepet tutarları** ve **maaş dağılımları** neredeyse her zaman sağa çarpıktır. (Örneğin bir teslimat en erken 10 dakikada gidebilir, yani sol taraf sıfırla sınırlıdır; ancak adres bulamama veya trafik kazası yüzünden bir sipariş 180 dakika sürebilir ve ortalamayı yukarı çeker.)
3. **Sola Çarpık (Negatif Çarpık) Dağılım:** Verilerin çoğu yüksek değerlerde toplanmışken, az sayıda çok düşük değer sol kuyruğu uzatıyorsa oluşur. Bu kez düşük uç değerler ortalamayı aşağı (sola) çeker: **Ortalama $<$ Medyan $<$ Mod**. Örneğin çok kolay bir sınavda öğrencilerin çoğunun `85–100` arası not alıp sadece birkaç öğrencinin `10` alması, sınav ortalamasını medyanın altına düşürür.

| Merkezi Eğilim Ölçüsü | Matematiksel Tanım | Uç Değerlere (Outlier) Duyarlılık | En Uygun Kullanım Senaryosu |
| --- | --- | --- | --- |
| **Aritmetik Ortalama ($\bar{x}$)** | Tüm değerlerin toplamının eleman sayısına bölümü | **Çok Yüksek** (Uç değerler ortalamayı kendine çeker) | Simetrik dağılan, uç değerlerden arındırılmış sayısal veriler ve toplam hacimle doğrudan ilişkili hesaplar. |
| **Medyan (Ortanca)** | Sıralı dizinin tam ortasındaki (%50) değer | **Çok Düşük / Dirençli** (Yalnızca sıralamaya bakar) | Çarpık dağılımlar veya uç değer barındıran sayısal veriler (ör. gelir, sepet tutarı, teslimat/yanıt süresi). |
| **Mod (Tepe Değer)** | En sık tekrar eden gözlem değeri | **Duyarsız** (Frekansa bakar) | Kategorik değişkenler (ödeme yöntemi, şehir, hata kodu) veya kesikli tam sayılar (ürün bedeni, puanlama). |

---

## Analitik İçin Veri Seti Oluşturma: Ham Kayıtlardan Özet Tabloya

Temel istatistiksel kavramları ve merkezi eğilim ölçülerini öğrendik; peki bunları gerçek bir projede **analize hazır bir veri seti oluştururken ve okurken** nasıl bir araya getiririz?

Operasyonel sistemlerdeki ham tablolar işlem odaklıdır; yani her sipariş, her tıklama veya her fatura kalemi ayrı bir satır olarak kaydedilir. Gelin bir teslimat bölgesinde (`Kadıköy`) arka arkaya kaydedilmiş 6 siparişlik küçük bir ham veri kesitine bakalım:

| siparis_id | bolge | odeme_yontemi | sepet_tutari_tl | teslimat_suresi_dk |
| ---: | --- | --- | ---: | ---: |
| 101 | Kadıköy | Kredi Kartı | `240.00` | `28` |
| 102 | Kadıköy | Kredi Kartı | `310.00` | `32` |
| 103 | Kadıköy | Dijital Cüzdan | `280.00` | `30` |
| 104 | Kadıköy | Kredi Kartı | `290.00` | `34` |
| 105 | Kadıköy | Havale/EFT | `14880.00` | `146` |
| 106 | Kadıköy | Kapıda Ödeme | `260.00` | *(Eksik / Yolda)* |

*(Not: `105` numaralı sipariş kurumsal bir toplu alımdır ve hazırlığı uzun sürmüştür; `106` numaralı sipariş ise henüz teslim edilmediği için süresi boştur.)*

Karar destek raporları veya makine öğrenmesi modelleri tekil işlem satırlarıyla değil; **müşteri bazında, şube bazında veya gün/hafta bazında özetlenmiş analitik veri setleriyle (özet tablolarla)** çalışır. Yukarıdaki ham sipariş kayıtlarını bölge bazında özetleyerek analitik bir veri setine dönüştürdüğümüzde şu tabloyu elde ederiz:

| bolge | toplam_siparis | tamamlanan_teslimat | ortalama_sepet_tl | medyan_sepet_tl | ortalama_sure_dk | medyan_sure_dk | baskin_odeme (mod) |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `Kadıköy` | 6 | 5 | `2710.00` | `285.00` | `54.0` | `32.0` | `Kredi Kartı (%50)` |

Bu dönüşümü yaparken ve analitik veri setini tasarlarken dört altın kurala dikkat etmemiz gerekir:

1. **Hedef Soruyu ve Gözlem Birimini Netleştir:** Oluşturacağın yeni tabloda **bir satır neyi temsil edecek?** Eğer amaç şubelerin günlük performansını kıyaslamaksa, yeni veri setinin gözlem birimi tekil siparişler değil, `Bölge × Gün` olmalıdır.
2. **Eksik Verileri Sıfır Sanma:** `106` numaralı sipariş henüz yolda olduğu için teslimat süresi boştur. Eğer veri setini oluştururken boş hücreleri "eksik" olarak bırakmak yerine `0` ile doldurursanız, 6 siparişin toplam süresini (`270 dk`) 6'ya böler ve ortalamayı yanlışlıkla `45.0 dakika` bulursunuz. Doğru hesap, yalnızca tamamlanan **5 geçerli teslimat** üzerinden yapılmalıdır ($\frac{270}{5} = 54.0\text{ dk}$).
3. **Ortalama ve Medyanı Birlikte Tut (Özetleme Körlüğünden Kaçın):** Özet tabloya yalnızca `ortalama_sepet_tl` sütununu koyarsanız, 6 siparişin 5'i `240–310 TL` bandında olmasına rağmen tek bir kurumsal sipariş (`14.880 TL`) yüzünden tipik bir müşterinin `2.710 TL` harcadığını sanırsınız! Yanına `medyan_sepet_tl` (`285.00 TL`) sütununu eklediğiniz anda, hem toplam ciroyu tutturur hem de gerçek müşteri davranışını korursunuz. Aynı şekilde teslimat süresinde ortalama (`54.0 dk`) ile medyan (`32.0 dk`) arasındaki makasın açılması, analiste tek bakışta *"Normalde yarım saatte teslimat yapıyoruz ama ortalamayı yukarı çeken istisnai gecikmeler var"* mesajını verir.
4. **Örneklem Büyüklüğünü ($n$) ve Kategorik Modu Özete Dahil Et:** Bir bölgenin ortalama teslimat süresi `25 dakika` görünüyor olabilir; ama bu ortalama **1.200 sipariş** üzerinden mi hesaplandı, yoksa sadece **3 sipariş** üzerinden mi? Gözlem sayısını (`toplam_siparis`, `tamamlanan_teslimat`) içermeyen hiçbir ortalama veya medyan güvenilir değildir. Ayrıca kategorik sütunlar da en sık tekrar eden değerleriyle (`baskin_odeme = Kredi Kartı`) özet tabloya taşınarak veri kaybı önlenir.

---

## Sonuç: Merkez Tek Başına Yeterli mi?

Bu yazıda veriyi tek tek satırlar halinde okumak yerine, istatistiğin temel kavramlarıyla (**anakütle, örneklem, parametre, istatistik**) çerçevelemeyi ve **merkezi eğilim ölçüleriyle (ortalama, medyan, mod)** özetlemeyi öğrendik. Gördük ki:
* "En iyi" merkezi eğilim ölçüsü diye tek bir doğru yoktur; doğru ölçü, verinin tipine ve dağılımın şekline göre seçilir.
* Simetrik sayısal verilerde **aritmetik ortalama** güçlü bir ağırlık merkezi sunarken, uç değerlerin ve çarpıklığın bulunduğu gerçek dünya verilerinde **medyan** çok daha dirençli ve dürüst bir "tipik değer" verir. Kategorik verilerde ve tekrar sıklığı sorularında ise söz hakkı **mod**dadır.
* İyi tasarlanmış bir analitik veri seti, örneklem büyüklüğüyle ($n$) birlikte ortalamayı ve medyanı yan yana koyarak verinin içindeki çarpıklığı tek bakışta görünür kılar.

Ancak burada kendimize kritik bir soru sormamız gerekiyor: **Merkezi bilmek, veriyi anlamak için tek başına yeterli midir?** 

İki farklı kargo şubesi düşünün. İkisinin de hem ortalama hem de medyan teslimat süresi tam olarak `30 dakika` olsun. İlk şube tüm paketlerini `28 ile 32 dakika` arasında son derece tutarlı biçimde teslim ederken; ikinci şube paketlerin yarısını `10 dakikada`, diğer yarısını ise `50 dakikada` teslim ediyor olsun. Sadece ortalama ve medyana bakarsanız bu iki şubenin "birebir aynı kalitede" çalıştığını sanırsınız; oysa ikinci şube müşterilerin yarısını mağdur etmektedir!

Merkezi eğilim ölçüleri bize verinin **nerede toplandığını** söyler ama **ne kadar saçıldığını ve dalgalandığını** anlatamaz. Serinin bir sonraki yazısında, merkezi eğilimlerin ötesine geçerek verinin yayılımını ölçen **dağılım ölçülerini (varyans ve standart sapma)** ve gelecekteki eğilimleri öngörmemizi sağlayan **temel olasılık kavramlarını** inceleyeceğiz.
