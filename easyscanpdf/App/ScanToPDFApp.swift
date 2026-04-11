import SwiftUI

@main
struct ScanToPDFApp: App {
    @StateObject private var documentStore = DocumentStore()

    var body: some Scene {
        WindowGroup {
            DocumentListView(viewModel: DocumentListViewModel(documentStore: documentStore))
        }
    }
}
