# App Store 掲載情報 (EasyScan PDF)

App Store Connect に登録するメタデータ一式。日本語 (ja) と英語 (en-US) の両方を用意しています。
括弧内の数字は App Store Connect の入力上限（文字数）です。全角・半角の区別なく1文字＝1カウントです。

- Bundle ID: `net.misawa.easyscanpdf`
- バージョン: 1.0（ビルド 2）
- 対応デバイス: iPhone / iPad (`TARGETED_DEVICE_FAMILY = 1,2`)
- 最低 OS: iOS 26.0

---

## 1. 基本情報（言語共通）

| 項目 | 値 |
|---|---|
| プライマリカテゴリ | 仕事効率化 (Productivity) |
| セカンダリカテゴリ | ユーティリティ (Utilities) |
| 年齢制限レーティング | 4+ |
| 価格 | 無料 |
| App内課金 | なし |
| Copyright | 2026 Noriaki Misawa |

### サポート/URL 系（ja・en 共通で流用可）

| 項目 | 値（例・要差し替え） |
|---|---|
| サポートURL | https://github.com/（リポジトリ）/issues |
| マーケティングURL | （任意）空欄可 |
| プライバシーポリシーURL | 必須。GitHub Pages などに設置（下書きは本ファイル末尾） |

### App 審査情報（App Review Information）※未記入だと「保存できない」

| 項目 | 値 |
|---|---|
| 連絡先（姓・名） | Noriaki Misawa |
| 連絡先メール | noriaki@misawa.net |
| 連絡先電話番号 | （国番号付きで記入。必須） |
| サインイン情報 | ログイン不要のため「サインインが必要」オフ |
| メモ | アカウント不要・オフラインで動作。書類スキャンは実機（VisionKit 対応）で確認可能。匿名の利用統計のみ Firebase Analytics で送信（IDFA 不使用、ATT なし） |

---

## 2. 日本語 (ja)

### App名 (30)
```
EasyScan PDF: 書類スキャン
```
> 20文字。ブランド名だけにする場合は `EasyScan PDF`。

### サブタイトル (30)
```
OCRで検索できるPDFスキャナー
```
> 18文字。

### プロモーションテキスト (170)

審査なしでいつでも差し替え可能。季節やアピール軸で使い分ける想定で3案。

**A（標準・機能訴求）**
```
撮るだけで、検索できるPDFに。日本語と英語のOCRを端末内で実行し、文字を埋め込んだPDFを作成します。アカウント登録不要・広告なし。作成したPDFは共有やPNG / JPEG保存にも対応。
```
> 96文字。

**B（プライバシー訴求）**
```
書類はクラウドに送りません。スキャンもOCRもすべてこの端末の中だけで完結。アカウント不要、広告なし。検索できるPDFをつくって、そのまま端末に保管できます。
```
> 79文字。

**C（乗り換え・実用訴求）**
```
レシート、契約書、名刺、配布資料をためこまずに整理。ページを自動補正してまとめ、OCRで本文まで検索できるPDFにします。無料・登録不要、オフラインでも使えるシンプルなスキャナです。
```
> 91文字。

