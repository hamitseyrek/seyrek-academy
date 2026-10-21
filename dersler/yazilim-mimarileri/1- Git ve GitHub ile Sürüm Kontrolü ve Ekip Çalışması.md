# Git ve GitHub: Kodun Hafızasını Kurmak ve Ekipçe Geliştirmek

*Bir uygulamanın her değişikliğini güvenle izlemek, yanlış kararları geri alabilmek ve yeni özellikleri ana sürümü bozmadan geliştirmek için Git ile GitHub nasıl birlikte kullanılır?*

Bir uygulama geliştirirken ilk sürüm genellikle basittir. Birkaç dosya, çalışan bir ekran ve “şimdilik böyle kalsın” diye bırakılan bir kopya yeterli görünür. Sonra yeni bir özellik eklenir, eski bir davranış bozulur, değişiklik geri alınmaya çalışılır. Masaüstünde `proje_son`, `proje_son2`, `proje_bu_gercekten_son` klasörleri çoğalmaya başlar.

Sorun, geliştiricinin dikkatsiz olması değildir. Sorun, değişikliklerin güvenilir bir geçmişinin bulunmamasıdır.

**Sürüm kontrolü**, dosyalardaki değişiklikleri düzenli biçimde kaydeder. Böylece kodun yalnızca bugünkü hâli değil, o hâle nasıl geldiği de anlaşılır. Git bu geçmişi yöneten araçtır. GitHub ise Git depolarını çevrimiçi barındırmanın yanı sıra değişiklikleri incelemek, işleri takip etmek ve ekipçe geliştirmek için bir çalışma alanı sunar.

Git'i yalnızca bir dizi terminal komutu olarak öğrenmek, konunun yarısını kaçırmaktır. Asıl değer, her değişikliği küçük ve anlamlı bir karara dönüştürmek; bu kararları paylaşılabilir, incelenebilir ve gerektiğinde geri alınabilir kılmaktır.

## Önce çözülen probleme bakalım

Bir mobil uygulamada aynı anda birçok şey değişir: yeni bir ekran eklenir, form doğrulaması güncellenir, bir hata düzeltilir, paket sürümü yükseltilir. Değişikliklerin kaydı yoksa şu sorular kısa sürede yanıtsız kalır:

- Hata hangi değişiklikten sonra başladı?
- Geçen hafta çalışan sürüme nasıl dönülür?
- Yeni eklenen kod neden var?
- Bir ekip arkadaşının değişikliği benimkini etkiler mi?
- Yayınlanan sürümde tam olarak hangi kod bulunuyor?

Dosyaları kopyalamak bu soruları çözmez. Kopyalar hangi dosyanın doğru sürüm olduğunu belirsizleştirir; üstelik değişikliklerin neden yapıldığını açıklamaz. Ekran görüntüsü veya bulut yedeklemesi de kodun geçmişini, dallarını ve inceleme sürecini tutmaz.

Git, bu değişiklik geçmişini projenin içinde yönetir. Her kayıt bir zaman çizelgesindeki anlamlı bir durak gibidir. Bir özelliği denerken çalışan sürüm kaybolmaz; sorun bulunursa değişikliğin nerede ve neden yapıldığı araştırılabilir.

## Git ile GitHub aynı şey değil

Bu iki isim çoğu zaman birlikte kullanılır; ancak farklı işleri yaparlar.

**Git**, bilgisayarda çalışan dağıtık bir sürüm kontrol sistemidir. Projenin geçmişini yerel depoda tutar. Commit oluşturmak, dal açmak veya geçmişi incelemek için internet bağlantısı gerekmez.

**GitHub**, Git depolarının uzakta barındırılmasını sağlayan bir platformdur. Repo (repository/depo) barındırmanın yanında issue, pull request ve kod inceleme gibi ekip araçlarını sunar. GitHub, Git'in kendisi değildir; Git ile çalışan platformlardan biridir.

Bir projede bu farkı şöyle düşünebiliriz:

```text
Git: değişiklik geçmişini yerelde kaydeder
GitHub: bu geçmişi paylaşmayı ve birlikte çalışmayı sağlar
```

GitHub hesabı açmak, Git öğrenmek anlamına gelmez. Tersi de doğrudur: GitHub kullanmadan yerel bir Git deposuyla çalışılabilir. Ancak başkalarıyla çalışmak, depoyu başka bir bilgisayarda sürdürmek veya değişiklikleri incelemek için GitHub gibi bir uzak platform gerekir.

## Git'in çalışma alanı: değişiklikten commit'e

Git ile çalışırken üç yeri ayırt etmek yeterlidir:

