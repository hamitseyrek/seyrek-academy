# Açık Kaynak Projeler ve Dokümantasyon Mimarisi (Reading READMEs & Open-Source Projects)

Teknik alanlarda çalışanlar ve yazılım geliştiriciler sıfırdan kod yazmaktan çok, açık kaynak topluluklarının ürettiği kütüphane, framework ve araçları mevcut projelere entegre ederler. Bir açık kaynak repository'sinin (repo) giriş kapısı, projenin kök dizininde bulunan **README.md** dosyasıdır.

Teknik İngilizcede amaç, repodaki binlerce satır kodu incelemeden önce README dosyasını tarayarak; projenin ne işe yaradığını, sistem gereksinimlerini, kurulum adımlarını ve lisans kısıtlarını dakikalar içinde tespit etmektir. Bu belgede; standart README bölümleri, ön koşul bildiren dil yapıları ve gerçek dünya açık kaynak dokümanlarının analizi incelenmektedir.

---

## 1. Bir README Dosyasının Standart Mimarisi

Uluslararası açık kaynak standartlarına (GitHub, GitLab vb.) uygun hazırlanmış bir repository belirli bir başlık hiyerarşisine sahiptir:

| Bölüm Başlığı | Türkçe Karşılığı | İçerik ve Amacı | Aranacak Kritik Terimler |
| :--- | :--- | :--- | :--- |
| **Project Title & Badges** | Proje Başlığı ve Rozetler | Sürüm, derleme durumu ve test başarısını gösteren görsel etiketler | `build passing`, `coverage 95%`, `v2.4.0` |
| **About / Overview** | Genel Bakış / Tanıtım | Projenin hangi problemi çözdüğünü anlatan 2-3 cümlelik özet | `A lightweight library for...`, `Designed to...` |
| **Features** | Temel Nitelikler | Kütüphanenin sunduğu modüller ve yetenekler listesi | `Supports asynchronous I/O`, `Zero dependencies` |
| **Prerequisites** | Ön Koşullar / Gereksinimler | Projeyi çalıştırmadan önce makinede kurulu olması gereken araçlar | `Node.js >= 18.0`, `Python 3.10+`, `Docker installed` |
| **Installation / Getting Started**| Kurulum ve Hızlı Başlangıç | Kütüphaneyi indirme ve bağımlılıkları yükleme komutları | `git clone`, `npm install`, `pip install -r` |
| **Configuration** | Yapılandırma | Ortam değişkenleri ve ayar dosyalarının düzenlenmesi | `.env`, `API_KEY`, `PORT`, `database_url` |
| **Usage** | Kullanım ve Kod Örnekleri | Kütüphanenin kod içinde nasıl çağrılacağını gösteren mini örnek | `import`, `initialize()`, `fetchData()` |
| **License** | Yazılım Lisansı | Kodun ticari veya kişisel kullanım haklarını belirleyen yasal şart | `MIT License`, `Apache 2.0`, `GPL v3` |

---

## 2. Ön Koşul ve Zorunluluk Bildiren Dil Kalıpları

Bir projenin çalıştırılabilmesi için gerekli bağımlılıklar kural bildiren kipler (*modals*) ve şart ifadeleriyle tanımlanır:

| İngilizce Kalıp | Türkçe Anlamı | README Cümlesi | Türkçe Karşılığı |
| :--- | :--- | :--- | :--- |
| **Requires... or higher** | ... veya daha yükseğini gerektirir | `Requires Node.js 18.0 or higher.` | Node.js 18.0 veya daha üst bir sürüm gerektirir. |
| **Make sure that...** | ... olduğundan emin olunuz | `Make sure that Docker daemon is running.` | Docker arka plan servisinin çalıştığından emin olunuz. |
| **Must be installed** | Kurulu olmalıdır (Zorunluluk) | `Git CLI must be installed beforehand.` | Öncesinde Git komut satırı aracı kurulu olmalıdır. |
| **Compatible with...** | ... ile uyumludur | `Fully compatible with Linux and macOS.` | Linux ve macOS ile tam uyumludur. |
| **Optional / Mandatory** | İsteğe bağlı / Zorunlu | `Redis is optional for local caching.` | Yerel önbellekleme için Redis isteğe bağlıdır. |

