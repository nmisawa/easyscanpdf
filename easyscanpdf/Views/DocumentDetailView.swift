import PDFKit
import SwiftUI

struct DocumentDetailView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var editableTitle: String
    @State private var currentDocument: ScannedDocument
    @State private var isShowingShareSheet = false
    @State private var alertMessage: String?
    @State private var isSavingToPhotoLibrary = false
    @State private var savedToPhotoLibraryMessage: String?

    private let documentStore: DocumentStore
    private let imageExporter = PDFImageExporter()
    private let photoLibrarySaver = PhotoLibrarySaver()

    init(document: ScannedDocument, documentStore: DocumentStore) {
        _editableTitle = State(initialValue: document.title)
        _currentDocument = State(initialValue: document)
        self.documentStore = documentStore
    }

    var body: some View {
        List {
            Section(String(localized: "document_detail.section.preview")) {
                PDFPreviewView(url: currentDocument.pdfURL)
                    .frame(height: 420)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Section(String(localized: "document_detail.section.info")) {
                TextField(String(localized: "document_detail.field.title"), text: $editableTitle, axis: .vertical)
                    .onSubmit(saveTitleIfNeeded)

                LabeledContent(String(localized: "document_detail.label.created_at")) {
                    Text(currentDocument.createdAt.formatted(date: .abbreviated, time: .shortened))
                }

                LabeledContent(String(localized: "document_detail.label.page_count")) {
                    Text("\(currentDocument.pageCount)")
                }

                LabeledContent(String(localized: "document_detail.label.filename")) {
                    Text(currentDocument.pdfURL.lastPathComponent)
                        .lineLimit(1)
                }
            }

            Section(String(localized: "document_detail.section.ocr")) {
                if currentDocument.fullText.isEmpty {
                    Text(String(localized: "document_detail.ocr.empty"))
                        .foregroundStyle(.secondary)
                } else {
                    Text(currentDocument.fullText)
                        .textSelection(.enabled)
                        .font(.body.monospaced())
                }
            }
        }
        .navigationTitle(currentDocument.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(String(localized: "common.save")) {
                    saveTitleIfNeeded()
                }

                Button {
                    isShowingShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }

                if isSavingToPhotoLibrary {
                    ProgressView()
                } else {
                    Menu {
                        Button(String(localized: "document_detail.action.save_as_png")) {
                            saveToPhotoLibrary(format: .png)
                        }
                        Button(String(localized: "document_detail.action.save_as_jpeg")) {
                            saveToPhotoLibrary(format: .jpeg(quality: 0.9))
                        }
                    } label: {
                        Image(systemName: "photo")
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingShareSheet) {
            ShareSheet(activityItems: [currentDocument.pdfURL])
        }
        .alert(String(localized: "common.error"), isPresented: Binding(
            get: { alertMessage != nil },
            set: { if !$0 { alertMessage = nil } }
        )) {
            Button(String(localized: "common.ok"), role: .cancel) {}
        } message: {
            Text(alertMessage ?? "")
        }
        .alert(String(localized: "common.done"), isPresented: Binding(
            get: { savedToPhotoLibraryMessage != nil },
            set: { if !$0 { savedToPhotoLibraryMessage = nil } }
        )) {
            Button(String(localized: "common.ok"), role: .cancel) {}
        } message: {
            Text(savedToPhotoLibraryMessage ?? "")
        }
    }

    private func saveToPhotoLibrary(format: ImageExportFormat) {
        isSavingToPhotoLibrary = true

        Task {
            defer { isSavingToPhotoLibrary = false }

            do {
                let images = try imageExporter.renderImages(from: currentDocument.pdfURL)
                try await photoLibrarySaver.save(images: images, format: format)
                savedToPhotoLibraryMessage = String(localized: "document_detail.photo_save.success")
            } catch {
                alertMessage = error.localizedDescription
            }
        }
    }

    private func saveTitleIfNeeded() {
        let trimmed = editableTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false, trimmed != currentDocument.title else { return }

        do {
            try documentStore.updateTitle(documentID: currentDocument.id, title: trimmed)
            currentDocument = documentStore.documents.first(where: { $0.id == currentDocument.id }) ?? currentDocument
            editableTitle = currentDocument.title
        } catch {
            alertMessage = error.localizedDescription
        }
    }
}