1. **Working tree (çalışma ağacı):** Dosyaların düzenlendiği proje klasörü.
2. **Staging area (hazırlık alanı):** Bir sonraki kayda dahil edilmek üzere seçilmiş değişiklikler.
3. **Repository (depo):** Commit'lerin, yani kaydedilmiş proje geçmişinin bulunduğu yer.

Akış şu şekildedir:

```text
Dosyayı düzenle -> değişikliği seç -> commit oluştur -> GitHub'a gönder
```

Aradaki hazırlık alanı ilk başta fazladan bir adım gibi görünebilir. Aslında değişikliğin hangi parçalarının birlikte kaydedileceğini seçmeye yarar. Örneğin aynı oturumda bir form hatası düzeltilmiş ve uygulama ikonuyla ilgili dosyalar değiştirilmiş olabilir. Bunlar bağımsız işlerse tek bir commit'e karıştırmak yerine ayrı ayrı kaydetmek daha anlamlıdır.

Sık kullanılan temel komutlar:

```bash
git status
git diff
git add lib/main.dart
git diff --staged
git commit -m "feat: çalışma oturumu formu eklendi"
git log --oneline
```

`git status`, hangi dosyaların değiştiğini ve hangilerinin hazırlık alanına alındığını gösterir. `git diff`, henüz seçilmemiş değişiklikleri; `git diff --staged` ise commit'e girmeye hazır olanları gösterir. `git add`, dosyanın o andaki değişikliklerini hazırlık alanına alır. `git commit` seçilmiş değişiklikleri mesajıyla birlikte geçmişe kaydeder. `git log` geçmiş kayıtları listeler.

`git add` dosyayı kalıcı olarak kilitlemez; o anki içeriğini hazırlık alanına alır. Dosya daha sonra yeniden düzenlenirse, son değişikliğin de commit'e girmesi için `git add` tekrar çalıştırılmalıdır.

Bu nedenle güvenli bir alışkanlık, her önemli işlemden önce `git status` çalıştırmak ve commit'ten önce diff'i gözden geçirmektir. `git add .` yararlı bir kısayol olabilir; ancak projedeki her değişikliği seçtiğini bilmeden kullanmak istemeden kişisel veya geçici dosyaları commit'e dahil edebilir.

## Depoyu kurmak ve ilk kaydı almak

Yeni bir proje klasöründe Git deposu şöyle başlatılabilir:

```bash
mkdir study-tracker
cd study-tracker
git init -b main
```

`git init`, klasörde Git geçmişini oluşturur. `-b main`, başlangıç dalına `main` adını verir. Ardından projeyi tanıtan bir `README.md` eklenip ilk commit alınabilir:

```bash
git add README.md
git diff --staged
git commit -m "docs: proje açıklaması eklendi"
```

Git, commit'lere isim ve e-posta iliştirir. Bu bilgiler GitHub hesabına giriş bilgileri değildir; commit'in yazarı hakkında yerel Git yapılandırmasında tutulan bilgilerdir. GitHub hesabının e-posta gizliliği tercihleri dikkate alınarak yapılandırılmalıdır. Giriş ve gönderim yetkilendirmesi ise HTTPS kimlik doğrulaması veya SSH anahtarı gibi ayrı bir mekanizmayla yapılır.

Git yazar bilgisi henüz ayarlanmamışsa, bilgisayardaki tüm depolarda kullanılacak değerler şöyle tanımlanabilir:

```bash
git config --global user.name "Ad Soyad"
git config --global user.email "you@example.com"
```

`--global` seçeneği bu bilgisayardaki bütün depolar için geçerlidir; yalnızca mevcut projeye özel bir kimlik gerekiyorsa seçenek kaldırılıp proje deposunda komutlar çalıştırılabilir. GitHub hesabının e-posta gizliliği açıksa, commit'lerde paylaşılmasına izin verilen veya GitHub'ın sağladığı noreply adresi kullanılmalıdır.

Commit mesajı, değişikliğin amacını kısa biçimde anlatmalıdır. `güncelleme yapıldı` yerine `fix: boş oturum başlığı engellendi` gibi bir mesaj, aylar sonra bile kaydın neden oluşturulduğunu anlamayı kolaylaştırır. Mesaj biçimi ekipçe kararlaştırılabilir; önemli olan tutarlılık ve açıklıktır.

## GitHub'a gönderme: yerel repo ve uzak repo

Yerel Git deposunun GitHub'daki kopyasına **remote** (uzak depo) denir. `origin`, bu uzak depo için yaygın kullanılan addır; özel bir Git komutu değildir.

