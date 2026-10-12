# Ana Sayfa, Navigator ve UI bileşenleri

**`main.dart` girişinden `HomePage` çağrısıyla açılan bir uygulamada `Navigator` ile beş örnek sayfaya geçiş kurulur. Ana sayfada alt alta düğmeler (`Column` + `FilledButton`) yer alır. Sırayla `Container` / `BoxDecoration`, `Row` / `Column`, `Expanded` / `Flexible`, özel widget’lar, `StatefulWidget` / `setState`, `BuildContext` ve `Theme`, görsel kaynakları, buton ve menüler, listeler / `GridView`, diyaloglar, `GestureDetector` ve `CustomScrollView` ile `Sliver` yapıları kod üzerinden gösterilir.**

---

## Proje oluşturma ve `main` girişi

Terminalde boş bir klasörde:

```bash
flutter create ui_component_lab
cd ui_component_lab
```

`lib/main.dart` dosyasında uygulama kökü `MaterialApp` ile açılır; `home` olarak merkez menü sayfası verilir:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI Component Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
```

- **`runApp`:** `MyApp` kök widget olarak widget ağacına bağlanır; uygulama buradan çizilmeye başlar.
- **`StatelessWidget`:** İçinde tutulan veri değişmediği sürece `build` yalnızca üst widget yeniden çizildiğinde çalışır.
- **`MaterialApp`:** Material tema, `Navigator` stack kökü ve `home` ile açılış sayfasını sağlar.
- **`ThemeData` / `ColorScheme.fromSeed`:** Türetilmiş renk palemi; alt sayfalarda `Theme.of(context)` ile okunur.
- **`useMaterial3: true`:** Material 3 bileşen görünümünü seçer.
- **`debugShowCheckedModeBanner: false`:** Sağ üstteki “DEBUG” şeridini kapatır.

---

## `Navigator`: stack, `push`, `pop`

Flutter’da tam ekran sayfa geçişleri çoğu zaman bir **route stack** üzerinden yürür. `Navigator.push`, üste yeni bir route ekler; `Navigator.pop` veya `AppBar` geri oku en üstteki route’u kaldırır.

Örnek: `HomePage` içinden başka bir `Widget` açmak:

```dart
Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (context) => const DecorationLayoutPage(),
  ),
);
```

- **`Navigator.of(context)`:** Bu `context`’e en yakın `Navigator` örneğini bulur; `push` stack’e yeni route ekler.
- **`MaterialPageRoute`:** Tam ekran sayfa route’udur; `builder` hedef sayfa widget’ını üretir (`<void>` generic’i route dönüş tipi içindir). Material geçiş animasyonu ve `AppBar` geri ok ile uyumludur.
- **`BuildContext`:** `Theme.of(context)` ve `showDialog` gibi çağrılarda hangi `Theme` / `Navigator`’ın seçileceğini belirler.

---

## `HomePage`: menü ve yönlendirme

**`Scaffold`:** Sayfanın iskeletidir; `appBar` üst çubuk, `body` ana içeriktir.

**`SingleChildScrollView`:** İçerik küçük ekranda taşarsa dikey kaydırma verir. **`Column`:** Çocukları alt alta dizer; `crossAxisAlignment: CrossAxisAlignment.stretch` ile yatayda tam genişlikte hizalanırlar.

**`FilledButton`:** Material 3 dolgu düğmesi; `onPressed` içinde `_open` çağrılır. Düğmeler arasında **`SizedBox(height: ...)`** boşluk bırakır.

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ana sayfa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: () => _open(context, const DecorationLayoutPage()),
              child: const Text('Dekorasyon ve düzen (Container, Row, Column, Expanded)'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => _open(context, const WidgetStateThemePage()),
              child: const Text('Widget bölme, state, tema ve görseller'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => _open(context, const ButtonsMenusPage()),
              child: const Text('Butonlar, DropdownButton, PopupMenuButton'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => _open(context, const ListsDialogsPage()),
              child: const Text('Listeler, GridView, diyaloglar'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => _open(context, const SliversGesturePage()),
              child: const Text('GestureDetector ve Sliver örnekleri'),
            ),
          ],
        ),
      ),
    );
  }
}
```

