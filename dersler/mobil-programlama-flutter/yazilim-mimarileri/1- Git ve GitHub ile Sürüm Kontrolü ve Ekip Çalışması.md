# Git ve GitHub: Projeni Kaydet, Paylaş ve İstediğin Yerde Sürdür

Bir projeye başlarken her şey kolay görünür: Bir klasör açar, birkaç dosya oluşturur ve kod yazmaya başlarsın. Ama proje büyüdükçe şu sorular da peşinden gelir: “Geçen hafta çalışan sürüme nasıl dönerim?”, “Bu projeyi başka bilgisayarda nasıl açarım?” veya “Yaptığım değişiklikleri ekip arkadaşımla nasıl paylaşırım?”

Klasörün kopyalarını alıp adlarına “son”, “son2” ve “bu-gerçekten-son” eklemek kısa süreliğine işe yarayabilir. Sonra hangi klasörün güncel olduğu karışır; değişikliklerin ne zaman ve neden yapıldığı da belirsizleşir. Git ve GitHub, bu karmaşayı önlemek için birlikte kullanılan iki araçtır. Biri projenin geçmişini bilgisayarında tutar, diğeri bu projeyi çevrimiçi paylaşmana yardımcı olur.

Bu iki aracı öğrenmek, yalnızca birkaç komut ezberlemek demek değildir. Projendeki değişiklikleri kaydetmeyi, güvenle paylaşmayı ve başka bir bilgisayarda kaldığın yerden devam etmeyi öğrenmektir. Gel, önce aralarındaki farkı netleştirip sonra iki temel kullanım akışını birlikte tamamlayalım.

## Git ve GitHub arasındaki fark

**Git**, proje dosyalarındaki değişiklikleri takip eden bir sürüm kontrol aracıdır. Bilgisayarında çalışır ve projenin geçmişini kaydeder. Bu geçmişe eklediğin her anlamlı kayıt bir **commit** olarak adlandırılır. Git sayesinde yalnızca dosyaların bugünkü hâlini değil, önceki kayıtlarını ve aralarındaki değişiklikleri de görebilirsin.

**GitHub** ise Git projelerini çevrimiçi saklayıp paylaşabileceğin bir platformdur. Bilgisayarındaki projeyi GitHub’a gönderdiğinde, ona internet üzerinden erişebilir veya başka bir bilgisayarda çalışmaya devam edebilirsin. Ekip arkadaşlarınla aynı proje üzerinde çalışırken de değişiklikleri paylaşmak ve incelemek kolaylaşır.

Kısacası Git, bilgisayarındaki proje geçmişini yönetir; GitHub ise bu projeyi paylaşabileceğin çevrimiçi bir yer sağlar. Git tek başına, internet bağlantısı olmadan da kullanılabilir. GitHub’a değişiklik göndermek veya oradaki projeyi bilgisayarına almak içinse internet gerekir.

Bu ikiliyi kullanmanın faydası, sorun çıktığında daha belirgin hâle gelir. Yeni bir değişiklik uygulamayı bozarsa önceki commit’lere dönüp neyin değiştiğini bulabilirsin. Bilgisayarını değiştirdiğinde projeni GitHub’dan alıp sürdürebilirsin. Bir ekipte çalışıyorsan herkes yaptığı işi ortak depoya gönderebilir. GitHub tek başına yedekleme planının tamamı değildir; önemli projelerin ek yedeklerini de tutmak iyi bir alışkanlıktır.

## İlk olarak bilgisayarındaki projeyi GitHub’a gönderelim

Önce Git’in bilgisayarında kurulu olduğunu kontrol et. Terminali veya VS Code’un entegre terminalini açıp şu komutu çalıştır:

```bash
git --version
```

Bir sürüm numarası görüyorsan hazırsın. Komut bulunamazsa Git’i işletim sistemine uygun resmi kaynaktan kur. Commit’lerin kime ait olduğunu belirtmek için Git’e adını ve e-posta adresini de bir kez tanıtman gerekir:

```bash
git config --global user.name "Ad Soyad"
git config --global user.email "GitHub e-posta adresin"
```

Bu bilgiler GitHub’a giriş yapmak için kullanılmaz; commit kaydında yazar bilgisi olarak görünür. GitHub hesabında e-posta adresini gizlediysen, hesabının verdiği `noreply` adresini tercih edebilirsin.

Şimdi masaüstünde örnek bir proje klasörü oluşturalım. Mac veya Linux’ta terminale şu komutları yaz:

