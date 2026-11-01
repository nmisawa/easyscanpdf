import SwiftUI

@main
struct ScanToPDFApp: App {
    @StateObject private var documentStore = DocumentStore()

    init() {
        AnalyticsService.configure()
    }

    var body: some Scene {
        WindowGroup {
            DocumentListView(viewModel: DocumentListViewModel(documentStore: documentStore))
        }
    }
}