### 概要 / Description (4000)
```
EasyScan PDF は、紙の書類を撮影して「あとから検索できるPDF」に変換するシンプルなスキャナアプリです。契約書、請求書、レシート、名刺、配布資料、手書きのノートまで、手元の紙を iPhone / iPad ですばやくデジタル化。ファイルアプリや任意の PDF ビューアで、必要な1枚をキーワードから探し出せます。

余計な機能や設定はありません。開いてすぐスキャン、数秒待つだけで検索できる PDF ができあがります。

■ 主な特長

・撮るだけのかんたんスキャン
iOS 標準の書類スキャン機能を利用し、紙の輪郭を自動で検出。斜めから撮っても台形補正でまっすぐに整えます。複数ページを連続で取り込み、まとめて1つの PDF にします。

・端末内で完結する OCR（文字認識）
日本語と英語の文字を認識し、PDF に見えないテキスト層として重ねて保存します。見た目はスキャン画像のまま、PDF ビューアやファイルアプリの検索、コピー＆ペーストがそのまま使えます。認識処理はすべてこの端末の中だけで行われ、画像やテキストが外部に送られることはありません。

・書類の中身は端末の中だけに
アカウント登録は不要で、広告も表示しません。撮影した画像、認識したテキスト、作成した PDF がサーバーへ送られることはありません。データはこの端末内にのみ保存され、アプリを削除すれば一緒に消えます。
※アプリ改善のため、Firebase Analytics で匿名の利用状況（スキャン回数やページ数など）を収集しています。書類の内容は含まれません。

・見やすい書類管理
保存した書類はサムネイル付きの一覧で管理。タップして開く詳細画面では、PDF プレビュー、認識された OCR テキスト全文、ページ数、作成日時、保存先を確認できます。タイトルはいつでも編集できます。

・共有と画像書き出し
作成した PDF は共有シートからメール、メッセージ、ファイル、他アプリへそのまま送信。各ページを PNG または JPEG 画像としてフォトライブラリに保存することもできます。書き出し画像は端末の表示倍率に依存しない一定サイズで生成し、ファイルサイズを抑えます。

■ こんな方に

・紙の資料をためこまず、キーワードで探せる形で残したい
・クラウドにアップロードせずに書類を電子化したい
・オフラインでも使える、軽くて余計な機能のないスキャナが欲しい
・レシートや契約書、名刺を種類ごとに整理しておきたい

■ 使い方

1. 右上のスキャンボタンを押す
2. 書類を撮影してスキャンを完了する
3. OCR と PDF 生成が終わるまで数秒待つ
4. 一覧から書類を開き、プレビューや OCR テキストを確認する
5. 必要に応じてタイトルを編集し、PDF を共有、または画像として保存する

■ 動作環境

・iOS 26.0 以降
・カメラを搭載した iPhone / iPad
・書類スキャンには VisionKit 対応デバイスが必要です
・初回のスキャン時にカメラの使用許可、画像をフォトに保存する際に写真への追加許可が必要です

■ ご注意

・OCR の精度は撮影した画像の品質（明るさ、ピント、傾き）に依存します
・書類の保存先はアプリ内ストレージのみです。他の場所へ移したい場合は PDF を書き出してください
```

### キーワード (100・カンマ区切り・スペース不要)
```
スキャナ,スキャン,PDF,OCR,文字認識,書類,ドキュメント,検索,自炊,名刺,レシート,PDF変換,画像PDF,無料,オフライン
```
> 現在 約72文字。

### このバージョンの新機能 (4000) — v1.0
```
EasyScan PDF の最初のリリースです。書類スキャン、日本語・英語のOCR、検索可能PDFの作成、一覧管理、PDF共有、PNG / JPEG でのフォト保存に対応しています。
```

---

## 3. 英語 (en-US)

### App Name (30)
```
EasyScan PDF: Document Scanner
```
> 29 chars.

### Subtitle (30)
```
Make searchable PDFs with OCR
```
> 28 chars.

### Promotional Text (170)

Editable anytime without review. Three variants for rotating the emphasis.

**A (standard / features)**
```
Snap a photo, get a searchable PDF. On-device OCR for English and Japanese embeds text into every page. No account, no ads. Share or export pages as PNG/JPEG.
```
> 158 chars.

**B (privacy)**
```
Your documents never touch the cloud. Scanning and OCR happen entirely on your device. No account, no ads. Build searchable PDFs and keep them right here.
```
> 154 chars.

**C (switch / practical)**
```
Stop letting receipts, contracts, and business cards pile up. Auto-crop pages, combine them, and run OCR so the text is searchable. A free, offline, no-signup scanner.
```
> 156 chars.

### Description (4000)
```
EasyScan PDF is a simple scanner that turns paper documents into PDFs you can actually search. Digitize contracts, invoices, receipts, business cards, handouts, and handwritten notes right from your iPhone or iPad, then find the one page you need by keyword in the Files app or any PDF viewer.

No clutter, no setup. Open the app, scan, wait a few seconds, and you have a searchable PDF.

WHY EASYSCAN PDF

- Fast, clean scanning
Uses the built-in iOS document scanner to detect the edges of the paper automatically. Shots taken at an angle are straightened with perspective correction. Capture several pages in a row and combine them into a single PDF.

- OCR that stays on your device
Recognizes English and Japanese text and layers it onto the PDF as an invisible text layer. The page still looks like your scan, but search, copy, and paste work in any PDF viewer or the Files app. All recognition runs on this device only. Images and text are never sent anywhere.

- Your documents stay on your device
No account required and no ads. Scanned images, recognized text, and PDFs are never uploaded to a server. Everything you create is stored only on this device and is removed when you delete the app.
* To improve the app, anonymous usage statistics (such as the number of scans and pages) are collected with Firebase Analytics. Document contents are never included.

- Clear document management
Saved documents appear in a thumbnail list. Tap one to open a detail screen with a PDF preview, the full recognized OCR text, page count, creation date, and file location. Titles can be edited anytime.

- Share and export as images
Send any PDF through the share sheet to mail, messages, Files, or another app. You can also save individual pages to your photo library as PNG or JPEG. Exported images are rendered at a consistent size independent of screen scale to keep file sizes down.

GREAT FOR

- Keeping paperwork searchable instead of stacked
- Digitizing documents without uploading them to the cloud
- A lightweight scanner that works offline, with nothing extra to learn
- Sorting receipts, contracts, and business cards by type

HOW IT WORKS

1. Tap the scan button in the top right
2. Photograph your document and finish scanning
3. Wait a few seconds for OCR and PDF generation
4. Open the document from the list and review the preview or OCR text
5. Edit the title if needed, then share the PDF or save pages as images

REQUIREMENTS

- iOS 26.0 or later
- An iPhone or iPad with a camera
- Document scanning requires a VisionKit-capable device
- Camera permission is requested on first scan; photo add permission is requested when saving images to Photos

NOTES

- OCR accuracy depends on the quality of the captured image (lighting, focus, angle)
- Documents are stored only inside the app; export the PDF to move it elsewhere
```