```bash
cd ~/Desktop
mkdir study-tracker
cd study-tracker
```

Windows kullanıyorsan masaüstüne terminalden geçebilir ya da VS Code’da **File > Open Folder** ile klasörü açabilirsin. Elinde hazır bir proje varsa yeni klasör oluşturmak yerine terminali o projenin klasöründe açman yeterli.

Proje klasörüne geçtiğinde Git’i başlat ve küçük bir tanıtım dosyası ekle:

```bash
git init -b main
echo "# Study Tracker" > README.md
```

`git init`, klasörü Git deposu hâline getirir. İlk commit'ten önce proje kökünde `.gitignore` adında bir dosya oluşturmak da iyi bir adımdır. Bu dosyaya, Git'in takip etmesini istemediğin dosya ve klasör kalıplarını yazarsın. Örneğin Flutter projesi için:

```gitignore
# Üretilen dosyalar
.dart_tool/
build/

# Yerel gizli yapılandırma
.env
*.key
```

Flutter'ın oluşturduğu `.gitignore` dosyasında genellikle gerekli kurallar zaten bulunur; yeni bir proje açtığında önce onu kontrol et. `.vscode/` veya `.idea/` gibi editör ayarlarını ekleyip eklememek projeye bağlıdır: kişisel ayarları dışarıda bırakabilir, ekipçe paylaşılan ayarları repoda tutabilirsin. Flutter uygulamalarında `pubspec.lock` dosyasını genellikle Git'e eklemek gerekir; bu dosya uygulamanın kullandığı paket sürümlerini sabitler.

`.gitignore` henüz Git'in takip etmediği dosyaları yok sayar. Bir dosya daha önce commit edildiyse, sonradan `.gitignore` içine eklemek o dosyayı geçmişten veya takibinden otomatik olarak çıkarmaz. Bu nedenle dosyayı ilk commit'ten önce kontrol etmek önemlidir.

Şimdi dosyaları ilk kayda hazırlayıp commit oluştur:

```bash
git add README.md .gitignore
git commit -m "docs: proje tanıtımı eklendi"
```

Burada `git add`, README ile `.gitignore` dosyalarını kayda hazırlar; `git commit` ise bu değişiklikleri proje geçmişine ekler. Commit mesajını “güncelleme yapıldı” gibi genel bırakmak yerine ne yaptığını anlatacak şekilde yaz. Böylece geçmişe daha sonra baktığında bu kaydın neden oluşturulduğunu anlarsın.

Sırada GitHub’da çevrimiçi bir depo açmak var. GitHub’da **New repository** seçeneğine basıp `study-tracker` adında yeni bir repo oluştur. İlk denemelerinde **Private** seçebilirsin; istersen daha sonra görünürlüğünü değiştirebilirsin. Depoyu oluştururken GitHub’ın README veya `.gitignore` eklemesini seçme. Bu dosyaları bilgisayarında zaten oluşturduğumuz için, boş bir depo ile başlamak iki ayrı geçmişin çakışmasını önler.

GitHub yeni depon için bir adres gösterecek. Aşağıdaki örnekte `KULLANICI_ADIN` yazan yeri kendi GitHub kullanıcı adınla değiştir:

```bash
git remote add origin https://github.com/KULLANICI_ADIN/study-tracker.git
git push -u origin main
```

İlk komut yerel projen ile GitHub’daki repo arasında bağlantı kurar. İkinci komut bilgisayarındaki commit’i GitHub’a gönderir. İlk gönderimde GitHub oturum açmanı isterse tarayıcı veya işletim sisteminin güvenli giriş penceresi üzerinden devam et. İşlem tamamlandığında GitHub’daki depo sayfasını yenile; `README.md` dosyanı görüyorsan proje çevrimiçi depoya ulaşmıştır.

## GitHub’daki projeyi bilgisayarına alma

Bazen projeyi başka bir bilgisayarda açmak, ekip arkadaşının projesi üzerinde çalışmak veya daha önce GitHub’a gönderdiğin projeye yeni bir cihazdan devam etmek istersin. Bunun için **clone** (klonlama) kullanılır. Klonlama projedeki dosyalarla birlikte Git geçmişini de indirir.

GitHub’da deponun sayfasını aç, **Code** düğmesine bas ve HTTPS adresini kopyala. Ardından terminalde projelerini saklamak istediğin konuma geçip `git clone` komutunu çalıştır:

```bash
cd ~/Desktop
git clone https://github.com/KULLANICI_ADIN/study-tracker.git
```