```mermaid
flowchart TD
    A["GitHub Reposunu İnceleme"] --> B["1. Overview: Çözüm aradığım araç bu mu?"]
    B --> C["2. Prerequisites: Sistemim bu projeyi destekliyor mu?"]
    C --> D["3. Installation: Kurulum adımları hatasız mı?"]
    D --> E["4. License: Ticari veya akademik kullanıma uygun mu?"]
```
*Şekil 1: Açık Kaynak Bir Repoyu Hızlı İnceleme ve Doğrulama Akışı*

---

## 3. Real-World README Samples (Gerçek Dünya README Örnekleri)

### Sample 1: Prerequisites (Sistem Gereksinimleri ve Ön Koşullar)

Bir yapay zekâ veya veri analitiği kütüphanesinin ön koşul metni:

```markdown
## Prerequisites
Before you begin, ensure you have met the following requirements:
* Python 3.9 through 3.12 installed on your system.
* CUDA Toolkit 11.8 or higher if running on GPU.
* At least 8 GB of available system memory (16 GB recommended).
```

**Türkçe Çeviri:** Başlamadan önce aşağıdaki gereksinimleri karşıladığınızdan emin olunuz: Sisteminizde Python 3.9 ile 3.12 arası sürümlerden biri kurulu olmalıdır. GPU üzerinde çalıştırılacaksa CUDA Toolkit 11.8 veya üzeri gereklidir. En az 8 GB boş sistem belleği bulunmalıdır (16 GB önerilir).

| Parametre | Orijinal İfade | Türkçe Karşılığı | Teknik Değerlendirme |
| :--- | :--- | :--- | :--- |
| **Python Sürümü** | `Python 3.9 through 3.12` | Python 3.9 ile 3.12 arası | Python 3.13 kuruluysa kütüphane derlenmeyebilir |
| **Donanım Hızlandırma** | `CUDA Toolkit 11.8 or higher` | CUDA 11.8 veya üzeri | Nvidia grafik kartı sürücüleri güncellenmelidir |
| **Bellek Kısıtı** | `At least 8 GB (16 GB recommended)` | En az 8 GB (16 GB önerilir) | 8 GB altı sistemlerde bellek yetersizliği (*OOM*) oluşur |

---

### Sample 2: Quick Start CLI (Hızlı Başlangıç Komut Dizisi)

Modern bir backend veya mobil API projesinin kurulum adımları:

```markdown
## Quick Start
1. Clone the repository:
   git clone https://github.com/example/api-service.git
2. Navigate to the project directory:
   cd api-service
3. Copy the environment template:
   cp .env.example .env
4. Install dependencies:
   npm ci
5. Start development server:
   npm run dev
```

**Türkçe Çeviri:** 
1. Repoyu klonlayınız: `git clone ...`  
2. Proje dizinine geçiniz: `cd api-service`  
3. Ortam şablonunu kopyalayınız: `cp .env.example .env`  
4. Bağımlılıkları temiz yükleyiniz: `npm ci`  
5. Geliştirme sunucusunu başlatınız: `npm run dev`

| Komut | Eylem Fiili | Türkçe Açıklama | Teknik İşlev |
| :--- | :--- | :--- | :--- |
| `git clone` | **Clone** | Repoyu yerel ortama kopyalama | Uzak sunucudaki repository'yi diske indirir |
| `cd` | **Navigate** | Dizin değiştirme | Terminalin çalışma alanını proje klasörüne taşır |
| `cp .env.example` | **Copy** | Dosya çoğaltma / kopyalama | Gizli anahtarlar için şablon dosya üretir |
| `npm ci` | **Install** | Temel bağımlılıkları yükleme | `package-lock.json` ile birebir sürümleri kurar |
| `npm run dev` | **Start / Launch** | Sunucuyu ayağa kaldırma | Canlı yeniden yükleme (*hot reload*) modunda çalıştırır |

---

### Sample 3: Environment Variables (Ortam Değişkenleri ve Yapılandırma)

Veri tabanı ve harici servis bağlantılarını yöneten `.env.example` belgesi:

```text
# Server Configuration
PORT=3000
NODE_ENV=development

# Database Connection
DATABASE_URL=postgresql://user:password@localhost:5432/mydb

# Security Keys
JWT_SECRET=your_super_secret_jwt_key
API_TIMEOUT_MS=5000
```

