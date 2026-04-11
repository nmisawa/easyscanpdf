import Foundation

struct ScannedDocument: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    let createdAt: Date
    let pdfURL: URL
    let thumbnailURL: URL?
    let pageCount: Int
    let fullText: String
}