Yeni GitHub deposu oluştururken, ilk adımda GitHub'ın ayrıca README veya lisans dosyası oluşturmasını seçmemek işleri kolaylaştırır. Böylece yerel ve uzak depoların başlangıç geçmişleri ayrı ayrı yaratılmaz. Boş uzak repo oluşturulduktan sonra:

```bash
git remote add origin https://github.com/USERNAME/study-tracker.git
git remote -v
git push -u origin main
```

`git remote add` uzak adresi yerel depoya tanıtır. `git remote -v` adresi doğrular. `git push` yerel commit'leri GitHub'a gönderir. `-u`, yerel `main` dalıyla uzak `main` dalı arasındaki ilişkiyi kurar; sonraki gönderimlerde çoğunlukla yalnızca `git push` yazmak yeterli olur.

İlk push sırasında GitHub kimlik doğrulaması isteyebilir. GitHub, Git işlemlerinde hesap parolasını kullanmayı desteklemez; işletim sisteminin credential manager'ı üzerinden HTTPS yetkilendirmesi veya SSH anahtarı kullanılabilir. Erişim token'ı, parola ya da özel anahtar hiçbir zaman remote adresine yazılmamalı veya kaynak kodla paylaşılmamalıdır.

GitHub deposu README gibi dosyalarla önceden başlatıldıysa yerel depoyla uzak deponun geçmişleri farklı olabilir. Bu durumda `push` reddedilebilir. Yeni başlayanlar için en temiz yol, önce GitHub'daki depoyu `git clone` ile bilgisayara indirmek ve çalışmayı bu kopyada sürdürmektir. İki ayrı başlangıç geçmişini rastgele birleştirmek yerine depo oluşturma yöntemini en başta seçmek daha güvenlidir.

## Commit, push, fetch ve pull: farkları

Bu komutlar birbirinin yerine kullanılamaz:

- **Commit**, seçilen değişikliği yerel geçmişe kaydeder. İnternet bağlantısı gerekmez.
- **Push**, yerel commit'leri uzak depoya gönderir.
- **Fetch**, uzak depodaki yeni kayıtları indirir ancak mevcut dalı kendi başına birleştirmez.
- **Pull**, uzak değişiklikleri indirip mevcut dala entegre eder.

Örneğin bir ekip arkadaşının değişiklikleri GitHub'a gönderilmişse, o değişiklikler bilgisayardaki projeye kendiliğinden gelmez. `git pull` ile alınabilir. Yeni bir dala başlamadan önce uzak değişiklikleri almak, gereksiz çakışma riskini azaltır:

```bash
git switch main
git pull
```

Komutlar farklı depolara veya dallara çalıştırılırsa farklı sonuç doğurabileceğinden, önce `git status` ile doğru depoda ve dalda olunduğunu kontrol etmek iyi bir alışkanlıktır.

## Branch: ana sürümü bozmadan çalışmak

`main` dalı genellikle projenin birlikte çalıştığı, gözden geçirilmiş ana sürümünü temsil eder. Yeni bir özellik veya düzeltme üzerinde çalışırken ayrı bir **branch (dal)** açılır:

```bash
git switch -c feature/session-form
```

Dal, var olan geçmişin üzerine açılan ayrı bir çalışma çizgisidir. Bu sayede form geliştirilirken `main` dalındaki çalışan sürüm değişmeden kalır. İş bittiğinde dal GitHub'a gönderilir:

```bash
git add lib/
git commit -m "feat: çalışma oturumu formu eklendi"
git push -u origin feature/session-form
```

Dal adları yapılan işi tanımlarsa listeyi okumak kolaylaşır: `feature/session-form`, `fix/empty-title-validation` veya `docs/setup-guide`. Takımın dal adlandırma kuralı olabilir; isim ne olursa olsun her dalın tek, anlaşılır bir amacı bulunması yararlıdır.

Branch kullanmak, küçük ve kişisel projelerde bile değerlidir. Bir özellik beklenildiği gibi ilerlemezse ana sürüm korunur. Ekiplerde ise farklı dallarda eşzamanlı çalışma mümkün olur; tamamlanan işler incelenerek birleştirilir.

## Pull request: değişikliği birleştirmeden önce incelemek

Bir dal GitHub'a gönderildikten sonra **pull request (PR)** açılabilir. Pull request, “bu değişiklikleri ana dala alalım” isteğinin yanı sıra kod inceleme ve tartışma alanıdır. PR üzerinde değişen dosyalar, satırlar, test sonuçları ve açıklamalar görülebilir.

Anlaşılır bir PR şunları yanıtlar:

- Ne değişti?
- Bu değişiklik hangi ihtiyacı karşılıyor?
- Nasıl test edildi?
- Görsel bir değişiklik varsa ekran görüntüsü veya kısa kayıt var mı?