**Türkçe Çeviri:** Sunucu Yapılandırması: Port 3000, Ortam geliştirme modu. Veri Tabanı Bağlantısı: PostgreSQL yerel sunucu bağlantı adresi. Güvenlik Anahtarları: JWT gizli imzalama anahtarı, API zaman aşımı 5000 milisaniye.

| Değişken Adı | Varsayılan Değer | Türkçe Karşılığı | Teknik Önemi |
| :--- | :--- | :--- | :--- |
| `PORT` | `3000` | Dinlenecek Ağ Portu | Port çakışması durumunda değiştirilmesi gereken değer |
| `NODE_ENV` | `development` | Çalışma Ortamı | `production` yapıldığında hata logları gizlenir ve hız artar |
| `DATABASE_URL` | `postgresql://...` | Veri Tabanı Bağlantı Yolu | Kullanıcı adı, şifre, sunucu adresi ve veri tabanı adını tutar |
| `API_TIMEOUT_MS` | `5000` | İstek Zaman Aşımı | Harici servisten 5 saniye içinde yanıt gelmezse istek düşürülür |

---

### Sample 4: Open Source Licenses (Yazılım Lisansları)

Açık kaynak projelerde kodun nasıl kullanılabileceğini belirleyen lisans terimleri:

| Lisans Türü | Ticari Kullanım İzni | Kodu Açma Zorunluluğu | Temel Kural |
| :--- | :--- | :--- | :--- |
| **MIT License** | İzin verilir (Permissive) | Zorunlu değil | Telif bildirimi korunduğu sürece kod istenildiği gibi satılabilir |
| **Apache 2.0** | İzin verilir (Permissive) | Zorunlu değil | Patent haklarını korur, kod ticari projelerde güvenle kullanılabilir |
| **GNU GPL v3** | İzin verilir (Copyleft) | **Zorunlu** | Bu kütüphaneyi kullanan yazılım da açık kaynak olmak zorundadır |
| **Proprietary** | Yasak / Kısıtlı | Yok (Kapalı kod) | Kod sahibinin izni olmadan dağıtılamaz veya değiştirilemez |

---

## 4. Dokümantasyonda Sık Karşılaşılan Sürüm ve İşlem Terimleri

Açık kaynak projelerde ve repolarda günlük iletişimde kullanılan anahtar kavramlar:

| Terim | Sektördeki Karşılığı | Bağlam / Anlamı |
| :--- | :--- | :--- |
| **Fork** | Fork etmek | Bir repository'nin kendi hesabınıza bağımsız bir kopyasını almak |
| **Pull Request (PR)** | PR açmak / Değişiklik isteği | Yazdığınız kodu ana repository'ye birleştirmek için gönderilen talep |
| **Issue** | Issue açmak / Hata bildirimi | Projedeki bir bug'ı veya geliştirme isteğini bildiren başlık |
| **Release / Tag** | Kararlı sürüm paketi | Projenin belirli bir aşamada yayınlanmış kararlı versiyonu |
| **Deprecated** | Kullanımdan kalkan (eskiyen) | Yakın gelecekte kaldırılacak olan ve artık önerilmeyen özellik |
| **Breaking Change** | Geriye dönük uyumsuzluk (mevcut kodu bozan değişiklik) | Yeni sürüme geçildiğinde eski çalışan kodların bozulmasına yol açan köklü değişiklik |

---

## 5. Teknik Karar Matrisi: Kütüphane Seçim Kontrolleri

Yeni bir kütüphane veya araç projeye eklenmeden önce README ve repo sayfasından incelenmesi gereken 4 kritik ölçüt:

| Sıra | Kontrol Ölçütü | Bakılacak Bölüm | Risk Göstergesi |
| :---: | :--- | :--- | :--- |
| **1** | **Lisans Uyumu** | `License` bölümü | GPL lisanslı bir araç kapalı ticari projeye eklenirse yasal sorun doğar |
| **2** | **Son Güncelleme** | `Commit History / Releases` | 2 yıldır güncelleme almamış kütüphaneler güvenlik açığı barındırır |
| **3** | **Sistem Uyumu** | `Prerequisites` bölümü | Sunucudaki işletim sistemi veya çalışma ortamı sürümüyle uyuşmazlık |
| **4** | **Açık Hata Sayısı** | `Issues tab` | Yüzlerce çözülmemiş hata içeren araçlar kararsız çalışır |