`_open`, `MaterialPageRoute` içinde hedef `page` widget’ını verir; `builder: (_) => page` ifadesinde `_`, kullanılmayan `context` parametresini yok sayar.

---

## Sayfa 1 — `Container`, `BoxDecoration`, `Row`, `Column`, `Expanded`, `Flexible`

**`Container` ve `BoxDecoration`:** Kenarlık, gölge, arka plan rengi veya `DecorationImage` tek yerde toplanır.

**`Row` / `Column`:** `mainAxisAlignment`, `crossAxisAlignment` ile hizalama kontrol edilir.

**`Expanded`:** `Row` / `Column` içinde kalan alanı paylaştırır (`flex` oranı ile).

**`Flexible`:** `FlexFit.loose` ile çocuğun doğal boyutuna daha fazla izin verilebilir; `Expanded` ise `FlexFit.tight` benzeri davranır.

**Flutter DevTools:** Çalışan uygulamada `Widget Inspector` ile `Row` / `Column` içindeki `constraints` ve boyutları görmek, `Expanded` / `Flexible` farkını anlamayı kolaylaştırır. VS Code veya Android Studio’dan “Open DevTools” ile açılabilir.

Bu sayfada gövde yapısı:

- **`Scaffold` + `AppBar`:** Başlık çubuğu ve geri ok (stack’te üst route varken).
- **`SingleChildScrollView`:** İçerik ekrandan taşarsa dikey kaydırma sağlar; tek bir `child` alır (burada `Column`).
- **`Column` + `crossAxisAlignment: CrossAxisAlignment.stretch`:** Çocukları dikey sıralar; `stretch` yatayda mümkün olan genişliği doldurmayı isteyen çocuklara tam genişlik verir.
- **`SizedBox`:** Sabit yükseklik veya genişlik boşluğu için kullanılır; boş `Container` yazmaya göre daha hafiftir.

```dart
class DecorationLayoutPage extends StatelessWidget {
  const DecorationLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dekorasyon ve düzen')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8,
                    offset: Offset(0, 4),
                    color: Colors.black26,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text('Border + radius + shadow'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Row sol'),
                Text('Row sağ'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(color: Colors.blue.shade100, height: 48),
                ),
                Expanded(
                  flex: 1,
                  child: Container(color: Colors.green.shade100, height: 48),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    color: Colors.purple.shade50,
                    padding: const EdgeInsets.all(8),
                    child: const Text('Flexible loose'),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.purple.shade100,
                    padding: const EdgeInsets.all(8),
                    child: const Text('Expanded'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

**`DecorationImage`:** `BoxDecoration` içinde arka plan resmi tanımlar. `AssetImage` pakete eklenmiş dosya yolunu okur. `fit: BoxFit.cover` kutuyu doldururken oranı koruyup taşanı kırpar.

Aşağıdaki örnek yerel `AssetImage` kullanır; `pubspec.yaml` içinde `flutter: assets:` tanımı gerekir (Sayfa 2 bölümündeki örnekle uyumlu olmalıdır).

```dart
Container(
  height: 140,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    image: const DecorationImage(
      image: AssetImage('assets/sample.jpg'),
      fit: BoxFit.cover,
    ),
  ),
)
```

Görsel dosyası yoksa bu satırı geçici olarak `color: Colors.grey` ile değiştirmek derlemeyi kolaylaştırır.

---

## Sayfa 2 — Özel widget, `StatefulWidget`, `setState`, `BuildContext`, `Theme`, görseller

### Küçük parçalara bölmek

Tekrar eden başlık + açıklama bloğu için ayrı bir `StatelessWidget` tanımlamak okunabilirliği artırır. **`Padding`:** `EdgeInsets.only` ile yalnızca belirtilen kenarlara boşluk verir. **`Text` + `textTheme.titleMedium`:** Tema metin stiline bağlanır.

```dart
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
```

### Hot reload ve hot restart

Kod değişince çoğu UI güncellemesi **hot reload** ile yeterlidir. `enum` ekleme, `main()` değişimi veya bazı global başlatıcılar sonrası tam yeniden başlatma gerekebilir; bu durumda **hot restart** veya uygulamayı durdurup yeniden çalıştırmak gerekir.

### `StatefulWidget` ve `setState`

Sayfa içi sayaç, seçim veya form alanı gibi **çalışma anında değişen** durum için `StatefulWidget` kullanılır. Dış sınıf (`WidgetStateThemePage`) yapılandırma ve `createState` döndürür; asıl state `_WidgetStateThemePageState` içinde tutulur. **`setState`:** İçindeki fonksiyon state’i günceller; ardından `build` yeniden çalışır.

```dart
class WidgetStateThemePage extends StatefulWidget {
  const WidgetStateThemePage({super.key});