Bilgisayarında `study-tracker` adında yeni bir klasör oluşur. VS Code’da **File > Open Folder** seçeneğiyle bu klasörü açtığında projede çalışmaya başlayabilirsin. Klasörün adını kendin vermek istersen, repo adresinin sonuna yeni adı ekleyebilirsin:

```bash
git clone https://github.com/KULLANICI_ADIN/study-tracker.git benim-projem
```

Depo özelse, klonlama sırasında GitHub hesabınla yetkilendirme yapman gerekir. Başkasına ait özel bir repoya erişmek için repo sahibinin sana izin vermiş olması da gerekir.

## Yeni bir özellik için branch aç

`main`, projenin ana dalıdır. Küçük bir projede doğrudan `main` üzerinde çalışmak mümkün olsa da, yeni bir özellik veya deneme için ayrı bir **branch** (dal) açmak ana sürümü korumana yardımcı olur. Örneğin oturum ekleme formunu geliştirirken:

```bash
git switch -c feature/session-form
```

Bu komut `feature/session-form` adında yeni bir dal oluşturur ve seni o dala geçirir. Eski Git sürümlerinde aynı işi şu komutla yapabilirsin:

```bash
git checkout -b feature/session-form
```

Artık bu daldaki commit'ler `main`'den ayrı ilerler. Değişikliği tamamlayıp GitHub'a göndermek istersen:

```bash
git add .
git commit -m "feat: oturum formu eklendi"
git push -u origin feature/session-form
```

GitHub'da bu daldan `main`'e bir pull request açıp değişiklikleri inceleyebilirsin. Tek başına çalışıyorsan veya küçük bir alıştırmaysa, yerelde `main`'e geçip birleştirmen de mümkündür:

```bash
git switch main
git merge feature/session-form
```

Birleştirme tamamlandıktan sonra artık gerek olmayan yerel dalı silebilirsin:

```bash
git branch -d feature/session-form
```

`-d`, birleştirilmemiş değişiklikler varsa silmeye karşı uyarır. Bu uyarıyı görürsen dalı zorla silmek yerine önce içindeki değişikliklerin korunduğundan emin ol. Başlangıçta tek `main` dalıyla çalışmak da normaldir; proje büyüdükçe veya bağımsız işler çıktıkça branch kullanmaya başlayabilirsin.

## Projede çalışırken kullanacağın küçük rutin

Projede dosyaları değiştirdikten sonra önce Git’in neleri fark ettiğine bak:

```bash
git status
```

Bu komut yeni ve değişmiş dosyaları gösterir. Her şey beklediğin gibiyse değişiklikleri hazırla, commit oluştur ve GitHub’a gönder:

```bash
git add .
git commit -m "feat: çalışma oturumu eklendi"
git push
```

`git add .` klasördeki bütün yeni ve değişmiş dosyaları seçebilir. Bu yüzden commit’ten önce `git status` çıktısını incele; parolaların, kişisel dosyaların veya projeyle ilgisi olmayan değişikliklerin seçilmediğinden emin ol. Özellikle erişim token’ı, özel anahtar ve imzalama dosyaları repoya gönderilmemelidir.

İlk başta bu adımlar birkaç ek işlem gibi görünebilir. Bir süre sonra ise projenin hangi hâlinin kaydedildiğini ve GitHub’a gönderilip gönderilmediğini her zaman bilirsin. Bir değişiklik sorun çıkardığında da “hangi klasör doğruydu?” diye tahmin yürütmek yerine commit geçmişini inceleyebilirsin.

## Kısaca

```text
Bilgisayardaki proje -> git init -> commit -> GitHub'da boş repo -> push
GitHub'daki proje -> clone -> bilgisayarında yeni klasör
```

Git, proje geçmişini bilgisayarında tutar; GitHub bu projeyi çevrimiçi paylaşmana ve başka bir bilgisayardan sürdürmene yardımcı olur. Önce masaüstündeki projeyi GitHub’a göndermeyi, ardından GitHub’daki projeyi bilgisayarına klonlamayı dene. Bu iki akış, Git ve GitHub’la çalışmaya başlamak için sağlam bir temel sunar.

## Kaynaklar

- [Git'i indir](https://git-scm.com/downloads)
- [GitHub Docs: Git nedir?](https://docs.github.com/en/get-started/using-git/about-git)
- [GitHub Docs: Depo oluşturma](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository)
- [GitHub Docs: Depo klonlama](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
