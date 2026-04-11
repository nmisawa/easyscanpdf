import CoreGraphics
import Foundation

struct OCRTextBox: Codable, Hashable {
    let text: String
    let boundingBox: CGRect
    let confidence: Float
}
