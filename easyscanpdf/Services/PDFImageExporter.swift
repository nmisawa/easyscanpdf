import PDFKit
import UIKit

enum ImageExportFormat {
    case png
    case jpeg(quality: CGFloat)

    var fileExtension: String {
        switch self {
        case .png: return "png"
        case .jpeg: return "jpg"
        }
    }

    func data(from image: UIImage) -> Data? {
        switch self {
        case .png:
            return image.pngData()
        case .jpeg(let quality):
            return image.jpegData(compressionQuality: quality)
        }
    }
}

enum PDFImageExporterError: LocalizedError {
    case documentUnreadable
    case imageConversionFailed

    var errorDescription: String? {
        switch self {
        case .documentUnreadable:
            return String(localized: "pdf.error.document_unreadable")
        case .imageConversionFailed:
            return String(localized: "pdf.error.image_conversion_failed")
        }
    }
}

struct PDFImageExporter {
    /// PDFの各ページをUIImageとしてレンダリングする。
    /// `maxDimension` はページの長辺のピクセル数上限（写真として十分な解像度に収めるため）。
    func renderImages(from pdfURL: URL, maxDimension: CGFloat = 2480) throws -> [UIImage] {
        guard let document = PDFDocument(url: pdfURL), document.pageCount > 0 else {
            throw PDFImageExporterError.documentUnreadable
        }

        var images: [UIImage] = []

        for pageIndex in 0..<document.pageCount {
            guard let page = document.page(at: pageIndex) else { continue }
            let pageRect = page.bounds(for: .mediaBox)

            let longestSide = max(pageRect.width, pageRect.height)
            let scale = longestSide > 0 ? min(maxDimension / longestSide, 2) : 1
            let targetSize = CGSize(
                width: (pageRect.width * scale).rounded(),
                height: (pageRect.height * scale).rounded()
            )

            // format.scale を明示的に 1 にしないと、端末の画面倍率(2x/3x)が
            // targetSize にさらに乗算され、ピクセル数・ファイルサイズが暴走する。
            let format = UIGraphicsImageRendererFormat()
            format.scale = 1
            format.opaque = true

            let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
            let image = renderer.image { context in
                UIColor.white.setFill()
                context.fill(CGRect(origin: .zero, size: targetSize))

                context.cgContext.translateBy(x: 0, y: targetSize.height)
                context.cgContext.scaleBy(x: scale, y: -scale)
                page.draw(with: .mediaBox, to: context.cgContext)
            }

            images.append(image)
        }

        return images
    }
}
