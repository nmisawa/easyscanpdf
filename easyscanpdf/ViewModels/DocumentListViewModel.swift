import Combine
import Foundation
import SwiftUI

@MainActor
final class DocumentListViewModel: ObservableObject {
    @Published private(set) var documents: [ScannedDocument] = []
    @Published var selectedDocument: ScannedDocument?
    @Published var isShowingScanner = false
    @Published var alertMessage: String?

    let documentStore: DocumentStore
    let scanFlowViewModel: ScanFlowViewModel

    init(documentStore: DocumentStore) {
        self.documentStore = documentStore
        self.scanFlowViewModel = ScanFlowViewModel(documentStore: documentStore)
        self.documents = documentStore.documents
        bindStore()
    }

    func refresh() {
        documents = documentStore.documents
    }

    func startScan() {
        do {
            try scanFlowViewModel.prepareScan()
            isShowingScanner = true
        } catch {
            alertMessage = error.localizedDescription
        }
    }

    func scanCompleted(with document: ScannedDocument) {
        isShowingScanner = false
        selectedDocument = document
        refresh()
    }

    func scanFailed(_ error: Error) {
        isShowingScanner = false
        alertMessage = error.localizedDescription
    }

    func deleteDocuments(at offsets: IndexSet) {
        let ids = offsets.map { documents[$0].id }
        deleteDocuments(withIDs: ids)
    }

    func deleteDocument(_ document: ScannedDocument) {
        deleteDocuments(withIDs: [document.id])
    }

    private func deleteDocuments(withIDs ids: [UUID]) {
        do {
            try documentStore.deleteDocuments(withIDs: ids)

            if let selectedDocument, ids.contains(selectedDocument.id) {
                self.selectedDocument = nil
            }
        } catch {
            alertMessage = error.localizedDescription
        }
    }

    private func bindStore() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            for await docs in documentStore.$documents.values {
                self.documents = docs
            }
        }
    }
}
