import UIKit
import Vision

enum OCRServiceError: LocalizedError {
    case cgImageUnavailable

    var errorDescription: String? {
        switch self {
        case .cgImageUnavailable:
            return String(localized: "ocr.error.cgimage_unavailable")
        }
    }
}

struct OCRService {
    func recognizeText(in images: [UIImage]) async throws -> [OCRPageResult] {
        try await withThrowingTaskGroup(of: OCRPageResult.self) { group in
            for (index, image) in images.enumerated() {
                group.addTask {
                    try await recognizeText(in: image, pageIndex: index)
                }
            }

            var results: [OCRPageResult] = []
            for try await result in group {
                results.append(result)
            }

            return results.sorted { $0.pageIndex < $1.pageIndex }
        }
    }

    private func recognizeText(in image: UIImage, pageIndex: Int) async throws -> OCRPageResult {
        guard let cgImage = image.cgImage else {
            throw OCRServiceError.cgImageUnavailable
        }

        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let observations = (request.results as? [VNRecognizedTextObservation]) ?? []
                let textBoxes = observations.compactMap { observation -> OCRTextBox? in
                    guard let candidate = observation.topCandidates(1).first else { return nil }
                    return OCRTextBox(
                        text: candidate.string,
                        boundingBox: observation.boundingBox,
                        confidence: observation.confidence
                    )
                }

                let pageText = textBoxes.map(\.text).joined(separator: "\n")
                continuation.resume(
                    returning: OCRPageResult(
                        pageIndex: pageIndex,
                        recognizedText: pageText,
                        textBoxes: textBoxes
                    )
                )
            }

            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            request.recognitionLanguages = ["ja-JP", "en-US"]

            let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up, options: [:])

            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
