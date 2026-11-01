import FirebaseAnalytics
import FirebaseCore
import Foundation

/// Firebase Analytics の薄いラッパー。
/// 書類の画像・OCR テキスト・タイトルなどのユーザーコンテンツは送信せず、操作回数やページ数などの集計値のみを記録する。
/// `GoogleService-Info.plist` がバンドルに含まれない場合（公開サンプルとしてのビルドなど）は何もしない。
enum AnalyticsService {
    private(set) static var isEnabled = false

    static func configure() {
        guard FirebaseApp.app() == nil,
              Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil else { return }
        FirebaseApp.configure()
        isEnabled = true
    }

    static func log(_ event: Event) {
        guard isEnabled else { return }
        Analytics.logEvent(event.name, parameters: event.parameters)
    }

    enum Event {
        case scanCompleted(pageCount: Int)
        case scanFailed
        case pdfShareOpened
        case photoExported(format: String, pageCount: Int)
        case documentsDeleted(count: Int)
        case onboardingFinished(startedScan: Bool)

        var name: String {
            switch self {
            case .scanCompleted: "scan_completed"
            case .scanFailed: "scan_failed"
            case .pdfShareOpened: "pdf_share_opened"
            case .photoExported: "photo_exported"
            case .documentsDeleted: "documents_deleted"
            case .onboardingFinished: "onboarding_finished"
            }
        }

        var parameters: [String: Any]? {
            switch self {
            case let .scanCompleted(pageCount):
                ["page_count": pageCount]
            case .scanFailed, .pdfShareOpened:
                nil
            case let .photoExported(format, pageCount):
                ["format": format, "page_count": pageCount]
            case let .documentsDeleted(count):
                ["count": count]
            case let .onboardingFinished(startedScan):
                ["started_scan": startedScan ? 1 : 0]
            }
        }
    }
}
