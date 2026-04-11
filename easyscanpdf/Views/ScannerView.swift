import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    let onCompletion: (Result<[UIImage], Error>) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onCompletion: onCompletion)
    }

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let controller = VNDocumentCameraViewController()
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private let scannerService = DocumentScannerService()
        private let onCompletion: (Result<[UIImage], Error>) -> Void

        init(onCompletion: @escaping (Result<[UIImage], Error>) -> Void) {
            self.onCompletion = onCompletion
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
        }

        func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFailWithError error: Error
        ) {
            controller.dismiss(animated: true)
            onCompletion(.failure(error))
        }

        func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFinishWith scan: VNDocumentCameraScan
        ) {
            controller.dismiss(animated: true)

            do {
                let images = try scannerService.extractImages(from: scan)
                onCompletion(.success(images))
            } catch {
                onCompletion(.failure(error))
            }
        }
    }
}
