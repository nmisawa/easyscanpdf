import SwiftUI

struct DocumentListView: View {
    @StateObject private var viewModel: DocumentListViewModel
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var isShowingOnboarding = false
    @State private var shouldStartScanAfterOnboarding = false

    init(viewModel: DocumentListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.documents) { document in
                    NavigationLink(value: document) {
                        DocumentRowView(document: document)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            viewModel.deleteDocument(document)
                        } label: {
                            Label(String(localized: "common.delete"), systemImage: "trash")
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteDocuments)
            }
            .overlay {
                if viewModel.documents.isEmpty {
                    ContentUnavailableView(
                        String(localized: "document_list.empty.title"),
                        systemImage: "doc.text.viewfinder",
                        description: Text(String(localized: "document_list.empty.description"))
                    )
                }
            }
            .navigationTitle(String(localized: "app.name"))
            .navigationDestination(item: $viewModel.selectedDocument) { document in
                DocumentDetailView(document: document, documentStore: viewModel.documentStore)
            }
            .navigationDestination(for: ScannedDocument.self) { document in
                DocumentDetailView(document: document, documentStore: viewModel.documentStore)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.startScan()
                    } label: {
                        Label(String(localized: "document_list.action.new_scan"), systemImage: "plus.viewfinder")
                    }
                }
            }
            .sheet(isPresented: $viewModel.isShowingScanner) {
                ScannerSheet(viewModel: viewModel)
            }
            .sheet(isPresented: $isShowingOnboarding, onDismiss: handleOnboardingDismiss) {
                OnboardingView(
                    onClose: { completeOnboarding(shouldStartScan: false) },
                    onStartScan: { completeOnboarding(shouldStartScan: true) }
                )
                .interactiveDismissDisabled()
            }
            .alert(String(localized: "common.error"), isPresented: Binding(
                get: { viewModel.alertMessage != nil },
                set: { if !$0 { viewModel.alertMessage = nil } }
            )) {
                Button(String(localized: "common.ok"), role: .cancel) {}
            } message: {
                Text(viewModel.alertMessage ?? "")
            }
            .task {
                guard hasCompletedOnboarding == false, isShowingOnboarding == false else { return }
                isShowingOnboarding = true
            }
        }
    }

    private func completeOnboarding(shouldStartScan: Bool) {
        hasCompletedOnboarding = true
        shouldStartScanAfterOnboarding = shouldStartScan
        isShowingOnboarding = false
    }

    private func handleOnboardingDismiss() {
        guard shouldStartScanAfterOnboarding else { return }
        shouldStartScanAfterOnboarding = false
        viewModel.startScan()
    }
}

private struct ScannerSheet: View {
    @ObservedObject var viewModel: DocumentListViewModel

    var body: some View {
        ZStack {
            ScannerView { result in
                switch result {
                case .success(let images):
                    Task {
                        do {
                            let document = try await viewModel.scanFlowViewModel.handleScannedImages(images)
                            viewModel.scanCompleted(with: document)
                        } catch {
                            viewModel.scanFailed(error)
                        }
                    }
                case .failure(let error):
                    viewModel.scanFailed(error)
                }
            }

            if viewModel.scanFlowViewModel.isProcessing {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()

                ProgressView(viewModel.scanFlowViewModel.progressMessage)
                    .padding(24)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

private struct DocumentRowView: View {
    let document: ScannedDocument

    var body: some View {
        HStack(spacing: 12) {
            ThumbnailView(url: document.thumbnailURL)
                .frame(width: 64, height: 84)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 6) {
                Text(document.title)
                    .font(.headline)
                    .lineLimit(2)

                Text(document.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(
                    String(
                        format: String(localized: "document.row.page_count"),
                        locale: .autoupdatingCurrent,
                        document.pageCount
                    )
                )
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct ThumbnailView: View {
    let url: URL?

    var body: some View {
        Group {
            if let url, let image = UIImage(contentsOfFile: url.path) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.secondary.opacity(0.15))
                    Image(systemName: "doc.richtext")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

private struct OnboardingView: View {
    let onClose: () -> Void
    let onStartScan: () -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "onboarding.title"))
                        .font(.system(.largeTitle, design: .default, weight: .bold))

                    Text(String(localized: "onboarding.subtitle"))
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 16) {
                    OnboardingStepView(
                        icon: "camera.viewfinder",
                        title: String(localized: "onboarding.step.scan.title"),
                        description: String(localized: "onboarding.step.scan.description")
                    )
                    OnboardingStepView(
                        icon: "character.textbox",
                        title: String(localized: "onboarding.step.ocr.title"),
                        description: String(localized: "onboarding.step.ocr.description")
                    )
                    OnboardingStepView(
                        icon: "doc.text.magnifyingglass",
                        title: String(localized: "onboarding.step.save.title"),
                        description: String(localized: "onboarding.step.save.description")
                    )
                }

                Text(String(localized: "onboarding.footnote"))
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Spacer()

                VStack(spacing: 12) {
                    Button(action: onStartScan) {
                        Text(String(localized: "onboarding.action.start_scan"))
                            .font(.headline)
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.borderedProminent)

                    Button(action: onClose) {
                        Text(String(localized: "onboarding.action.later"))
                            .font(.headline)
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(24)
            .navigationBarBackButtonHidden()
        }
        .presentationDetents([.large])
    }
}

private struct OnboardingStepView: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: 28, height: 28)
                .padding(10)
                .background(Color.accentColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title3.weight(.semibold))

                Text(description)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

struct DocumentListView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentListView(viewModel: previewViewModel)
    }

    @MainActor
    private static var previewViewModel: DocumentListViewModel {
        let store = DocumentStore(previewDocuments: [
            ScannedDocument(
                id: UUID(),
                title: "請求書 2026年3月",
                createdAt: .now,
                pdfURL: URL(fileURLWithPath: "/tmp/preview-invoice.pdf"),
                thumbnailURL: nil,
                pageCount: 2,
                fullText: "株式会社サンプル\n請求金額: 12,000円"
            ),
            ScannedDocument(
                id: UUID(),
                title: "会議メモ",
                createdAt: .now.addingTimeInterval(-86_400),
                pdfURL: URL(fileURLWithPath: "/tmp/preview-note.pdf"),
                thumbnailURL: nil,
                pageCount: 1,
                fullText: "MVP 実装\nOCR\n検索可能 PDF"
            )
        ])
        let viewModel = DocumentListViewModel(documentStore: store)
        return viewModel
    }
}