  @override
  State<WidgetStateThemePage> createState() => _WidgetStateThemePageState();
}

class _WidgetStateThemePageState extends State<WidgetStateThemePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('State ve tema')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          const SectionTitle('Theme.of(context)'),
          Text(
            'OnPrimary rengi örneği',
            style: TextStyle(color: scheme.onPrimary),
          ),
          const SectionTitle('StatefulWidget + setState'),
          Text('Sayaç: $_counter', style: Theme.of(context).textTheme.headlineSmall),
          FilledButton(
            onPressed: () {
              setState(() => _counter++);
            },
            child: const Text('Artır'),
          ),
          const SectionTitle('CircleAvatar — ağ ve varlık'),
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage('https://picsum.photos/200'),
              ),
              const SizedBox(width: 16),
              CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage('assets/sample.jpg'),
              ),
            ],
          ),
          const SectionTitle('FadeInImage + Placeholder'),
          FadeInImage.assetNetwork(
            placeholder: 'assets/placeholder.png',
            image: 'https://picsum.photos/400/200',
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SectionTitle('Placeholder — henüz tasarlanmamış alan'),
          const SizedBox(
            height: 80,
            child: Placeholder(),
          ),
          const SectionTitle('IntrinsicHeight — yan yana eşit yükseklik'),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.teal.shade100,
                    child: const Center(child: Text('Kısa')),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.teal.shade200,
                    child: const Center(
                      child: Text('Daha uzun\nmetin'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}
```

Gövde **`SingleChildScrollView` + `Column`** ile kurulur; uzun içerik taşarsa kaydırılır. Öğeler sırasıyla:

- **`Text` + `TextStyle(color: scheme.onPrimary)`:** `ColorScheme` üzerinden tema rengi okunur.
- **`FilledButton`:** Dolu dolgu rengi olan Material 3 düğmesi; `onPressed` içinde `setState` ile `_counter` artırılır.
- **`Row`:** İki `CircleAvatar` yan yana; `SizedBox(width: 16)` araya yatay boşluk koyar.
- **`CircleAvatar`:** `radius` daire boyutu; `backgroundImage` ile `NetworkImage` (URL) veya `AssetImage` (yerel) gösterilir.
- **`FadeInImage.assetNetwork`:** Önce `placeholder` varlık görseli, ağ görseli gelince geçiş yapar; `height` / `width` / `fit` boyutlandırır.
- **`Placeholder`:** Tasarım bitmemiş alanları gri çizgilerle doldurur; `SizedBox` ile yükseklik sınırlanır.
- **`IntrinsicHeight`:** `Row` içindeki çocukların yüksekliğini satırdaki en yüksek çocuğa eşitler; `crossAxisAlignment: CrossAxisAlignment.stretch` ile kutular aynı yüksekliği paylaşır.
- **`Center`:** `child`’i verilen alanda ortalar.

**`BuildContext`:** `Theme.of(context)`, `Navigator.of(context)`, `showDialog` gibi çağrılarda `context`, widget ağacındaki konumu temsil eder; doğru `context` ile doğru `Theme` ve `Navigator` bulunur.

### `pubspec.yaml` — `assets`

```yaml
flutter:
  assets:
    - assets/sample.jpg
    - assets/placeholder.png
```

---

## Sayfa 3 — `TextButton`, `ElevatedButton`, `OutlinedButton`, `DropdownButton`, `PopupMenuButton`

**`AppBar` + `actions`:** Sağ üstte ikon veya düğme dizisi; burada `PopupMenuButton` yerleştirilir.

**`PopupMenuButton<T>`:** `itemBuilder` menü satırlarını (`PopupMenuItem`) üretir; her öğenin `value` değeri `onSelected` ile gelir.

**`PopupMenuItem`:** Menüde tek satırlık seçenek; `child` genelde `Text`.

**`ScaffoldMessenger.of(context).showSnackBar`:** Ekranın altında kısa `SnackBar` gösterir; `Scaffold` olmadan da `Messenger` kökü üzerinden çalışır.

**`TextButton`:** Metin ağırlıklı, düz görünümlü düğme. **`ElevatedButton`:** Yükseltilmiş (gölgeli) dolu düğme. **`OutlinedButton`:** Çerçeveli, şeffaf dolgu.

**`DropdownButton<T>`:** `value` şu an seçili değer, `items` `DropdownMenuItem` listesi, `onChanged` seçim değişince çağrılır; `setState` ile `_fruit` güncellenir.

```dart
class ButtonsMenusPage extends StatefulWidget {
  const ButtonsMenusPage({super.key});

  @override
  State<ButtonsMenusPage> createState() => _ButtonsMenusPageState();
}

class _ButtonsMenusPageState extends State<ButtonsMenusPage> {
  String _fruit = 'elma';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Butonlar ve menüler'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Seçilen: $value')),
              );
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'a', child: Text('Seçenek A')),
              PopupMenuItem(value: 'b', child: Text('Seçenek B')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          TextButton(
            onPressed: () {},
            child: const Text('TextButton'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('ElevatedButton'),
          ),
          OutlinedButton(
            onPressed: () {},
            child: const Text('OutlinedButton'),
          ),
          const SizedBox(height: 24),
          DropdownButton<String>(
            value: _fruit,
            items: const [
              DropdownMenuItem(value: 'elma', child: Text('Elma')),
              DropdownMenuItem(value: 'armut', child: Text('Armut')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _fruit = v);
            },
          ),
        ],
        ),
      ),
    );
  }
}
```

Gövde **`SingleChildScrollView` + `Column`** ile sıralanır.

---

## Sayfa 4 — Listeler, `GridView`, diyaloglar, liste tıklama

### `ListView` ve `ListTile`

**`ListView`:** Dikey eksende kaydırılabilir sütun üretir. `children` ile widget listesi verilir; liste ekrandan uzunsa kullanıcı kaydırır. Uzun veri kümelerinde bellek için `ListView.builder` kullanılır (aşağıda).

**`ListTile`:** Material liste satırı şablonudur. `title` zorunlu ana satır; `subtitle`, `leading` (sol), `trailing` (sağ), `onTap` isteğe bağlıdır.

### `List.generate`, `List.map` ve `ListView(children: ...)`

**`List.generate`:** Verilen uzunlukta eleman üreten fabrika; burada metin etiketleri oluşturulur. **`map`:** Her öğeyi `ListTile`’a çevirir; `.toList()` ile `ListView`’in beklediği `List<Widget>` elde edilir.

**`ListView(children: ...)`:** Tüm çocukları bellekte tutar; kısa listeler için uygundur.

```dart
final items = List.generate(5, (i) => 'Öğe ${i + 1}');

