import Photos
import UIKit

enum PhotoLibrarySaverError: LocalizedError {
    case accessDenied
    case imageConversionFailed

    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return String(localized: "photo.error.access_denied")
        case .imageConversionFailed:
            return String(localized: "pdf.error.image_conversion_failed")
        }
    }
}

struct PhotoLibrarySaver {
    /// 画像をフォトライブラリに書き出す。指定フォーマットのデータを一時ファイルに変換してから追加することで、
    /// PNG/JPEG の形式をそのまま維持して保存する。
    func save(images: [UIImage], format: ImageExportFormat) async throws {
        let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        guard status == .authorized || status == .limited else {
            throw PhotoLibrarySaverError.accessDenied
        }

        let tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("PhotoExport-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDirectory) }

        var fileURLs: [URL] = []
        for (index, image) in images.enumerated() {
            guard let data = format.data(from: image) else {
                throw PhotoLibrarySaverError.imageConversionFailed
            }
            let fileURL = tempDirectory.appendingPathComponent("page_\(index + 1).\(format.fileExtension)")
            try data.write(to: fileURL, options: .atomic)
            fileURLs.append(fileURL)
        }

        try await PHPhotoLibrary.shared().performChanges {
            for fileURL in fileURLs {
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: .photo, fileURL: fileURL, options: nil)
            }
        }
    }
}
