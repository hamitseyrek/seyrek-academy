# Ürün Gereksinimleri ve MVP Tasarımı: Fikirden Bitirilebilir Ürüne

*Bir uygulama fikrini seçmek kolaydır. Asıl mühendislik, doğru problemi seçip onu bitirilebilir bir ürüne dönüştürmektir.*

“Öğrenciler için bir uygulama yapacağım.” Bu cümle bir başlangıçtır, ama henüz geliştirilebilir bir ürün tanımı değildir. Hangi öğrenciler? Hangi sorun? Uygulama açıldığında kullanıcının hangi işi kolaylaşacak? Bunlar netleşmeden kod yazmaya başlamak, haritasız yola çıkıp her kavşakta yön değiştirmeye benzer.

Bir ürün fikri; kullanıcı, problem, başarı ölçütü ve uygulanabilir kapsam bir araya geldiğinde yazılım gereksinimine dönüşür. Bu adım mimariyi de etkiler: karar verilmemiş ihtiyaçlar, kod içinde varsayımlara dönüşür; varsayımlar arttıkça değişiklik yapmak pahalılaşır.

## Fikirden gereksinime

Önce birincil kullanıcıyı ve yaşadığı problemi belirleyin. “Herkes” genellikle iyi bir hedef kullanıcı değildir; çünkü farklı kullanıcıların ihtiyaçları farklıdır. Örneğin:

> Üniversite öğrencileri çalıştıkları zamanı takip etmek istiyor, ancak oturumlarını birden fazla yerde tuttuğu için haftalık toplamını göremiyor.

Bu problem, olası bir çözümden önce gelir. Uygulamayı hangi teknolojiyle yazacağınızı veya hangi veritabanını kullanacağınızı henüz bilmeniz gerekmez. Önce kullanıcının bugün ne yaptığını, nerede zorlandığını ve başarılı bir çözümün nasıl görüneceğini anlamak gerekir.

İyi bir başlangıç için şu sorular yeterlidir:

- Kullanıcı kim ve bu sorunu ne sıklıkla yaşıyor?
- Bugün bu işi nasıl çözüyor?
- Çözümün başarılı olduğunu hangi gözlenebilir davranış gösterir?
- Zaman, platform, erişim, bütçe veya veri gizliliği açısından hangi kısıtlar var?

Bu soruların yanıtı tahmin olabilir. Önemli olan tahmini gerçek sanmak değil, doğrulanması gereken varsayım olarak kaydetmektir.

## Gereksinimler yalnızca özellik listesi değildir

**İşlevsel gereksinim**, sistemin ne yapacağını söyler: çalışma oturumu eklemek, kaydı düzenlemek veya haftalık toplamı göstermek gibi.

**İşlevsel olmayan gereksinim**, sistemin nasıl çalışması gerektiğini tanımlar: verinin cihazda korunması, ekranın erişilebilir olması, işlemin makul sürede tamamlanması veya hassas bilginin loglanmaması gibi.

“Oturum eklenebilmeli” tek başına yeterince açık olmayabilir. Geçersiz başlık kabul edilecek mi? Kaydetme başarısız olursa kullanıcı ne görecek? Uygulama yeniden açıldığında kayıt duracak mı? Belirsizliği görünür kılmak, daha sonra yanlış beklentiler üzerine mimari kurmayı önler.

## MVP: küçük ama anlamlı ilk sürüm

**MVP (Minimum Viable Product)**, gerçek bir kullanıcı ihtiyacını karşılayan en küçük anlamlı ürün sürümüdür. “Özellikleri eksik demo” ile aynı şey değildir. MVP'nin temel kullanıcı akışı tamamlanmalı; kapsamı küçük olmalı, ancak problemi gerçekten çözmelidir.

Çalışma takibi uygulamasında şöyle bir akış MVP olabilir:

```text
Uygulamayı aç
-> çalışma oturumu ekle
-> oturumu listede gör
-> uygulamayı kapatıp aç
-> kayıt hâlâ mevcut
```

Gelişmiş grafikler, bulut senkronizasyonu, sosyal özellikler ve bildirimler kulağa çekici gelebilir. Fakat ilk sürümde eklenen her özellik; tasarım, kod, test ve mağaza hazırlığı için ek maliyet getirir. Özellik ancak ana problemi çözmek için gerekli olduğunda MVP'ye girmelidir.

Kapsam dışı fikirleri silmek gerekmez. Bunlar GitHub issue'larında “sonraki sürüm” etiketiyle tutulabilir. Böylece fikir kaybolmaz, fakat dönem hedefini de ele geçirmez.

## Kullanıcı hikâyesi ve kabul ölçütleri

Kullanıcı hikâyesi, ihtiyacı kullanıcı bakış açısından kısa biçimde anlatır:

> Bir öğrenci olarak çalışma oturumumu kaydetmek istiyorum; böylece haftalık emeğimi takip edebilirim.

Bu hikâye, “hangi paketi kullanalım?” sorusunu cevaplamaz. Bunun yerine, çözümün neden var olduğunu korur. Ardından **kabul ölçütleri** belirlenir; bunlar özelliğin tamamlandığını doğrulanabilir şekilde tarif eder:

- Başlık boşsa kayıt oluşturulmaz ve alanın yanında açıklayıcı uyarı gösterilir.
- Geçerli bir oturum kaydedildiğinde listede görünür.
- Uygulama yeniden açıldığında kayıt korunur.
- Depolama başarısız olursa kullanıcıya başarısızlık bildirilir; işlem başarılı gibi gösterilmez.

Kabul ölçütleri ürün, geliştirme ve test arasında ortak dil oluşturur. Ayrıca yapay zekâ aracına verilen isteği de netleştirir. “Bana çalışma uygulaması yap” yerine kapsam, mevcut kod yapısı, beklenen davranış ve değişmemesi gereken noktalar tarif edildiğinde önerileri değerlendirmek kolaylaşır.

## Öncelik: değer, risk ve bitirilebilirlik

Özellikleri önceliklendirirken üç eksene bakın: Kullanıcıya ne kadar değer sağlıyor? Yapılması ne kadar belirsiz veya riskli? Ayrılan sürede tamamlanabilir mi?

Özellikle dış bağımlılıklar erken kontrol edilmelidir. Bir mağaza hesabının açılması, kimlik doğrulaması veya ödeme adımı beklenenden uzun sürebilir. Kullanıcı verisi toplanacaksa gizlilik ve izin gereksinimleri kapsam kararını etkileyebilir. Bu nedenle yayın hedefi bulunan bir projede hesap ve platform koşulları son haftaya bırakılmamalıdır.

## Hangi durumda ne kadar planlama gerekir?

Kısa ömürlü bir prototip için bir sayfalık problem tanımı ve birkaç kabul ölçütü yeterli olabilir. Uzun ömürlü veya birden çok kişinin geliştirdiği ürünlerde gereksinimlerin, varsayımların ve kararların daha görünür kaydedilmesi gerekir. Her projede kapsamlı dokümantasyon şart değildir; fakat kod yazılmadan önce “kimin hangi problemini çözüyoruz?” sorusuna cevap bulunmalıdır.

Gereksinim çalışması geliştirmeyi yavaşlatan bürokrasi değil, yanlış şeyi daha hızlı inşa etmeyi önleyen bir filtredir. İyi tanımlanmış küçük bir MVP, yarım kalmış geniş bir fikirden daha çok şey öğretir.