ListView(
  children: items.map((e) => ListTile(title: Text(e))).toList(),
);
```

### `ListView.separated` ve `ListView.builder`

**`ListView.separated`:** Her iki öğe arasına `separatorBuilder` ile ayırıcı (burada `Divider`) koyar; liste görünümünde ince çizgiler için sık kullanılır.

**`ListView.builder`:** `itemCount` ve `itemBuilder` ile yalnızca görünür satırlar için widget üretir; uzun listelerde bellek dostudur.

**`Divider`:** Yatay ayırı çizgisi; `height` çizginin dikey alanını etkiler.

```dart
ListView.separated(
  itemCount: 20,
  separatorBuilder: (_, __) => const Divider(height: 1),
  itemBuilder: (context, index) {
    return ListTile(
      title: Text('Satır $index'),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tıklandı: $index')),
        );
      },
    );
  },
);
```

Burada **`ListTile`:** `title` satır metni, `onTap` dokununca `SnackBar` gösterir.

### `flutter_easyloading` (isteğe bağlı)

**`EasyLoading.show` / `dismiss`:** Tam ekran veya üst katmanda yükleme maskesi gösterir; ağ veya uzun işlem sırasında kullanılır. Uygulama açılışında `MaterialApp`’i paketin istediği `builder` ile sarmalamak gerekir (paket belgeleri).

`pubspec.yaml`:

```yaml
dependencies:
  flutter_easyloading: ^3.0.5