Örnek akış:

```text
main -> özellik dalı -> küçük commit'ler -> push -> pull request
     -> inceleme ve test -> düzeltme -> merge
```

PR incelemesi kişiyi değil, değişikliği değerlendirir. İnceleyen kişi “bu neden böyle?” diye sorabilir; kodu yazan kişi de gerekçeyi açıklayabilir veya daha iyi bir çözüm bulabilir. Böylece kod bilgisi ekipte paylaşılır, hata ana dala girmeden yakalanabilir.

Tek başına geliştirilen projede de PR açmak faydalıdır: değişiklik ana dala girmeden önce diff'i başka bir bağlamda inceleme fırsatı verir. Ancak bu süreç bürokrasiye dönüşmemelidir. Küçük bir ödevde bir PR açıklaması ve kendi incelemesi yeterli olabilir; kritik veya ortak kullanılan kodda ikinci bir inceleyici daha değerlidir.

## Issue: yapılacak işi küçük ve görünür tutmak

GitHub **issue**'ları özellik, hata, soru veya teknik kararları takip eder. “Uygulamayı geliştir” tamamlanabilir bir iş değildir. “Oturum ekleme formunda başlık boşsa kayıt oluşturma ve alan altında uyarı göster” daha net bir issue'dur.

İyi bir issue, neden gerekli olduğunu ve ne zaman tamamlanmış sayılacağını anlatır. Kabul ölçütleri küçük, doğrulanabilir maddeler olabilir. PR açıklamasında issue'ya bağ kurulduğunda, tamamlanan iş ile yapılan kod değişikliği arasında izlenebilirlik oluşur.

Issue'ları yalnızca hata listesi gibi düşünmemek gerekir. Kullanıcı ihtiyacı, ürün kararı ve sonraki sürüm fikri de issue olarak tutulabilir. Böylece fikirler sohbet geçmişinde kaybolmaz ve dönem projesinin kapsamı görünür kalır.

## Merge conflict: iki değişiklik aynı yeri istediğinde

İki dal aynı dosyanın aynı satırlarını farklı biçimde değiştirmişse Git hangi değişikliğin kalması gerektiğini bilemez. Buna **merge conflict** (birleştirme çakışması) denir. Bu, Git'in bozulduğu anlamına gelmez; insan kararına ihtiyaç olduğunu bildirir.

Dosyada şöyle işaretler görülebilir:

```text
<<<<<<< HEAD
final title = 'Çalışma oturumları';
=======
final title = 'Oturumlarım';
>>>>>>> feature/session-title
```

İşaretlerin üstündeki ve altındaki metin, iki tarafın önerdiği değişiklikleri gösterir. Çözüm, taraflardan birini gelişigüzel silmek değil; ürünün beklenen davranışına göre doğru sonucu oluşturmaktır. Bazen bir taraf seçilir, bazen iki değişiklik birleştirilir. Sonrasında işaretler kaldırılır, dosya çalıştırılıp test edilir ve çözüm commit edilir.

Çakışma olasılığını azaltmanın yolları:

- Küçük ve kısa ömürlü dallar kullanmak.
- Başlamadan önce `main` dalındaki güncel değişiklikleri almak.
- Aynı dosyada paralel çalışan ekip üyelerinin iletişim kurması.
- PR'ları küçük ve tek amaçlı tutmak.

Conflict çıkması olağandır; önemli olan çözümü anlamadan “ours” veya “theirs” seçeneğine basmamaktır.

## Hangi durumda nasıl bir akış seçilmeli?

| Durum | Uygun yaklaşım |
|---|---|
| Yeni fikir veya kısa deneme | Ayrı bir dalda denenebilir; değer üretmiyorsa ana dala birleştirilmesi gerekmez. |
| Tek kişinin küçük ve kısa ömürlü projesi | Küçük commit'ler, uzak depoya düzenli push ve ihtiyaca göre PR kullanılabilir. |
| Birkaç kişinin birlikte geliştirdiği uygulama | İşler issue ile tanımlanabilir; özellik dalları PR ile incelenip birleştirilebilir. |
| Yayınlanan uygulama veya kritik değişiklik | `main` dalı korunabilir; test ve inceleme tamamlanmadan release oluşturulmamalıdır. |
| Üzerinde çalışılmayan arşiv veya yalnızca statik dosyalar | Git yine geçmiş ve değişiklik takibi sağlar; ekip araçlarına ihtiyaç yoksa GitHub süreci daha yalın tutulabilir. |

