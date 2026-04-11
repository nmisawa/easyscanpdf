import Foundation

struct OCRPageResult: Codable, Hashable {
    let pageIndex: Int
    let recognizedText: String
    let textBoxes: [OCRTextBox]
}
