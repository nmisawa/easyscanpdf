import Combine
import Foundation
import UIKit

enum ScanFlowError: LocalizedError {
    case noPages

    var errorDescription: String? {
        switch self {
        case .noPages:
            return String(localized: "scanflow.error.no_pages")
        }
    }
}

@MainActor
final class ScanFlowViewModel: ObservableObject {
    @Published var isProcessing = false
    @Published var progressMessage = ""

    private let scannerService = DocumentScannerService()
    private let ocrService = OCRService()
    private let pdfGenerationService = PDFGenerationService()
    private let documentStore: DocumentStore

    init(documentStore: DocumentStore) {
        self.documentStore = documentStore
    }

    func prepareScan() throws {
        try scannerService.validateAvailability()
    }

    func handleScannedImages(_ images: [UIImage]) async throws -> ScannedDocument {
        guard images.isEmpty == false else {
            throw ScanFlowError.noPages
        }

        isProcessing = true
        defer { isProcessing = false }

        progressMessage = String(localized: "scanflow.progress.ocr")
        let normalizedImages = images.map(ImageOrientationNormalizer.normalize)
        let ocrResults = try await ocrService.recognizeText(in: normalizedImages)

        progressMessage = String(localized: "scanflow.progress.pdf")
        let output = try pdfGenerationService.generatePDF(images: normalizedImages, ocrResults: ocrResults)
        let thumbnailData = try pdfGenerationService.makeThumbnailData(from: normalizedImages[0])

        progressMessage = String(localized: "scanflow.progress.save")
        return try documentStore.saveDocument(
            title: Self.defaultTitle(),
            pdfData: output.data,
            thumbnailData: thumbnailData,
            pageCount: output.pageCount,
            fullText: output.fullText
        )
    }

    static func defaultTitle(from date: Date = .now) -> String {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.dateFormat = "yyyy-MM-dd HH.mm"
        return String(
            format: String(localized: "scanflow.default_title"),
            locale: .autoupdatingCurrent,
            formatter.string(from: date)
        )
    }
}
