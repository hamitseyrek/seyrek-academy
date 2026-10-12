# Kodunuzu Kaybetmeden Çalışmak: Git ve GitHub’a Sıfırdan Giriş

**Projenizi “v1”, “v2”, “son_hali_final” klasörleriyle taşımak yerine tek bir yerde tutup her değişikliği kayıt altına almak istiyorsanız, Git tam size göre. Bu yazıda Git’in ne olduğu, neden kullanıldığı ve GitHub ile birlikte nasıl kullanıldığı baştan sona anlatılıyor.**

---

“Dosyayı yanlışlıkla sildim.” “Bu hali çalışıyordu, ne değiştirdim bilmiyorum.” “Grup projesinde herkes farklı dosya atıyor, birleştiremiyoruz.” Bu cümleler tanıdık geliyorsa, **sürüm kontrolü** (version control) tam da bu problemleri çözmek için var. **Git**, dünyada en yaygın kullanılan sürüm kontrol sistemidir; **GitHub** ise Git depolarınızı internet üzerinde saklayıp başkalarıyla paylaşabileceğiniz bir platformdur. İkisini birlikte kullanınca hem kodunuz güvende olur hem de ekip çalışması ve portfolyo paylaşımı kolaylaşır.

Bu yazıda Git ve GitHub’ı kavramlar, temel komutlar ve günlük kullanımda işinize yarayacak pratik bilgiler adım adım ele alınıyor.

**Bu yazıda neler var?**
- Sürüm kontrolü nedir, neden gerekli?
- Git nedir, GitHub ile farkı ne?
- Repository, commit, branch kavramları
- Git kurulumu ve ilk ayarlar
- Temel akış: clone, add, commit, push, pull
- Branch oluşturma ve birleştirme
- .gitignore ve “hangi dosyalar takip edilir?”
- Sık karşılaşılan durumlar ve öneriler

---

## Neden “Sürüm Kontrolü”?

Kod yazarken her şeyi tek bir klasörde tutarsanız, bir değişiklik yaptığınızda “önceki hali” geri getirmek zor olur. Çoğu kişi ya dosyaları kopyalayıp “proje_v2”, “proje_final” diye klasörler açar ya da sadece “umarım bozmam” der. **Sürüm kontrolü**, projenizin her anını **kayıt** (commit) olarak saklar: “Bu anda ne değişti, kim ne yazdı?” bilgisiyle. İstediğiniz anda eski bir kayda dönebilir, iki farklı geliştirme kolunu (branch) sonra birleştirebilirsiniz. Tek kişi de olsanız ekip de olsanız, kodun tarihi ve güvenliği elinizde olur.

---

## Git Nedir? GitHub Nedir?

**Git**, bilgisayarınızda çalışan bir **sürüm kontrol sistemi**dir. Proje klasörünüzü bir “depo” (repository) yapar; siz her “commit” attığınızda o anki değişiklikler bir kayıt olarak saklanır. Komut satırından veya görsel araçlarla (VS Code, GitHub Desktop vb.) kullanırsınız.

**GitHub**, Git depolarını **internette** barındıran bir servistir. Kodunuzu GitHub’a gönderir (push) veya oradan indirir (clone/pull) siniz. Böylece:
- Proje yedeklenmiş olur,
- Başkalarıyla paylaşabilir veya birlikte geliştirebilirsiniz,
- Özgeçmişinizde “GitHub profilim” diyerek projelerinizi gösterebilirsiniz.

Özetle: **Git** = sürüm kontrolü aracı (yerel), **GitHub** = Git depolarını barındıran ve paylaşımı kolaylaştıran platform (uzak sunucu).

---

## Temel Kavramlar

- **Repository (depo)**: Projenizin Git ile takip edildiği klasör. İçinde `.git` adında gizli bir klasör vardır; tüm sürüm bilgisi orada tutulur.
- **Commit (kayıt)**: Belirli bir anda yaptığınız değişikliklerin “anlık görüntüsü”. Her commit bir mesaj (örn. “Login ekranı eklendi”) ile tanımlanır.
- **Branch**: Paralel geliştirme kolu. Varsayılan branch genelde `main` veya `master`’dır. Yeni bir özellik için `feature/login` gibi branch açıp sonra `main` ile birleştirebilirsiniz.
- **Remote (uzak depo)**: Genelde GitHub’daki deponun adresi. Projeniz “yerel” bilgisayarınızda, bir kopyası da “uzak”ta (GitHub’da) durur.
- **Push**: Yerel commit’lerinizi uzak depoya göndermek.
- **Pull**: Uzak depodaki yeni commit’leri yereline çekmek.

Aşağıda bu kavramlar komutlarla somutlaştırılıyor.

---

## Git Kurulumu ve İlk Ayar

**Kurulum:** `https://git-scm.com` adresinden işletim sisteminize uygun sürümü indirip kurun. Kurulum sonrası terminalde şunu yazın:

```bash
git --version
```

Sürüm numarası görünüyorsa kurulum tamamdır.

Commit’lerde “kim yaptı” bilgisi için adınız ve e-posta adresinizi Git’e tanıtmanız gerekir. **Tüm projeler** için geçerli olacak şekilde:

```bash
git config --global user.name "Adınız Soyadınız"
git config --global user.email "sizin@email.com"
```

GitHub’da kullandığınız e-postayı yazmanız, commit’lerin profilinizle eşleşmesi açısından faydalıdır.

---

## İlk Depo: Yeni Proje veya Var Olan Klasör

**Seçenek 1 — Sıfırdan yeni proje:**

```bash
mkdir my_app
cd my_app
git init
```

`git init` bu klasörü bir Git deposu yapar (içinde `.git` oluşur).

**Seçenek 2 — Zaten kodunuz var:**

Proje klasörünüzün içine girip:

```bash
cd mevcut_proje
git init
```

yeterli. Bu noktada henüz hiçbir dosya “takip altında” değildir; onu bir sonraki adımda yapacağız.

---

## İlk Commit: Hangi Dosyalar “Takip Edilsin”?

Git, depodaki **her dosyayı** otomatik takip etmez. Siz hangi değişiklikleri “şimdi kayda alacağım” diye işaretlerseniz, sadece onlar commit’e girer.

1. **Durumu görmek:**
   ```bash
   git status
   ```
   “Untracked files” (izlenmeyen dosyalar) veya “Changes not staged” (henüz sahneye alınmamış değişiklikler) listelenir.

2. **Commit’e dahil etmek istediğiniz dosyaları “staged” (sahneye) almak:**
   ```bash
   git add dosya.dart
   git add lib/
   ```
   veya **tüm değişiklikleri** eklemek için:
   ```bash
   git add .
   ```
   (Nokta = bu klasör ve altındaki her şey.)

3. **İlk kaydı (commit) oluşturmak:**
   ```bash
   git commit -m "İlk commit: proje iskeleti"
   ```
   `-m` sonrasındaki metin, bu commit’in kısa açıklamasıdır. Anlamlı mesajlar yazmak, ileride “o değişiklik neydi?” dediğinizde çok işinize yarar.

Bu noktada değişiklikleriniz **sadece kendi bilgisayarınızda** kayıtlı. Bunları GitHub’a göndermek için önce GitHub’da bir depo oluşturup, sonra “uzak depo”yu bağlayacağız.

---

## GitHub’da Depo Oluşturma ve Bağlama

1. `https://github.com` adresine gidin, giriş yapın.
2. Sağ üstten **New repository** (veya “+” → New repository) seçin.
3. Repository adı verin (örn. `my_flutter_app`). Public seçin; **Create repository** deyin.
4. GitHub size bir adres gösterir, örneğin:  
   `https://github.com/kullanici_adiniz/my_flutter_app.git`

**Bu adresi yerel deponuza “remote” olarak ekleyin:**

```bash
git remote add origin https://github.com/kullanici_adiniz/my_flutter_app.git
```

“origin” uzak depo için kullandığımız standart isimdir. İlk kez gönderirken branch adınız `main` olmalı (GitHub’ın yeni varsayılanı). Eğer yerelde branch adınız `master` ise:

```bash
git branch -M main
```

Sonra commit’lerinizi GitHub’a gönderin:

```bash
git push -u origin main
```

`-u` bir kez kullanırsanız, sonraki seferlerde sadece `git push` yazmanız yeterli olur. Tarayıcıda GitHub sayfanızı yenilediğinizde kodunuzu orada görürsünüz.

---

## Günlük Akış: Değiştir → Ekle → Commit → Push

Projede çalışırken tekrarlayacağınız döngü kabaca şöyle:

1. Dosyaları düzenleyin (kod yazın).
2. Ne değişti görmek için:
   ```bash
   git status
   ```
3. Commit’e almak istediğiniz değişiklikleri ekleyin:
   ```bash
   git add .
   ```
   veya sadece belirli dosyalar: `git add lib/main.dart` vb.
4. Kayıt oluşturun:
   ```bash
   git commit -m "Login ekranı eklendi"
   ```
5. GitHub’a yollayın:
   ```bash
   git push
   ```

Eğer başka bir bilgisayarda veya ekip arkadaşınız aynı depoda çalışıyorsa, önce onların yolladığı değişiklikleri almanız gerekir:

```bash
git pull
```

Böylece yerel deponuz, uzaktaki son commit’lerle güncel kalır. Çakışma (conflict) olursa Git size hangi dosyalarda olduğunu söyler; bu konu için daha sonra ayrı bir çalışma yapılabilir.

---

## Başkasının Projesini İndirmek: clone

GitHub’da gördüğünüz bir projeyi kendi bilgisayarınıza almak için **`git clone`** komutunu kullanırsınız. Proje sayfasında yeşil **Code** butonuna tıklayıp adresi kopyalayın, sonra:

```bash
git clone https://github.com/kullanici/proje_adi.git
```

Bu komut, o depoyu aynı isimle bir klasör olarak indirir ve içinde zaten `origin` uzak depo tanımlı olur. Kendi değişikliklerinizi yapıp commit/push etmek için o depoda yazma yetkiniz olması gerekir (genelde kendi fork’unuz veya size verilen erişim).

---

## Branch: Paralel Geliştirme

Varsayılan branch `main`’dir. Yeni bir özellik veya deneme yaparken ayrı bir branch açmak, `main`’i bozmamanızı sağlar.

**Yeni branch oluşturup o branche geçmek:**

```bash
git checkout -b feature/login
```

veya (yeni Git sürümlerinde):

```bash
git branch feature/login
git switch feature/login
```

Bu branch’teki commit’leri yaptıktan sonra, branch’i `main` ile birleştirmek için önce `main`’e geçin:

```bash
git switch main
git merge feature/login
```

Birleştirme sonrası `main` artık `feature/login`’deki tüm değişiklikleri içerir. İsterseniz bu branch’i silebilirsiniz:

```bash
git branch -d feature/login
```

Başlangıçta tek branch (`main`) ile de rahatça çalışabilirsiniz; branch’e proje büyüdükçe veya ekip çalışmasında ihtiyaç duydukça geçebilirsiniz.

---

## Hangi Dosyalar Takip Edilmesin? .gitignore

Derlenen dosyalar, IDE ayarları veya ortam değişkenleri gibi şeyleri Git’e eklemek istemezsiniz. Bunun için proje kökünde **`.gitignore`** dosyası oluşturursunuz. Bu dosyada yazdığınız kalıplar, `git add` yapılsa bile commit’e **alınmaz**.

**Örnek .gitignore (Flutter/Dart için kısa):**

```gitignore
# IDE
.idea/
.vscode/
*.iml

# Build / dependency
build/
.dart_tool/
pubspec.lock

# Ortam / gizli
.env
*.key
```

- Satır başı `#` yorum satırıdır.
- `build/` = `build` klasörü ve içi yok sayılır.
- `.env` = kökteki `.env` dosyası takip edilmez.

`.gitignore`’u kendiniz oluşturup commit’leyebilirsiniz; böylece projeyi klonlayan herkes aynı kuralları kullanır.

---

## Sık Karşılaşılan Durumlar

- **“Zaten commit’ledim ama mesajı yanlış yazdım.”**  
  Son commit’in mesajını değiştirmek (henüz push etmediyseniz):
  ```bash
  git commit --amend -m "Doğru mesaj"
  ```

- **“Son commit’i geri almak istiyorum, ama değişiklikler dosyalarda kalsın.”**  
  ```bash
  git reset --soft HEAD~1
  ```
  Son commit iptal olur, değişiklikler “staged” halde kalır; mesajı düzeltip tekrar commit edebilirsiniz.

- **“Uzakta (GitHub’da) benim bilmediğim commit’ler var.”**  
  Önce uzaktakileri alın:
  ```bash
  git pull
  ```
  Gerekirse merge veya conflict çözümü yapılır; sonra `git push` edebilirsiniz.

- **“Hangi commit’ler var?”**  
  ```bash
  git log --oneline
  ```
  Kısa liste görürsünüz. `q` ile çıkarsınız.

---

## Öneriler

- **Sık ve anlamlı commit:** Küçük, tek konulu commit’ler; mesajda “ne yaptım” kısa ve net olsun.
- **Push’tan önce pull:** Ekip çalışıyorsanız push etmeden önce `git pull` alışkanlık haline getirin.
- **.gitignore kullanın:** Build çıktıları, gizli dosyalar ve gereksiz dosyalar depoya girmesin.
- **main’i koruyun:** Denemelerinizi mümkünse branch’te yapıp, beğendiğinizde merge edin.

---

## Sonuç

Git, kodunuzun her adımını kayıt altına almanızı; GitHub ise bu kayıtları güvenle saklayıp paylaşmanızı sağlar. İlk başta “commit”, “push”, “pull” terimleri karışık gelebilir; birkaç küçük projede yukarıdaki akışı (add → commit → push, gerekiyorsa pull) tekrarladıkça eliniz alışacaktır. Flutter projelerinizi de bir GitHub deposunda tutarak hem yedek almış hem de ileride iş başvurularında “şu repo’da şu proje var” diyebilirsiniz.

Takıldığınız bir komut veya senaryo olursa (örneğin “branch’leri nasıl silerim?”, “conflict nasıl çözülür?”) bir sonraki yazıda veya derste o senaryoya odaklanabilirsiniz.

**Faydalı linkler:**  
- `https://git-scm.com/doc`  
- `https://docs.github.com/`  
- `https://rogerdudler.github.io/git-guide/index.tr.html`