### Keywords (100, comma-separated, no spaces)
```
scanner,scan,document,pdf,ocr,text recognition,searchable,receipt,business card,paperless,offline
```
> Currently 95 chars.

### What's New in This Version (4000) — v1.0
```
Initial release of EasyScan PDF. Scan documents, run English and Japanese OCR, create searchable PDFs, manage them in a list, share PDFs, and export pages to Photos as PNG or JPEG.
```

---

## 4. App プライバシー (Nutrition Label) 回答方針

ビルド 2 から **Firebase Analytics** を導入したため、「データ収集なし」では申請できません。以下で回答します。

- 書類の画像・OCR テキスト・PDF・タイトルは送信しない（`AnalyticsService` は回数・ページ数・形式などの集計値のみ記録）
- IDFA は使わない（`FirebaseAnalytics` プロダクトのみ。`FirebaseAnalyticsIdentitySupport` は未導入）→ **ATT ダイアログ不要**、「トラッキング」には該当しない

| データの種類 | 収集 | ユーザーに関連付け | トラッキング | 目的 |
|---|---|---|---|---|
| 使用状況データ > 製品の操作 (Product Interaction) | はい | いいえ | いいえ | アナリティクス |
| ID > デバイス ID (Device ID：Firebase のアプリインスタンス ID) | はい | いいえ | いいえ | アナリティクス |
| 位置情報 > おおよその場所 (Coarse Location：IP から推定) | はい | いいえ | いいえ | アナリティクス |