```

`MaterialApp` `builder` ile sarmalama ve `EasyLoading.init()` kurulumu paket belgelerinde yer alır. Örnek kullanım:

```dart
EasyLoading.show(status: 'Yükleniyor...');
// await işlem...
EasyLoading.dismiss();
```

Kalıcı yükleme çubuğu yerine kısa geri bildirim için `SnackBar` da kullanılabilir; liste `onTap` örnekleri buna göre yazılmıştır.

### `AlertDialog`, `ButtonBar`, `ListBody`

**`showDialog`:** Overlay üzerinde modal diyalog açar; `builder` içinde dönen widget (genelde `AlertDialog`) route olarak stack’e eklenir.

**`AlertDialog`:** `title`, `content`, `actions` alanları Material diyalog düzenine uyar.

**`SingleChildScrollView` (diyalog içinde):** Uzun içerik taşarsa kaydırma sağlar.

**`ListBody`:** Dikey olarak sıralanmış kısa metin blokları için kullanılır; `children` içinde birden fazla `Text` bir arada sunulur.

**`ButtonBar`:** `actions` satırında yatay düğüm grubu; `TextButton` / `FilledButton` yan yana hizalanır.

```dart
void _showAlert(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Başlık'),
      content: const SingleChildScrollView(
        child: ListBody(
          children: [
            Text('Birinci satır'),
            Text('İkinci satır'),
          ],
        ),
      ),
      actions: [
        ButtonBar(
          children: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Kapat'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tamam'),
            ),
          ],
        ),
      ],
    ),
  );
}
```

`showDialog` için `builder` içindeki `ctx`, diyaloğun kendi `Navigator` bağlamıdır; `Navigator.pop(ctx)` yalnızca diyaloğu kapatır.

### Listelerde taşma uyarısı

Uzun içerik `Column` içinde kalıp ekranı aşarsa sarı-siyah taşma çizgisi görülebilir. Çözüm: gövdeyi `ListView` yapmak veya `SingleChildScrollView` ile sarmalamak. `Row` içinde uzun `Text` için `Expanded` kullanımı gerekir.

### `GridView`

**`GridView.count`:** `crossAxisCount` sütun sayısını sabitler; `crossAxisSpacing` / `mainAxisSpacing` hücre aralığıdır. `children` ızgara hücrelerinin widget listesidir.

```dart
GridView.count(
  crossAxisCount: 2,
  crossAxisSpacing: 8,
  mainAxisSpacing: 8,
  children: List.generate(
    6,
    (i) => Container(
      color: Colors.indigo.shade50,
      alignment: Alignment.center,
      child: Text('Hücre $i'),
    ),
  ),
);
```

### Sayfa sınıfı birleşimi

**`FloatingActionButton`:** `Scaffold` üzerinde yüzen dairesel düğme; `onPressed` ile `_showAlert` tetiklenir. **`Icon`:** `Icons.*` sabitleri ile Material ikon fontundan glif çizer.

**İç içe `ListView`:** Dış gövde `ListView`; içerideki `ListView.separated` için **`shrinkWrap: true`** iç listenin yüksekliğinin tüm çocukları kadar olmasını sağlar (varsayılan olarak `ListView` sonsuz yükseklik ister). **`NeverScrollableScrollPhysics`:** İç listenin kendi kaydırmasını kapatır; kaydırma yalnız dış `ListView`’dedir (aksi halde iki kaydırıcı çakışır).

**`ListTile.leading`:** Satırın soluna ikon veya küçük avatar yerleştirir; `title` ile birlikte tipik liste satırı düzenini tamamlar.

**`SizedBox(height: ...)` + `GridView`:** Izgara sabit yükseklikli kutuda tutulur; aksi halde sınırsız yükseklik isteyen `GridView` üst `ListView` ile uyumsuzluk çıkarabilir.

```dart
class ListsDialogsPage extends StatelessWidget {
  const ListsDialogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listeler ve diyaloglar')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAlert(context),
        child: const Icon(Icons.message_outlined),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const ListTile(title: Text('Card içinde liste görünümü')),
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 8,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.circle_outlined),
                title: Text('Öğe $index'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Seçildi $index')),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              children: List.generate(
                9,
                (i) => Container(
                  color: Colors.deepPurple.shade50,
                  alignment: Alignment.center,
                  child: Text('$i'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

**Küçük uyarı:** İç içe kaydırılabilir liste (`ListView` içinde `ListView`) kaydırma çakışması doğurur; içteki listeye `shrinkWrap: true` ve `NeverScrollableScrollPhysics()` vermek burada yalnızca derlenebilir bir örnek için kullanılmıştır. Kalıcı çözümde genelde tek `ListView` veya `CustomScrollView` tercih edilir.

---

## Sayfa 5 — `GestureDetector`, `CustomScrollView`, `SliverAppBar`, `SliverList`, `SliverFixedExtentList`, `SliverGrid`

**`GestureDetector`:** `onTap`, `onLongPress` vb. jestleri dinler; görsel geri bildirim için çoğu yerde `InkWell` / `IconButton` tercih edilir.

**`CustomScrollView`:** `slivers` listesi alır; birden fazla kaydırılabilir parçayı tek bir kaydırma ekseninde birleştirir.

**`SliverAppBar`:** Kaydırınca davranabilen uygulama çubuğu; `pinned: true` üstte sabit kalır, `expandedHeight` + `FlexibleSpaceBar` genişleyen başlık alanı verir.

**`SliverList` + `SliverChildListDelegate`:** Statik widget listesini sliver olarak yerleştirir.

**`SliverFixedExtentList`:** Her öğenin yüksekliği `itemExtent` ile sabitlenir; `SliverChildBuilderDelegate` ile indeks bazlı üretim yapılır.

**`SliverGrid` + `SliverGridDelegateWithFixedCrossAxisCount`:** Sliver dünyasında ızgara; `childAspectRatio` hücre en/boy oranını belirler. `SliverChildBuilderDelegate` hücreleri tembel üretir.

```dart
class SliversGesturePage extends StatelessWidget {
  const SliversGesturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          debugPrint('Boş alana tap');
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 160,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('Sliver örnekleri'),
                background: Container(
                  color: Colors.deepPurple.shade100,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                List.generate(
                  5,
                  (i) => ListTile(title: Text('Statik sliver öğe $i')),
                ),
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 56,
              delegate: SliverChildBuilderDelegate(
                (context, index) => ListTile(
                  title: Text('Sabit yükseklik $index'),
                ),
                childCount: 6,
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                  alignment: Alignment.center,
                  color: Colors.teal.shade50,
                  child: Text('Grid $index'),
                ),
                childCount: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

`GestureDetector`, üst seviyede dokunmayı yakalar; kaydırma ile çakışma olmaması için genelde belirli bir `child` alanına vermek daha kontrollüdür. Burada tüm `CustomScrollView` sarılmıştır; gerektiğinde yalnızca bir `Container` veya `InkWell` hedeflenir.

---

## Dosyayı toparlama

Tüm `Page` sınıfları ve yardımcı widget’lar aynı `main.dart` dosyasında tutulabilir veya `lib/pages/` altına bölünebilir. Derleme için:

- `DecorationLayoutPage` içindeki `AssetImage` yolları `pubspec.yaml` ile eşleşmeli veya geçici olarak kaldırılmalıdır.
- Ağ görselleri için cihazın internete çıkabilmesi gerekir.

---

## İsimli rotalar

**`routes`:** String anahtar → `WidgetBuilder` eşlemesi; `initialRoute` veya varsayılan `/` ile açılış belirlenir. **`pushNamed`:** Bu haritadan route oluşturup stack’e ekler; `MaterialPageRoute` yazmadan sayfa açmanın kısa yoludur.

`MaterialApp` içinde:

```dart
routes: {
  '/': (context) => const HomePage(),
  '/decor': (context) => const DecorationLayoutPage(),
},
```

Geçiş: `Navigator.of(context).pushNamed('/decor');`. Parametreli rotalar için `onGenerateRoute` veya yönlendirme paketleri kullanılır. Yukarıdaki örnek sayfalar `MaterialPageRoute` ve `Navigator.push` ile açılmıştır.
