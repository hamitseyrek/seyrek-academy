import PDFKit
import AppKit

let args = CommandLine.arguments
guard args.count >= 3 else {
    fputs("usage: render_pdf.swift <pdf-path> <output-dir> [scale]\n", stderr)
    fputs("  scale: optional zoom factor (default 1.5)\n", stderr)
    exit(1)
}
let pdfPath = args[1]
let outDir = args[2]
let scale = args.count >= 4 ? (CGFloat(Double(args[3]) ?? 1.5)) : 1.5

let url = URL(fileURLWithPath: pdfPath)
guard let doc = PDFDocument(url: url) else {
    fputs("failed to open pdf: \(pdfPath)\n", stderr)
    exit(2)
}

let count = doc.pageCount
print("pages \(count)")
let fm = FileManager.default
try? fm.createDirectory(atPath: outDir, withIntermediateDirectories: true)

for i in 0..<count {
    guard let page = doc.page(at: i) else { continue }
    let bounds = page.bounds(for: .mediaBox)
    let w = Int(bounds.width * scale)
    let h = Int(bounds.height * scale)
    let img = NSImage(size: NSSize(width: w, height: h))
    img.lockFocus()
    if let ctx = NSGraphicsContext.current?.cgContext {
        ctx.setFillColor(NSColor.white.cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: w, height: h))
        ctx.scaleBy(x: scale, y: scale)
        page.draw(with: .mediaBox, to: ctx)
    }
    img.unlockFocus()
    guard let tiff = img.tiffRepresentation,
          let rep = NSBitmapImageRep(data: tiff),
          let png = rep.representation(using: .png, properties: [:]) else { continue }
    let out = "\(outDir)/page-\(String(format: "%02d", i + 1)).png"
    try? png.write(to: URL(fileURLWithPath: out))
}
print("done")
