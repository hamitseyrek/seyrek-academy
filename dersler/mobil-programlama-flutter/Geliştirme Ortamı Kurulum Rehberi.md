# Mobil Uygulama Geliştirme Ortamı Kurulum Rehberi (Windows)

Bu rehber; mobil programlama dersi için gerekli olan **Git**, **Flutter SDK**, **Android Studio** ve **VS Code** araçlarının Windows işletim sisteminde adım adım sıfırdan kurulumunu içerir.

---

## 1. Gerekli Programlar ve Resmî İndirme Bağlantıları

Kuruluma başlamadan önce aşağıdaki resmi sitelerden güncel kurulum dosyalarını indirin:

| Program | Resmî İndirme Sayfası | Açıklama |
| --- | --- | --- |
| **Git for Windows** | [git-scm.com/download/win](https://git-scm.com/download/win) | 64-bit Git for Windows Setup dosyasını indirin. |
| **Flutter SDK** | [docs.flutter.dev - Windows Install](https://docs.flutter.dev/get-started/install/windows/mobile) | En güncel kararlı `.zip` paketini indirin. |
| **Android Studio** | [developer.android.com/studio](https://developer.android.com/studio) | Android SDK ve emülatör araçlarını sağlar. |
| **Visual Studio Code** | [code.visualstudio.com/Download](https://code.visualstudio.com/Download) | Windows için User Installer (64-bit) indirin. |
| **Flutter VS Code Eklentisi** | [marketplace.visualstudio.com - Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) | VS Code içinden kurulacak ana eklenti. |

> **Önemli Not (Dart SDK Hakkında):**  
> Dart SDK için internetten ayrı bir indirme **yapmayın**. Flutter SDK, güncel ve uyumlu Dart SDK'yı kendi içinde barındırır. Flutter'ı kurduğunuzda Dart otomatik olarak sisteme eklenir.

---

## 2. Adım Adım Kurulum

### Adım 1: Git Kurulumu

1. İndirdiğiniz Git kurulum dosyasını çalıştırın.
2. Kurulum adımlarını varsayılan ayarlarla `Next` diyerek ilerletin.
3. **"Adjusting your PATH environment"** ekranında **"Git from the command line and also from 3rd-party software"** seçeneğinin işaretli olduğundan emin olun.
4. Kurulumu tamamlayın (`Finish`).
5. Komut İstemi (CMD) veya PowerShell'i açıp adınızı ve e-postanızı sisteme tanıtın:
   ```cmd
   git config --global user.name "Adınız Soyadınız"
   git config --global user.email "eposta@ornek.com"
   ```
6. Doğrulayın:
   ```cmd
   git --version
   ```

---

### Adım 2: Flutter SDK Kurulumu ve PATH Ayarı

1. İndirdiğiniz Flutter `.zip` arşivini açın.
2. Klasörü doğrudan **`C:\src\flutter`** (veya `C:\flutter`) olacak şekilde çıkartın.
   > **Dikkat:** Flutter'ı kesinlikle `C:\Program Files` veya `C:\Program Files (x86)` altına **koymayın**. Bu dizinler yönetici yetkisi gerektirdiği için paket yönetiminde izin hatası verir.

3. **PATH Ortam Değişkenini Ekleme:**
   - Windows arama çubuğuna **ortam değişkenleri** yazın.
   - **"Sistem ortam değişkenlerini düzenleyin"** seçeneğine tıklayın.
   - Açılan pencerenin altındaki **Ortam Değişkenleri... (Environment Variables)** butonuna basın.
   - Üst taraftaki "Kullanıcı değişkenleri" listesinden **Path** satırını seçip **Düzenle (Edit)** butonuna tıklayın.
   - Sağ taraftaki **Yeni (New)** butonuna tıklayın ve şu yolu yazın:
     ```text
     C:\src\flutter\bin
     ```
   - Açık olan tüm pencereleri **Tamam (OK)** diyerek kapatın.

4. Açık olan tüm komut satırı pencerelerini kapatıp yeni bir CMD veya PowerShell açın.
5. Kurulumu doğrulayın:
   ```cmd
   flutter --version
   dart --version
   ```

---

### Adım 3: Android Studio ve Android SDK Bileşenleri Kurulumu

1. İndirdiğiniz Android Studio kurulum dosyasını çalıştırın.
2. Varsayılan ayarları kabul ederek (`Android Studio` ve `Android Virtual Device` seçili olacak şekilde) kurulumu tamamlayın.
3. Android Studio'yu başlatın. İlk açılışta gelen **Setup Wizard** ekranında **Standard** kurulumu seçip gerekli SDK paketlerinin indirilmesini bekleyin.

4. **Kritik Adım: SDK Command-line Tools Kurulumu**  
   *(Bu adımı yapmazsanız `flutter doctor` hata verecektir)*
   - Android Studio açılış ekranında sağ üstteki menüden veya **More Actions > SDK Manager** seçeneğine tıklayın. (Eğer bir proje açıksa üst menüden `Tools > SDK Manager` yolunu izleyin).
   - Açılan pencerede **SDK Tools** sekmesine geçin.
   - Listeden **"Android SDK Command-line Tools (latest)"** kutucuğunu **işaretleyin**.
   - Aynı listede `Android SDK Platform-Tools` ve `Android SDK Build-Tools` kutucuklarının da seçili olduğunu teyit edin.
   - Alttaki **Apply** butonuna tıklayın, lisans onayını kabul edin ve indirme bitince **Finish** deyin.

---

### Adım 4: Android Lisanslarını Onaylama

1. Yeni bir CMD veya PowerShell penceresi açın.
2. Şu komutu çalıştırın:
   ```cmd
   flutter doctor --android-licenses
   ```
3. Ekrana lisans sözleşmeleri gelecektir. Her bir soru için klavyeden `y` yazıp **Enter** tuşuna basın.
4. Tüm onaylar bitince **"All SDK package licenses accepted"** mesajı görünmelidir.

---

### Adım 5: VS Code ve Flutter Eklentisi Kurulumu

1. İndirdiğiniz VS Code kurulum dosyasını çalıştırıp kurulumu tamamlayın.
2. VS Code'u açın.
3. Sol taraftaki **Extensions** (Eklentiler) simgesine tıklayın (`Ctrl + Shift + X`).
4. Arama kutusuna **Flutter** yazın.
5. Yayıncısı **Dart Code** olan resmi **Flutter** eklentisini bulup **Install** butonuna tıklayın.
   *(Flutter kurulduğunda resmi Dart eklentisi de otomatik olarak birlikte kurulur).*
6. **Önerilen ek eklentiler:**
   - **Error Lens:** Hataları satır üstünde renkli gösterir.
   - **Awesome Flutter Snippets:** Hızlı widget iskeleti (`stless`, `stful`) üretir.

---

### Adım 6: Test ve Çalıştırma Ortamını Seçme

Kodlarınızı çalıştırmak için aşağıdaki 3 seçenekten birini kullanabilirsiniz:

#### Seçenek 1: Gerçek Android Telefon (Önerilen - Bilgisayarı Yormaz)
*Bilgisayarınızın RAM'i 8 GB veya altındaysa emülatör yerine telefonunuzu kullanın.*
1. Telefonunuzda **Ayarlar > Telefon Hakkında** bölümüne gidin.
2. **Yapım Numarası (Build Number)** satırına art arda **7 kez hızlıca dokunun** (*"Artık bir geliştiricisiniz"* uyarısı çıkana kadar).
3. **Ayarlar > Sistem (veya Ek Ayarlar) > Geliştirici Seçenekleri** menüsüne girin.
4. **USB Hata Ayıklama (USB Debugging)** özelliğini açın.
5. Telefonu USB kablosuyla bilgisayara bağlayın.
6. Telefon ekranında *"Bu bilgisayara USB hata ayıklama için izin verilsin mi?"* uyarısı çıktığında **"Bu bilgisayara her zaman izin ver"** kutucuğunu işaretleyip **İzin Ver** deyin.
7. CMD'de şu komutu yazarak telefonun tanındığını kontrol edin:
   ```cmd
   flutter devices
   ```

#### Seçenek 2: Android Emülatör (Sanal Cihaz)
*Bilgisayarınızda 16 GB veya daha fazla RAM varsa:*
1. Android Studio'yu açın.
2. **More Actions > Virtual Device Manager** (Device Manager) bölümüne girin.
3. **Create Device** butonuna tıklayın.
4. `Pixel 7` veya `Pixel 8` modelini seçip **Next** deyin.
5. Güncel bir sistem imajı (örn. `API 34` veya `API 35`) seçip yanındaki **Download** butonuna basın.
6. İndirme tamamlanınca **Next** ve **Finish** diyerek emülatörü oluşturun.
7. Listeden cihazın yanındaki **Play (▶)** butonuna basarak sanal telefonu başlatın.

> **BIOS Sanallaştırma Uyarısı:** Emülatör açılırken hata verirse bilgisayarı yeniden başlatıp BIOS ekranından sanallaştırmayı (**Intel Virtualization Technology / AMD SVM Mode**) `Enabled` yapmanız gerekir.

#### Seçenek 3: Google Chrome (Web Testi)
Emülatör açmadan veya telefon bağlamadan hızlı arayüz testi yapmak için doğrudan Chrome tarayıcısını kullanabilirsiniz:
```cmd
flutter run -d chrome
```

---

## 3. Kurulum Doğrulaması (`flutter doctor`)

Tüm adımları tamamladıktan sonra terminalde şu komutu çalıştırın:

```cmd
flutter doctor
```

**Beklenen Başarılı Çıktı:**
```text
[✓] Flutter (Channel stable ...)
[✓] Android toolchain - develop for Android devices (Android SDK version ...)
[✓] Chrome - develop for the web
[✓] Android Studio (version ...)
[✓] VS Code (version ...)
[✓] Connected device (... available)
[✓] Network resources

• No issues found!
```

> **Not:** Windows Masaüstü geliştirmesi yapmayacaksanız `Visual Studio - develop for Windows` maddesindeki `[!]` işareti mobil dersi için engel değildir.

---

## 4. İlk Test Projesini Oluşturma ve Çalıştırma

1. Terminalde (CMD veya PowerShell) projeyi oluşturmak istediğiniz klasöre gidin:
   ```cmd
   cd C:\Users\KullaniciAdiniz\Desktop
   flutter create ilk_uygulama
   cd ilk_uygulama
   ```
2. Projeyi VS Code ile açın:
   ```cmd
   code .
   ```
3. VS Code sağ alt durum çubuğundan hedef cihazınızı (telefon, emülatör veya Chrome) seçin.
4. `lib/main.dart` dosyasını açıp klavyeden **`F5`** tuşuna basın (veya terminalde `flutter run` yazın).
5. Ekrana varsayılan sayaç (Counter) uygulaması geldiğinde kurulumunuz başarıyla tamamlanmıştır.

---

## 5. Sık Karşılaşılan Hatalar ve Hızlı Çözümler

| Karşılaşılan Hata | Çözüm |
| --- | --- |
| `'flutter' iç ya da dış komut olarak tanınmıyor` | `C:\src\flutter\bin` yolunu PATH ortam değişkenine ekleyin ve açık olan tüm terminal pencerelerini kapatıp yeniden açın. |
| `cmdline-tools component is missing` | Android Studio -> `SDK Manager` -> `SDK Tools` sekmesine gidin. **"Android SDK Command-line Tools (latest)"** seçeneğini işaretleyip `Apply` deyin. |
| `Android license status unknown` | Terminalde `flutter doctor --android-licenses` komutunu çalıştırın ve gelen tüm sorulara `y` yazıp Enter'a basın. |
| `VT-x is disabled in the BIOS` | Bilgisayarı yeniden başlatıp BIOS/UEFI menüsünden Sanallaştırmayı (Intel VT-x veya AMD SVM) etkinleştirin. |
| `Waiting for another flutter command to release the lock` | Bilgisayardaki `flutter\bin\cache\lockfile` dosyasını silin. |
| `Türkçe karakter / Yol hatası` | Windows kullanıcı adınızda Türkçe karakter (`ç, ğ, ı, ö, ş, ü`) varsa projelerinizi masaüstü yerine doğrudan `C:\src` veya `C:\projeler` klasöründe oluşturun. |
