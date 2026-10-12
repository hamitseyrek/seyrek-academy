# Flutter’a Giriş: İlk Proje

**Flutter ile “ilk projeyi” başlatmak çoğu zaman en heyecanlı (ve en karışık) adım. Bu yazıda amaç sadece `flutter create` çalıştırmak değil: oluşan projenin içindeki yapıları anlamak, temel entry-point akışını görmek ve küçük değişikliklerle “widget ağacı nasıl etkileniyor?” fikrini oturtmak.**

---

Bu makalede, Flutter ilk proje oluşturduğunda gelen varsayılan `main.dart` dosyasını temel alıp, içindeki widget’ları (özellikle `StatelessWidget` ve `StatefulWidget`) ve sayfadaki yapı taşlarını tek tek tanıtacağız. En sonda da VS Code üzerinden proje oluşturma ve bu projeyi GitHub hesabına gönderme akışını ekleyeceğiz.

## İlk Flutter Projesi Oluşturma (Komut ve VS Code)

Flutter projesinin şablonu aynı mantığı korur; ister `flutter create` ile ister VS Code ile oluştur, daha sonra inceleyeceğimiz `lib/main.dart` yapısı benzer olur.

### Komut satırıyla

Örnek:

```bash
cd /Users/hamitseyrek/seyrek-academy
flutter create first_flutter_app
cd first_flutter_app
flutter run
```

### VS Code ile

1. VS Code’u açın ve proje klasörünü `File -> Open Folder` ile açın.
2. `Cmd+Shift+P` ile Command Palette açın.
3. `Flutter: New Project` yazıp seçin.
4. Proje adını ve klasörü seçin.
5. Açılan projede çalıştırma için gerekirse entegre terminalde `flutter run` kullanın.

## Varsayılan `main.dart`: Parça Parça Okuma

Senin paylaştığın şablon, yeni bir Flutter projesinde en sık göreceğimiz “kata mantığı”nı içeriyor. Biz de kodu tek büyük blok yerine şu parçalar olarak okuyacağız:

### `main()` ve `runApp(...)` (entry point)

Uygulamanın başladığı yer burası:

```dart
void main() {
  runApp(const MyApp());
}
```

`runApp` ile Flutter’a “ilk root widget” olarak `MyApp` verilir.

### `MyApp` (StatelessWidget) ve `MaterialApp`

`MyApp` uygulamanın üst ayarlarını taşır ve genelde `MaterialApp` döndürür:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
```

Burada `home:` root’tan ilk sayfayı (`MyHomePage`) seçer.

### `MyHomePage` (StatefulWidget) ve `_counter`

Ekranda değişecek değer olduğu için `StatefulWidget` kullanılır:

```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
}
```

`_counter` “UI’ı etkileyen state”tir.

### `setState(...)` ile UI güncelleme

Butona basınca state değişir ve `setState` ile Flutter’a “yeniden çiz” denir:

```dart
void _incrementCounter() {
  setState(() {
    _counter++;
  });
}
```

### `_MyHomePageState.build(...)`: UI ağacının iskeleti

`build(...)` içinde `Scaffold` ve alt widget’lar kurulur:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('You have pushed the button this many times:'),
          Text('$_counter'),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _incrementCounter,
      child: const Icon(Icons.add),
    ),
  );
}
```

Bu parçalar, “başlangıç → root ayarlar → ilk sayfa → UI’ı etkileyen state” akışını netleştirir.


## Parça Parça İnceleme: StatelessWidget ve StatefulWidget

### `main()` ve `runApp(...)`

- `main()` uygulamanın girişidir.
- `runApp(const MyApp())` Flutter’a “root widget şu” bilgisini verir. Yani ekrandaki her şeyin başlangıç noktası `MyApp` olur.

### `MyApp` (`StatelessWidget`)

`MyApp extends StatelessWidget` olduğu için:

- Kendi içinde değişen bir `counter` gibi “runtime state” tutmaz.
- Sadece aldığı parametreler ve `build(...)` içinde kurduğu widget ağacına göre çizilir.

Bu sınıfta root ayarlarını görüyoruz:

- `MaterialApp(title: ...)` -> uygulama meta bilgileri ve üst tema kontrolü
- `theme: ThemeData(colorScheme: ...)` -> uygulamanın renk temasını kurar
- `home: MyHomePage(...)` -> ilk sayfanın hangi widget olacağını belirler

### `MyHomePage` (`StatefulWidget`) ve `_MyHomePageState`

`MyHomePage extends StatefulWidget` çünkü ekranda değişen bir değer var: `_counter`.

- `MyHomePage` tarafı (widget sınıfı) `title` gibi “parametreleri” taşır.
- `createState()` ile gerçek state’i yöneten `_MyHomePageState` oluşturulur.

_MyHomePageState içinde:

- `int _counter = 0;` -> ekrandaki sayıyı tutan state değişkeni
- `_incrementCounter()` -> butona basılınca çağrılan fonksiyon
- `_incrementCounter()` içinde `setState(() { ... })` -> `build(...)` yeniden çalışsın diye UI’ya sinyal

### `build(...)`: Ekranı kuran yer

`_MyHomePageState.build(context)` çağrıldığında `Scaffold` döner. Burada sayfanın temel iskeleti kurulur:

- `Scaffold(appBar: AppBar(...), body: ..., floatingActionButton: ...)`
- `AppBar(title: Text(widget.title))` -> üst çubuk ve başlık metni
- `body: Center(child: Column(children: [...])))`
- `Column` -> üstten alta dizilim (iki `Text` yan yana değil dikey)
- İlk `Text` -> sabit açıklama metni
- İkinci `Text('$_counter', ...)` -> state değişkeninden gelen dinamik sayı
- `FloatingActionButton(onPressed: _incrementCounter, child: Icon(Icons.add))` -> sayıyı artıran buton

Bu şablonda `setState` çağrıldığı an, `_counter` güncellenir ve `build(...)` tekrar çizilir. Böylece ekrandaki sayı yeni değerle görünür.

---

## Flutter şablonundaki widget’lar: örneklerle

Aşağıdaki başlıklar, Flutter’ın yeni proje şablonunda “neden bu widget’lar var?” sorusunu daha somut hale getirir.

### Widget kavramı

Flutter’da her şey widget’tır: düzen (layout), metin, buton, renk, hatta “sayfanın iskeleti”.

Örnek (basit widget):

```dart
Text('Merhaba Flutter');
```

### `MaterialApp` ve `Scaffold`

`MaterialApp`: uygulama genelinde tema/rota gibi üst katman ayarlarını sağlar.  
`Scaffold`: sayfanın temel iskeletini (appBar, body, FAB) düzenler.

Kısa örnek:

```dart
return MaterialApp(
  home: Scaffold(
    appBar: AppBar(title: const Text('Sayfa')),
    body: const Center(child: Text('İçerik')),
  ),
);
```

### `FloatingActionButton` (FAB) ve Material tasarım

`FloatingActionButton (FAB)`: genelde sayfanın ana aksiyonunu temsil eder.

Örnek:

```dart
Scaffold(
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: const Icon(Icons.add),
  ),
);
```

### `Container` widget’ı ve özellikleri

`Container`: boyut, padding/margin, renk, dekorasyon gibi “tek bir kutu” üzerinde toplu kontrol sağlar.

Örnek:

```dart
Container(
  padding: const EdgeInsets.all(12),
  margin: const EdgeInsets.all(16),
  color: Colors.amber,
  child: const Text('Container içi'),
);
```

### Padding, margin ve alignment

- `padding`: kutunun iç kenarından içerik uzaklığı.
- `margin`: kutunun dış kenarından diğer widget’lara uzaklığı.
- `alignment`: container içindeki `child`’i konumlandırır.

Örnek:

```dart
Container(
  width: 200,
  height: 120,
  margin: const EdgeInsets.all(12),
  padding: const EdgeInsets.all(8),
  alignment: Alignment.bottomRight,
  color: Colors.blue.shade50,
  child: const Text('Hizalanmış'),
);
```

### `Center`, `child`’i hem yatayda hem dikeyde ortalar.

Örnek:

```dart
Center(
  child: const Text('Ortada'),
);
```

### `Container`: BoxDecoration, border, image, shadow

`Container(decoration: ...)` ile kutuyu daha gelişmiş görselleştirebilirsiniz.

Örnek:

```dart
Container(
  width: 220,
  height: 120,
  decoration: BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.blue, width: 2),
    boxShadow: [
      const BoxShadow(
        blurRadius: 12,
        offset: Offset(0, 6),
        color: Colors.black26,
      ),
    ],
    image: const DecorationImage(
      image: AssetImage('assets/sample.jpg'),
      fit: BoxFit.cover,
    ),
  ),
  child: const Center(child: Text('BoxDecoration')),
);
```

Not: `AssetImage` kullanacaksan `assets/` yolunu `pubspec.yaml`’da tanımlaman gerekir.

### `Row` ve `Column`

`Row`: `children` yatay dizilir.  
`Column`: `children` dikey dizilir.

Örnek:

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
    Text('Birinci'),
    Text('İkinci'),
  ],
)
```

Benzer şekilde `Row` ile aynı iki metin yan yana olur (sıralama mantığı değişmez).

### `Expanded` ve `Flexible`: farkları

`Row`/`Column` gibi “tek eksende” çalışan layoutlarda `children` alanı paylaşsın diye `Expanded`/`Flexible` kullanılır.

- `Expanded`: boş alanı “tamamını” paylaşacak şekilde `child`’i genişletir (flex factor ile).
- `Flexible`: `child`’i mümkün olduğunca genişletir ama `Expanded` kadar agresif davranmaz.

Örnek (`Row` içinde):

```dart
Row(
  children: [
    Expanded(
      child: Container(color: Colors.red, height: 50),
    ),
    Flexible(
      flex: 1,
      child: Container(color: Colors.green, height: 50),
    ),
  ],
);
```

---

## GitHub’a Gönderme: commit + push

Aşağıdaki akış “kendi GitHub hesabıma göndermek” için en temel başlangıçtır. Terminali VS Code içinden de kullanabilirsiniz.

1. GitHub’da yeni bir depo (repository) oluşturun.
2. Proje klasörünüzde terminal açın (örn. VS Code entegre terminal).
3. Aşağıdaki komutları sırasıyla çalıştırın:

```bash
git init
git add .
git commit -m "İlk Flutter uygulaması"
git branch -M main

git remote add origin https://github.com/kullanici_adiniz/repo_adi.git
git push -u origin main
```

4. GitHub hesabınızda repository sayfasını yenileyince kodun göründüğünü kontrol edin.

> Not: Flutter projelerinde genelde derlenen dosyalar ve IDE ayarları Git’e dahil edilmemelidir. `.gitignore` bu yüzden önemlidir.
