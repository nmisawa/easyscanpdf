# EasyScan PDF

EasyScan PDF は、書類をスキャンして OCR 付きの検索可能 PDF として保存する iOS アプリのコードサンプルです。
SwiftUI で構成されており、VisionKit で書類を取り込み、Vision で文字認識を行い、PDF 上に不可視テキストを重ねて検索可能な PDF を生成します。

## スクリーンショット

<!-- スクリーンショットをここに追加 -->

## このサンプルで学べること

- **VisionKit** (`VNDocumentCameraViewController`) を使った書類スキャン
- **Vision** (`VNRecognizeTextRequest`) を使った日英 OCR
- **UIGraphicsPDFRenderer** で画像＋不可視テキストを重ねた検索可能 PDF の生成
- **Swift Concurrency** (`async/await`, `withThrowingTaskGroup`) による並列 OCR 処理
- SwiftUI + MVVM によるアーキテクチャ構成

## 概要

紙の書類を iPhone / iPad で取り込み、あとから検索できる PDF として端末内に保存します。

```
カメラでスキャン → 画像の向き補正 → OCR 実行 → 検索可能 PDF 生成 → ローカル保存
```

## 主な機能

- 書類スキャン（複数ページ対応）
- OCR 実行（日本語・英語）
- 検索可能 PDF の生成
- ローカル保存
- 保存済み書類の一覧表示
- PDF プレビュー表示
- OCR テキスト表示
- タイトル編集
- PDF の共有

## 動作環境

- iOS 17.0 以上
- Xcode 16 以上
- カメラが使える iPhone / iPad

補足:

- 書類スキャンには VisionKit 対応デバイスが必要です
- 初回利用時にカメラ権限が必要です
- シミュレータでは実機と同じスキャン体験にならない場合があります

## セットアップ

1. `EasyScanPDF.xcodeproj` を Xcode で開く
2. ターゲット `EasyScan PDF` を選択し、Signing の Team を自分のアカウントに設定する
3. 実機でビルドして起動する

外部ライブラリは使っていないため、追加の依存関係インストールは不要です。

## 使い方

1. アプリを起動する
2. 右上のスキャンボタンを押す
3. 書類を撮影してスキャンを完了する
4. OCR と PDF 生成が完了するまで待つ
5. 一覧から保存済み書類を開く
6. 詳細画面で PDF、OCR テキスト、作成情報を確認する
7. 必要に応じてタイトルを編集し、PDF を共有する

## アーキテクチャ

```
easyscanpdf/
├── App/
│   └── ScanToPDFApp.swift          # エントリポイント
├── Models/
│   ├── ScannedDocument.swift       # 保存書類のモデル
│   ├── OCRPageResult.swift         # ページ単位の OCR 結果
│   └── OCRTextBox.swift            # OCR テキストと矩形情報
├── Views/
│   ├── DocumentListView.swift      # 書類一覧画面
│   ├── ScannerView.swift           # VNDocumentCameraViewController のラッパー
│   ├── DocumentDetailView.swift    # PDF プレビュー・OCR テキスト・タイトル編集・共有
│   ├── PDFPreviewView.swift        # PDFView のラッパー
│   └── ShareSheet.swift           # 共有シートのラッパー
├── ViewModels/
│   ├── DocumentListViewModel.swift # 一覧状態・スキャン開始・画面遷移・エラー表示の管理
│   └── ScanFlowViewModel.swift     # OCR・PDF 生成・保存までの処理フロー管理
├── Services/
│   ├── DocumentScannerService.swift # スキャナの利用可否確認とスキャン画像の抽出
│   ├── OCRService.swift            # OCR 実行（並列処理）
│   ├── PDFGenerationService.swift  # PDF 生成とサムネイル生成
│   └── DocumentStore.swift        # ローカル保存とメタデータ管理
└── Utilities/
    ├── ImageOrientationNormalizer.swift # 画像向きの補正
    └── BoundingBoxConverter.swift       # Vision の座標を PDF 描画座標へ変換
```

## 保存仕様

保存先はアプリの Documents 配下に作成される `EasyScanStorage` ディレクトリです。

```
EasyScanStorage/
├── documents.json
├── PDFs/<UUID>.pdf
└── Thumbnails/<UUID>.jpg
```

保持するメタデータ:

| フィールド | 内容 |
|---|---|
| `id` | UUID |
| `title` | 書類タイトル（初期値: `Scan yyyy-MM-dd HH.mm`） |
| `createdAt` | 作成日時 |
| `pdfURL` | PDF ファイルパス |
| `thumbnailURL` | サムネイルファイルパス |
| `pageCount` | ページ数 |
| `fullText` | OCR 全文テキスト |

## 実装上のポイント

- OCR は `VNRecognizeTextRequest` を使用
- 認識言語は `ja-JP` と `en-US`（日本語優先）
- 複数ページの OCR は `withThrowingTaskGroup` で並列処理
- PDF にはスキャン画像を描画した上で不可視テキスト（透明度ほぼゼロ）を重ねる
- サムネイルは先頭ページから JPEG で生成する

## 制約

- 書類削除機能は未実装
- OCR 精度は入力画像の品質に依存する
- PDF 内の不可視テキスト位置は OCR の矩形情報に依存する
- 保存先はアプリ内部ストレージのみ

## 今後の改善候補

- 書類削除機能
- 一覧検索機能
- OCR 言語切り替え
- エクスポート導線の拡充
- テスト追加

## ライセンス

MIT License. 詳細は [LICENSE](LICENSE) を参照してください。
