import UIKit
import VisionKit

enum DocumentScannerServiceError: LocalizedError {
    case scannerUnavailable
    case emptyScan

    var errorDescription: String? {
        switch self {
        case .scannerUnavailable:
            return String(localized: "scanner.error.unavailable")
        case .emptyScan:
            return String(localized: "scanner.error.empty")
        }
    }
}

struct DocumentScannerService {
    func validateAvailability() throws {
        guard VNDocumentCameraViewController.isSupported else {
            throw DocumentScannerServiceError.scannerUnavailable
        }
    }

    func extractImages(from scan: VNDocumentCameraScan) throws -> [UIImage] {
        let images = (0..<scan.pageCount).map { index in
            ImageOrientationNormalizer.normalize(scan.imageOfPage(at: index))
        }

        guard images.isEmpty == false else {
            throw DocumentScannerServiceError.emptyScan
        }

        return images
    }
}