Branch ve PR her durumda aynı ölçüde yararlı değildir. Tek dosyalık, tek seferlik bir denemede gereksiz süreç yaratabilir. Buna karşılık, kişisel bir projede dahi ana uygulamaya özellik eklenirken veya ekipçe çalışılırken inceleme ve ayrıştırma önemli bir güvenlik ağı sağlar. İhtiyaç büyüdükçe süreç genişletilmeli; sürecin kendisi ürünün önüne geçmemelidir.

## Sık görülen hatalar ve güvenli alışkanlıklar

### Her şeyi düşünmeden commit'e eklemek

`git add .` komutu bütün değişiklikleri hazırlık alanına alabilir. Önce `git status` ve `git diff` ile hangi dosyaların ekleneceği incelenmelidir. Özellikle derleme çıktıları, IDE ayarları ve yerel yapılandırma dosyaları repoya gerekmeyebilir.

### `.gitignore` dosyasını güvenlik kasası sanmak

`.gitignore`, Git'in henüz izlemeye almadığı dosyaları yeni commit'lere eklemesini önler. Daha önce commit edilmiş bir dosyayı otomatik olarak geçmişten silmez. Bir API anahtarı veya parola repoya gönderildiyse dosyayı silmek yeterli değildir; anahtar iptal edilip yenilenmeli ve gerekirse repo geçmişi için güvenlik prosedürü uygulanmalıdır.

### Commit'leri çok büyük veya belirsiz tutmak

Bir commit'e ilgisiz özellik, hata düzeltmesi ve biçimlendirme değişikliği eklenirse inceleme ve geri alma zorlaşır. Küçük, tek amaçlı commit'ler sorunların kaynağını bulmayı ve belirli bir değişikliği geri almayı kolaylaştırır.

### Push'u yedekleme stratejisiyle karıştırmak

Uzak depoya push etmek kod geçmişinin bir kopyasını başka yerde tutar; yine de kurumsal yedekleme, erişim yönetimi veya hassas veri saklama politikasının yerini almaz. GitHub'a eklenen içerik, depo erişimi olan kişilere ve repo görünürlüğüne bağlı olarak paylaşılabilir. Depoyu `public` yapmadan önce dosyaları ve geçmişi incelemek gerekir.

### Gizli bilgi veya gerçek kullanıcı verisi göndermek

Parolalar, erişim token'ları, özel anahtarlar ve gerçek kullanıcı verileri Git geçmişine eklenmemelidir. `.gitignore` ve örnek yapılandırma dosyaları yardımcıdır; fakat istemci uygulamasına derlenen bir anahtar gizli sayılamaz. Bir değer mobil uygulama paketine gömülüyorsa uygulama incelenerek çıkarılabilir. Gerçek gizli anahtarlar sunucu tarafında tutulmalı ve erişim kapsamı sınırlandırılmalıdır.

### Ana dalda doğrudan ve doğrulanmamış değişiklik yapmak

Küçük kişisel projede `main` üzerinde çalışmak mümkün olsa da, özellik dalı ve PR kullanmak değişikliği daha görünür kılar. Takımda `main` dalı korumaya alınabilir; testler ve gerekli inceleme tamamlanmadan merge engellenebilir.

## Başlamak için önerilen küçük rutin

Her yeni işte mevcut durumu kontrol etmek, ayrı bir dalda çalışmak, değişiklikleri incelemek ve anlamlı kayıtlar oluşturmak güvenli bir başlangıç sağlar:

```bash
git status
git switch main
git pull
git switch -c feature/meaningful-name
```

İş ilerledikçe küçük commit'ler alınabilir. Tamamlandığında diff incelenir, dal GitHub'a gönderilir ve PR açılır. PR birleştirildikten sonra `main` güncellenir; sıradaki iş için yeni bir dal açılır.

Bu akış, kod yazmanın yerine geçmez. Kodun nasıl değiştiğini anlaşılır kılar. Bir ekipte güven, “kimse hata yapmaz” varsayımından değil; hatanın fark edilebildiği, etkisinin sınırlanabildiği ve çözümün geçmişte izlenebildiği bir süreçten doğar.

## Kaynaklar

- [Pro Git kitabı](https://git-scm.com/book/en/v2)
- [GitHub Docs: Git hakkında](https://docs.github.com/en/get-started/using-git/about-git)
- [GitHub Docs: GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow)
- [GitHub Docs: Pull request'ler üzerinde birlikte çalışma](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests)
- [GitHub Docs: Dosyaları yoksaymak](https://docs.github.com/en/get-started/git-basics/ignoring-files)
- [GitHub Docs: GitHub'da kimlik doğrulama](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/about-authentication-to-github)