> Google 公式の [Firebase の App Store データ開示ガイド](https://firebase.google.com/docs/ios/app-store-data-collection) と照らして最終確認してください。Firebase コンソールで「Google シグナル」や広告連携を有効にする場合は回答が変わります。
> 同じ内容をアプリ側の `easyscanpdf/PrivacyInfo.xcprivacy` にも記載済みです（UserDefaults の利用理由 `CA92.1` も申告）。

送信しているイベント:

| イベント名 | パラメータ | タイミング |
|---|---|---|
| `scan_completed` | `page_count` | スキャン → PDF 保存完了 |
| `scan_failed` | なし | スキャン失敗 |
| `pdf_share_opened` | なし | 共有シートを開いた |
| `photo_exported` | `format` (png/jpg), `page_count` | フォトへ保存完了 |
| `documents_deleted` | `count` | 書類を削除 |
| `onboarding_finished` | `started_scan` (0/1) | 初回ガイドを閉じた |

権限（Info.plist、ローカライズ済み）:

| キー | ja | en |
|---|---|---|
| NSCameraUsageDescription | 書類をスキャンして PDF 化するためにカメラを使用します | Used to scan documents and turn them into PDFs. |
| NSPhotoLibraryAddUsageDescription | PDF を画像化してフォトライブラリに保存するために使用します | Used to save PDF pages as images to your photo library. |

---

## 5. プライバシーポリシー（Web 掲載用・Firebase 対応版）

> App Store にはポリシーの **URL** が必要。以下を GitHub Pages 等に日英併記で掲載し、**既に公開済みの場合は差し替え**てください（旧版は「データを一切収集しない」と記載しているため）。

### 日本語

```
EasyScan PDF プライバシーポリシー

最終更新日: 2026年11月1日

EasyScan PDF（以下「本アプリ」）は、利用者のプライバシーを尊重します。

1. 書類データの取り扱い
スキャンした画像、認識されたテキスト、生成されたPDF、サムネイル、書類のタイトルは、利用者の端末内にのみ保存されます。これらのデータが開発者や第三者のサーバーへ送信されることはありません。アプリを削除すると、これらのデータも削除されます。

2. 利用状況の収集（Firebase Analytics）
本アプリは、品質向上のために Google LLC が提供する Firebase Analytics を使用し、次の情報を匿名で収集します。
・アプリの操作に関する情報（スキャン回数、ページ数、共有・画像保存の利用回数、書き出し形式など）
・アプリのインスタンスを識別するための ID、端末の種類、OS バージョン、アプリのバージョン
・IP アドレスから推定されるおおよその地域
これらの情報に書類の内容は含まれず、利用者個人を特定する目的では使用しません。広告識別子（IDFA）は取得しません。
収集された情報は Google のプライバシーポリシー（https://policies.google.com/privacy）に基づき管理されます。

3. カメラ・写真へのアクセス
書類のスキャンにカメラを、PDFページを画像として保存する際に写真ライブラリへの追加を使用します。取得した画像が外部に送信されることはありません。

4. 広告・トラッキング
本アプリは広告を表示せず、他社のアプリやウェブサイトをまたいだトラッキングも行いません。

5. お問い合わせ
本ポリシーに関するご質問は、次の連絡先までお願いします: noriaki@misawa.net

6. 改定
本ポリシーは必要に応じて更新されることがあります。重要な変更がある場合は、本ページでお知らせします。
```

### English

```
EasyScan PDF Privacy Policy

Last updated: November 1, 2026

EasyScan PDF ("the App") respects your privacy.

1. Your Documents
Scanned images, recognized text, generated PDFs, thumbnails, and document titles are stored only on your device. This data is never sent to servers operated by the developer or any third party. Deleting the App deletes this data.

2. Usage Analytics (Firebase Analytics)
To improve the App, we use Firebase Analytics, provided by Google LLC, to collect the following information anonymously:
- How the App is used (e.g., number of scans and pages, use of sharing and image export, export format)
- An app instance identifier, device model, OS version, and app version
- Approximate region inferred from your IP address
This information never includes the contents of your documents and is not used to identify you personally. The App does not access the advertising identifier (IDFA).
This information is handled in accordance with Google's Privacy Policy (https://policies.google.com/privacy).

3. Camera and Photos Access
The camera is used to scan documents, and photo library "add" access is used to save PDF pages as images. Captured images are never transmitted externally.

4. Advertising and Tracking
The App shows no ads and does not track you across apps or websites owned by other companies.

5. Contact
For questions about this policy, contact: noriaki@misawa.net

6. Changes
This policy may be updated as needed. Significant changes will be announced on this page.
```

---

## 6. スクリーンショット

生成済み（`store/screenshots/`）。アップロードはこのフォルダの PNG をそのまま使用。

| フォルダ | 解像度(px) | App Store Connect の枠 |
|---|---|---|
| `ja/iphone-6.9/`, `en/iphone-6.9/` | 1320 x 2868 | iPhone 6.9"（他サイズは自動縮小で流用） |
| `ja/ipad-13/`, `en/ipad-13/` | 2064 x 2752 | iPad 13" |

構成（全 5 枚・日英共通）:

| # | ファイル | 見出し (ja) | Headline (en) | 画面 |
|---|---|---|---|---|
| 1 | `01-hero.png` | 撮るだけで、検索できるPDFに。 | Snap a page. Search it later. | 書類一覧（iPad は一覧＋詳細） |
| 2 | `02-ocr-search.png` | 紙の文字まで、検索できる。 | Find any word on any page. | 詳細＋検索ヒットのカード |
| 3 | `03-privacy.png` | 書類の中身は、端末の外に出ない。 | Your papers stay on your device. | 詳細（ダーク背景のコントラスト枠） |
| 4 | `04-organize.png` | 紙の山を、すっきり一覧に。 | Paper piles, neatly sorted. | 一覧＋オンボーディング |
| 5 | `05-features.png` | シンプルだから、迷わない。 | Simple. Nothing to learn. | 機能ピル一覧 |

再生成手順:

```bash
cd store/screenshot-generator
pnpm install
pnpm dev            # http://localhost:3000 でプレビュー・個別書き出し
node scripts/export.mjs   # 別ターミナルで実行 → store/screenshots/ に一括出力
```

> 画面素材は架空のサンプル書類をシミュレータに投入して撮影したもの（`public/screenshots*`）。DEBUG ビルド限定の起動引数 `-screenshotSelectDocument <index>` で書類を選択状態にして撮影しています。
