import Foundation
import PDFKit

let args = CommandLine.arguments
guard args.count >= 3 else {
    print("Kullanım: swift tools/pdf/render_pdf.swift <pdf-yolu> <cikti-klasoru> [olcek]")
    exit(1)
}

let pdfPath = args[1]
let outputDir = args[2]
let scale: CGFloat = args.count >= 4 ? CGFloat(Double(args[3]) ?? 2.0) : 2.0

let pdfUrl = URL(fileURLWithPath: pdfPath)
guard let doc = PDFDocument(url: pdfUrl) else {
    print("Hata: PDF açılamadı: \(pdfPath)")
    exit(1)
}

let fileManager = FileManager.default
try? fileManager.createDirectory(atPath: outputDir, withIntermediateDirectories: true, attributes: nil)

print("PDF yüklendi: \(pdfPath), Toplam sayfa: \(doc.pageCount)")

for i in 0..<doc.pageCount {
    guard let page = doc.page(at: i) else { continue }
    let pageRect = page.bounds(for: .mediaBox)
    let width = Int(pageRect.width * scale)
    let height = Int(pageRect.height * scale)

    let colorSpace = CGColorSpaceCreateDeviceRGB()
    guard let context = CGContext(
        data: nil,
        width: width,
        height: height,
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: colorSpace,
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    ) else {
        continue
    }

    context.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1))
    context.fill(CGRect(x: 0, y: 0, width: width, height: height))

    context.scaleBy(x: scale, y: scale)
    page.draw(with: .mediaBox, to: context)

    guard let cgImage = context.makeImage() else { continue }
    let pageNum = String(format: "%02d", i + 1)
    let destUrl = URL(fileURLWithPath: "\(outputDir)/page_\(pageNum).png")

    guard let destination = CGImageDestinationCreateWithURL(destUrl as CFURL, "public.png" as CFString, 1, nil) else {
        continue
    }
    CGImageDestinationAddImage(destination, cgImage, nil)
    CGImageDestinationFinalize(destination)
    print("Sayfa \(i + 1) kaydedildi -> page_\(pageNum).png")
}

print("Tamamlandı: \(outputDir)")
