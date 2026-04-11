import UIKit

enum PDFGenerationServiceError: LocalizedError {
    case pageCountMismatch
    case jpegConversionFailed

    var errorDescription: String? {
        switch self {
        case .pageCountMismatch:
            return String(localized: "pdf.error.page_count_mismatch")
        case .jpegConversionFailed:
            return String(localized: "pdf.error.thumbnail_failed")
        }
    }
}

struct PDFOutput {
    let data: Data
    let fullText: String
    let pageCount: Int
}

struct PDFGenerationService {
    func generatePDF(images: [UIImage], ocrResults: [OCRPageResult]) throws -> PDFOutput {
        guard images.count == ocrResults.count else {
            throw PDFGenerationServiceError.pageCountMismatch
        }

        let metadata = [
            kCGPDFContextCreator as String: String(localized: "app.name"),
            kCGPDFContextAuthor as String: String(localized: "app.name"),
            kCGPDFContextTitle as String: String(localized: "pdf.metadata.title")
        ]

        let firstImageSize = images.first?.size ?? CGSize(width: 595, height: 842)
        let renderer = UIGraphicsPDFRenderer(
            bounds: CGRect(origin: .zero, size: firstImageSize),
            format: {
                let format = UIGraphicsPDFRendererFormat()
                format.documentInfo = metadata
                return format
            }()
        )

        let data = renderer.pdfData { context in
            for (image, result) in zip(images, ocrResults) {
                let pageRect = CGRect(origin: .zero, size: image.size)
                context.beginPage(withBounds: pageRect, pageInfo: [:])

                image.draw(in: pageRect)
                drawInvisibleText(result.textBoxes, in: pageRect)
            }
        }

        return PDFOutput(
            data: data,
            fullText: ocrResults.map(\.recognizedText).joined(separator: "\n\n"),
            pageCount: images.count
        )
    }

    func makeThumbnailData(from image: UIImage, maxDimension: CGFloat = 400) throws -> Data {
        let aspectRatio = image.size.width / max(image.size.height, 1)
        let targetSize: CGSize

        if aspectRatio >= 1 {
            targetSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
        } else {
            targetSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
        }

        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = true
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        let scaled = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }

        guard let data = scaled.jpegData(compressionQuality: 0.8) else {
            throw PDFGenerationServiceError.jpegConversionFailed
        }
        return data
    }

    private func drawInvisibleText(_ textBoxes: [OCRTextBox], in pageRect: CGRect) {
        for textBox in textBoxes where textBox.text.isEmpty == false {
            let drawRect = BoundingBoxConverter.visionNormalizedRectToPDFRect(
                textBox.boundingBox,
                pageSize: pageRect.size
            )

            guard drawRect.width > 2, drawRect.height > 2 else { continue }

            let fontSize = max(8, drawRect.height * 0.85)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            paragraphStyle.lineBreakMode = .byClipping

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize),
                .foregroundColor: UIColor.black.withAlphaComponent(0.01),
                .paragraphStyle: paragraphStyle
            ]

            NSString(string: textBox.text).draw(in: drawRect, withAttributes: attributes)
        }
    }
}
