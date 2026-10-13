# PDF araçları

Prezi veya slayt export’u gibi **metin katmanı olmayan** PDF’leri okumak için sayfaları PNG’ye dönüştürür. macOS’ta **PDFKit** kullanır; ek Python paketi gerekmez.

## `render_pdf.swift`

Her sayfayı `page-01.png`, `page-02.png`, … olarak yazar.

### Gereksinim

- macOS
- Xcode Command Line Tools (Swift derleyicisi)

### Kullanım

Depo kökünden:

```bash
swift tools/pdf/render_pdf.swift "<pdf-dosya-yolu>" "<cikti-klasoru>" [olcek]
```

| Argüman | Açıklama |
|--------|----------|
| `pdf-path` | Mutlak veya göreli PDF yolu |
| `output-dir` | PNG’lerin yazılacağı klasör (yoksa oluşturulur) |
| `scale` | İsteğe bağlı yakınlaştırma (varsayılan `1.5`) |

### Örnek

```bash
mkdir -p tools/pdf/output/hafta-2
swift tools/pdf/render_pdf.swift \
  "dersler/robotik-uygulamalar/articles/Hafta 2: Robotik sistem bileşenlerinin işleyişi ve entegrasyonu üzerine bir inceleme..pdf" \
  "tools/pdf/output/hafta-2"
```

Ardından slayt metni / hoca notu için `tools/pdf/output/hafta-2/page-*.png` dosyaları görsel olarak incelenir.

### Çıktı klasörü

`tools/pdf/output/` geçici çalışma alanıdır; `.gitignore` içindedir. Kalıcı içerik üretmeyin; iş bitince silinebilir.

### Ne zaman kullanılır?

- PDF’den metin çıkarılamıyorsa (`pdftotext` / `pypdf` boş)
- Sayfa sayfa slayt içeriği (hoca notu, özet, çeviri) gerekiyorsa
- Prezi genel harita sayfaları gibi tek karede birden fazla slayt varsa: ilgili sayfalar ayrıca yakınlaştırılmış export alınabilir

### Ne zaman kullanılmaz?

- Seçilebilir metin içeren normal PDF’lerde doğrudan metin çıkarma yeterliyse
- Linux/CI ortamında (bu betik yalnızca macOS)
