import Combine
import Foundation

@MainActor
final class DocumentStore: ObservableObject {
    @Published private(set) var documents: [ScannedDocument] = []

    private let fileManager = FileManager.default
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    private let documentsDirectory: URL
    private let metadataURL: URL
    private let pdfDirectory: URL
    private let thumbnailDirectory: URL

    init() {
        let baseDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("EasyScanStorage", isDirectory: true)
        self.documentsDirectory = baseDirectory
        self.metadataURL = baseDirectory.appendingPathComponent("documents.json")
        self.pdfDirectory = baseDirectory.appendingPathComponent("PDFs", isDirectory: true)
        self.thumbnailDirectory = baseDirectory.appendingPathComponent("Thumbnails", isDirectory: true)

        do {
            try prepareDirectories()
            try loadDocuments()
        } catch {
            self.documents = []
            print("DocumentStore init error: \(error.localizedDescription)")
        }
    }

    init(previewDocuments: [ScannedDocument]) {
        let baseDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("EasyScanPreview", isDirectory: true)
        self.documentsDirectory = baseDirectory
        self.metadataURL = baseDirectory.appendingPathComponent("documents.json")
        self.pdfDirectory = baseDirectory.appendingPathComponent("PDFs", isDirectory: true)
        self.thumbnailDirectory = baseDirectory.appendingPathComponent("Thumbnails", isDirectory: true)
        self.documents = previewDocuments
    }

    func saveDocument(
        title: String,
        pdfData: Data,
        thumbnailData: Data?,
        pageCount: Int,
        fullText: String
    ) throws -> ScannedDocument {
        try prepareDirectories()

        let id = UUID()
        let pdfURL = pdfDirectory.appendingPathComponent("\(id.uuidString).pdf")
        try pdfData.write(to: pdfURL, options: .atomic)

        var thumbnailURL: URL?
        if let thumbnailData {
            let url = thumbnailDirectory.appendingPathComponent("\(id.uuidString).jpg")
            try thumbnailData.write(to: url, options: .atomic)
            thumbnailURL = url
        }

        let document = ScannedDocument(
            id: id,
            title: title,
            createdAt: Date(),
            pdfURL: pdfURL,
            thumbnailURL: thumbnailURL,
            pageCount: pageCount,
            fullText: fullText
        )

        documents.insert(document, at: 0)
        try persistDocuments()
        return document
    }

    func updateTitle(documentID: UUID, title: String) throws {
        guard let index = documents.firstIndex(where: { $0.id == documentID }) else { return }
        documents[index].title = title
        try persistDocuments()
    }

    func deleteDocuments(withIDs ids: [UUID]) throws {
        guard ids.isEmpty == false else { return }

        let documentsToDelete = documents.filter { ids.contains($0.id) }

        for document in documentsToDelete {
            if fileManager.fileExists(atPath: document.pdfURL.path) {
                try fileManager.removeItem(at: document.pdfURL)
            }

            if let thumbnailURL = document.thumbnailURL, fileManager.fileExists(atPath: thumbnailURL.path) {
                try fileManager.removeItem(at: thumbnailURL)
            }
        }

        documents.removeAll { ids.contains($0.id) }
        try persistDocuments()
    }

    func reload() throws {
        try loadDocuments()
    }

    private func prepareDirectories() throws {
        try fileManager.createDirectory(at: documentsDirectory, withIntermediateDirectories: true)
        try fileManager.createDirectory(at: pdfDirectory, withIntermediateDirectories: true)
        try fileManager.createDirectory(at: thumbnailDirectory, withIntermediateDirectories: true)
    }

    private func loadDocuments() throws {
        guard fileManager.fileExists(atPath: metadataURL.path) else {
            documents = []
            return
        }

        let data = try Data(contentsOf: metadataURL)
        documents = try decoder.decode([ScannedDocument].self, from: data)
            .sorted { $0.createdAt > $1.createdAt }
    }

    private func persistDocuments() throws {
        let data = try encoder.encode(documents)
        try data.write(to: metadataURL, options: .atomic)
    }
}
