<p align="center">
  <img src="../assets/icon.png" width="128" alt="Tokimori app icon">
</p>

<h1 align="center">Tokimori</h1>

<p align="center">
  <strong>Giữ Mac thức khi bạn cần và mở hoặc thoát ứng dụng theo lịch.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-14%2B-blue" alt="macOS 14 or later">
  <img src="https://img.shields.io/badge/Swift-6-orange" alt="Swift 6">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT License">
</p>

<p align="center">
  <a href="../../README.md">English</a> ·
  <a href="README.zh-Hans.md">简体中文</a> ·
  <a href="README.zh-Hant.md">繁體中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.fr.md">Français</a> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.id.md">Bahasa Indonesia</a> ·
  <a href="README.th.md">ไทย</a> ·
  <b>Tiếng Việt</b> ·
  <a href="README.ar.md">العربية</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.hi.md">हिन्दी</a>
</p>

Tokimori (時守り, "người canh giữ thời gian") là ứng dụng thanh menu miễn phí, mã nguồn mở dành cho macOS. Ứng dụng giữ cho máy Mac không chuyển sang chế độ ngủ — ngay bây giờ, theo lịch hằng tuần, hoặc trong khi một ứng dụng hay lệnh cụ thể đang chạy — và mở hoặc thoát ứng dụng vào thời điểm bạn đặt. Ứng dụng không có biểu tượng trên Dock.

Dùng nó để giữ máy Mac không ngủ khi tải tệp, build, xuất video, chạy tác tử AI, kết nối từ xa hoặc thuyết trình. Ứng dụng dùng cùng cơ chế với lệnh `caffeinate` có sẵn trong macOS, thêm menu, lịch và hẹn giờ ứng dụng, và không bao giờ di chuyển chuột.

<p align="center">
  <img src="../assets/screenshot.png" width="420" alt="Menu Tokimori">
</p>

## Mục lục

- [Tính năng](#tính-năng)
- [Cài đặt](#cài-đặt)
- [Cách dùng](#cách-dùng)
- [Cách hoạt động](#cách-hoạt-động)
- [Câu hỏi thường gặp](#câu-hỏi-thường-gặp)
- [Hạn chế đã biết](#hạn-chế-đã-biết)
- [Build từ mã nguồn](#build-từ-mã-nguồn)

## Tính năng

- **Giữ máy thức chỉ với một cú nhấp.** Bật vô thời hạn, trong 30 phút, 1, 2 hoặc 4 giờ, hoặc cho đến thời điểm bạn chọn. Hệ thống vẫn thức, trong khi màn hình vẫn có thể tắt theo lịch thường lệ.
- **Giữ màn hình bật, hoặc tắt ngay.** Bạn có thể giữ cả màn hình bật nếu muốn. **Tắt màn hình** làm tối màn hình trong khi máy Mac vẫn tiếp tục chạy.
- **Lịch.** Ví dụ, giữ máy Mac thức vào mỗi ngày trong tuần từ 09:00 đến 18:00. Một khoảng thời gian có thể kết thúc sau nửa đêm; khi đó nó thuộc về ngày bắt đầu.
- **Khi đang chạy.** Giữ máy Mac thức trong khi một ứng dụng đang mở, hoặc trong khi một tiến trình dòng lệnh đang chạy — khớp theo tên (`ffmpeg`) hoặc theo văn bản trong dòng lệnh (`claude`, cho các công cụ chạy bên trong `node` hoặc `python`).
- **Hẹn giờ ứng dụng.** Mở hoặc thoát một ứng dụng vào những ngày đã chọn, tại thời điểm đã đặt. Cùng một ứng dụng có thể có nhiều hẹn giờ. Nếu ứng dụng chưa thoát sau 30 giây (ví dụ vì đang hỏi bạn có lưu không), Tokimori sẽ thông báo cho bạn hoặc buộc thoát — bạn chọn cho từng hẹn giờ.
- **Bảo vệ pin.** Khi máy Mac chạy bằng pin dưới mức bạn chọn (mặc định 20%), Tokimori ngừng giữ máy thức. Lịch và quy tắc khi đang chạy sẽ tiếp tục khi bạn cắm sạc.
- **Tác vụ Phím tắt.** *Giữ Mac thức*, *Ngừng giữ Mac thức* và *Mac có đang được giữ thức không* có thể dùng trong ứng dụng Phím tắt, ví dụ trong một mục tự động hóa Tập trung hoặc Wi-Fi.
- **15 ngôn ngữ.** Tiếng Anh, tiếng Trung giản thể, tiếng Trung phồn thể, tiếng Nhật, tiếng Hàn, tiếng Đức, tiếng Pháp, tiếng Tây Ban Nha, tiếng Bồ Đào Nha, tiếng Indonesia, tiếng Thái, tiếng Việt, tiếng Ả Rập, tiếng Nga và tiếng Hindi, có thể chuyển đổi ngay trong ứng dụng.

## Cài đặt

Yêu cầu macOS 14 Sonoma trở lên.

1. Mở [trang Releases](https://github.com/zhaojiannet/tokimori/releases) và trong mục **Assets** của bản phát hành mới nhất, tải về `Tokimori-<version>.dmg`.
2. Bấm hai lần vào tệp DMG đã tải về để mở.
3. Kéo **Tokimori** vào thư mục **Ứng dụng** hiển thị trong cùng cửa sổ.
4. Đẩy DMG ra, sau đó mở Tokimori từ thư mục Ứng dụng. Lần đầu tiên, macOS sẽ yêu cầu bạn cho phép; xem [Lần mở đầu tiên](#lần-mở-đầu-tiên).

Không có trình cài đặt và không cần mật khẩu quản trị viên.

**Cập nhật:** tải về tệp DMG mới và kéo Tokimori vào Ứng dụng một lần nữa, thay thế bản cũ. Các quy tắc của bạn được giữ nguyên. Để xem có phiên bản mới hơn không, bấm **Kiểm tra cập nhật…** trong Cài đặt › Cài đặt chung.

**Gỡ cài đặt:** thoát Tokimori từ menu của ứng dụng rồi chuyển vào Thùng rác. Để xóa cả quy tắc và cài đặt, hãy xóa `~/Library/Application Support/net.zhaojian.tokimori` và `~/Library/Preferences/net.zhaojian.tokimori.plist`. Nếu bạn đã bật **Mở khi đăng nhập**, hãy tắt trước, hoặc xóa Tokimori trong Cài đặt hệ thống › Cài đặt chung › Mục đăng nhập.

### Lần mở đầu tiên

Tokimori chưa được Apple công chứng, vì vậy macOS chặn ứng dụng trong lần đầu bạn mở. Hãy cho phép một lần:

1. Bấm hai lần vào Tokimori. Khi macOS báo không thể xác minh Tokimori, bấm **Xong**. Đừng bấm nút màu xanh **Di chuyển vào Thùng rác**.

   <img src="../assets/first-launch-1.png" width="341" alt="Cảnh báo đầu tiên: bấm Xong">

2. Mở **Cài đặt hệ thống › Quyền riêng tư & Bảo mật**, cuộn xuống **Bảo mật** và bấm **Vẫn mở** bên cạnh Tokimori. Nút này xuất hiện trong khoảng một giờ sau bước 1.

   <img src="../assets/first-launch-2.png" width="560" alt="Quyền riêng tư & Bảo mật: bấm Vẫn mở">

3. Nhập mật khẩu đăng nhập hoặc dùng Touch ID. Trong hộp thoại tiếp theo, bấm **Vẫn mở** một lần nữa.

   <img src="../assets/first-launch-3.png" width="341" alt="Xác nhận: bấm Vẫn mở">

Sau đó, Tokimori sẽ mở bình thường. Tệp DMG cũng có các bước này trong `First Launch.txt`.

## Cách dùng

Bấm vào đồng hồ cát trên thanh menu. Khi có thứ gì đó đang giữ máy Mac thức, cát sẽ chảy xuống và đồng hồ cát lật lại sau mỗi 30 phút; khi máy Mac có thể ngủ như bình thường, đồng hồ cát đứng yên với toàn bộ cát ở phía trên.

- **Giữ máy thức** bật hoặc tắt chế độ giữ máy thức. Bên dưới, Tokimori liệt kê những gì đang giữ máy Mac thức và đến khi nào.
- Các nút thời lượng giữ máy thức trong khoảng thời gian tương ứng. **Cho đến…** cho phép bạn chọn thời điểm; nếu thời điểm đó đã qua trong hôm nay thì có nghĩa là ngày mai.
- **Giữ màn hình bật** áp dụng cho chế độ giữ máy thức mà bạn tự bật. Lịch và quy tắc khi đang chạy có cài đặt riêng. Màn hình sẽ vẫn bật nếu bất kỳ nguồn nào đang hoạt động yêu cầu.
- Dòng cuối cùng hiển thị hẹn giờ ứng dụng tiếp theo.

Nếu bạn tắt chế độ giữ máy thức trong khi một lịch đang hoạt động, Tokimori sẽ hỏi ý bạn:

- **Dừng đến 18:00** — tắt trong phần còn lại của khoảng thời gian này; lịch sẽ bật lại vào lần sau.
- **Tắt lịch này** — lịch bị tắt cho đến khi bạn bật lại trong Cài đặt.
- **Tiếp tục giữ thức** — không thay đổi gì.

Việc tắt cũng tạm dừng các quy tắc khi đang chạy đang hoạt động, cho đến khi ứng dụng hoặc tiến trình đó thoát.

Mở **Cài đặt…** để quản lý quy tắc. Mỗi quy tắc là một thẻ được chỉnh sửa trực tiếp: thay đổi có hiệu lực ngay, công tắc trên thẻ dùng để bật hoặc tắt quy tắc, và nút thùng rác dùng để xóa.

- **Cài đặt chung:** mở khi đăng nhập, hiển thị thời gian còn lại bên cạnh biểu tượng trên thanh menu, bảo vệ pin, ngôn ngữ, cập nhật.
- **Lịch:** **Thêm lịch** thêm lịch các ngày trong tuần 09:00–18:00; đổi tên, ngày và giờ ngay trên thẻ.
- **Khi đang chạy:** **Thêm** liệt kê các ứng dụng đang mở; chọn một ứng dụng, chọn **Ứng dụng khác…**, hoặc chọn **Tiến trình dòng lệnh…** rồi nhập tên hoặc một phần dòng lệnh của tiến trình.
- **Hẹn giờ ứng dụng:** **Thêm hẹn giờ** liệt kê các ứng dụng đang mở. Hẹn giờ mới sẽ mở ứng dụng lúc 09:00 vào các ngày trong tuần, hoặc thoát ứng dụng lúc 18:00 nếu ứng dụng đã có hẹn giờ mở. Với thao tác thoát, hãy chọn điều sẽ xảy ra nếu ứng dụng chưa thoát sau 30 giây. Không thể bật một hẹn giờ sẽ mở và thoát cùng một ứng dụng trong cùng một phút với một hẹn giờ khác.

<p align="center">
  <img src="../assets/settings-general.png" width="380" alt="Cài đặt: Cài đặt chung">
  <img src="../assets/settings-schedules.png" width="380" alt="Cài đặt: Lịch">
  <img src="../assets/settings-while-running.png" width="380" alt="Cài đặt: Khi đang chạy">
  <img src="../assets/settings-app-timers.png" width="380" alt="Cài đặt: Hẹn giờ ứng dụng">
</p>

Khi bạn thêm quy tắc đầu tiên, Tokimori sẽ hỏi có mở khi đăng nhập không, vì quy tắc chỉ chạy khi ứng dụng đang mở. Thoát Tokimori khi có quy tắc đang bật sẽ yêu cầu xác nhận một lần (bạn có thể tắt câu hỏi này).

## Cách hoạt động

- Chế độ giữ máy thức dùng power assertion của IOKit loại `PreventUserIdleSystemSleep`, cùng cơ chế với `caffeinate -i`. **Giữ màn hình bật** thêm `PreventUserIdleDisplaySleep`. Chạy `pmset -g assertions` trong Terminal để xem chúng. Tokimori không di chuyển chuột và không chạy `caffeinate`.
- Các assertion thuộc về tiến trình Tokimori, nên macOS tự động giải phóng chúng nếu Tokimori thoát hoặc bị treo. Máy Mac không bao giờ bị giữ thức vì một assertion còn sót lại.
- Tokimori tính toán lại khi một khoảng thời gian bắt đầu hoặc kết thúc, khi máy Mac thức dậy, khi thời gian hoặc múi giờ thay đổi, khi ứng dụng mở hoặc thoát, và cứ 30 giây một lần đối với tiến trình và mức pin.
- Hẹn giờ ứng dụng rơi vào lúc máy Mac đang ngủ hoặc Tokimori không chạy vẫn được thực hiện nếu Tokimori nhận ra trong vòng 10 phút; những hẹn giờ cũ hơn sẽ bị bỏ qua, để bạn không gặp một loạt thao tác mở và thoát đã lỗi thời khi mở nắp máy vào buổi sáng.
- Việc mở dùng `NSWorkspace`; việc thoát yêu cầu ứng dụng thoát bình thường, còn buộc thoát dùng `NSRunningApplication.forceTerminate()`. macOS không cho phép ứng dụng trong sandbox thoát ứng dụng khác, vì vậy Tokimori không chạy trong sandbox và không có trên Mac App Store.
- Quy tắc được lưu trong `~/Library/Application Support/net.zhaojian.tokimori/configuration.json`. Yêu cầu mạng duy nhất là kiểm tra cập nhật, và chỉ khi bạn bấm vào.

## Câu hỏi thường gặp

**Ứng dụng có giữ MacBook thức khi gập nắp không?**
Không. Gập nắp sẽ đưa MacBook vào chế độ ngủ bất kể power assertion, trừ khi đã kết nối màn hình ngoài, bàn phím và nguồn điện (chế độ gập máy).

**Ứng dụng có thể đánh thức máy Mac để chạy hẹn giờ ứng dụng không?**
Không. Đánh thức máy Mac đang ngủ vào thời điểm định sẵn cần quyền quản trị viên (`pmset schedule`). Hẹn giờ chạy khi máy Mac đang thức, với thời gian ân hạn 10 phút như mô tả ở trên.

**Tại sao màn hình vẫn tắt?**
Theo mặc định chỉ chế độ ngủ của hệ thống bị ngăn, đây thường là điều bạn cần khi tải xuống, build và dùng phiên từ xa. Bật **Giữ màn hình bật** khi trình chiếu hoặc theo dõi.

**Ứng dụng có hoạt động với tự động hóa Phím tắt trên macOS 26 không?**
Có. Dùng các tác vụ của Tokimori trong một mục tự động hóa cá nhân, chẳng hạn "Khi tôi kết nối với Wi-Fi … Giữ Mac thức".

## Hạn chế đã biết

- **Tắt màn hình** cũng có thể khóa máy Mac nếu bạn đặt trong Cài đặt hệ thống › Màn hình khóa yêu cầu mật khẩu sau khi màn hình tắt.
- Khớp theo dòng lệnh chỉ thấy các tiến trình do tài khoản người dùng của bạn khởi chạy.
- Hẹn giờ ứng dụng có độ chính xác đến từng phút và phụ thuộc vào việc Tokimori đang chạy.
- Bản dịch giao diện chưa được người bản ngữ xem xét.

## Build từ mã nguồn

Yêu cầu Xcode 27.

```sh
swift test --package-path TokimoriKit
xcodebuild -project Tokimori.xcodeproj -scheme Tokimori build
```

Để build tệp DMG:

```sh
scripts/package.sh
```

Kết quả nằm trong `.build/dist/`, cùng với một Homebrew cask được tạo từ `packaging/tokimori.rb` với phiên bản và checksum đã điền sẵn. Nếu không có biến môi trường, ứng dụng được ký ad hoc và không được công chứng; khi đó tệp DMG có kèm `First Launch.txt`. Đặt `DEVELOPER_ID` (tên chứng chỉ Developer ID Application) để ký bằng chứng chỉ đó, và đặt thêm `NOTARY_PROFILE` (hồ sơ thông tin xác thực được lưu bằng `xcrun notarytool store-credentials`) để công chứng và staple.

Các bản phát hành được build bằng quy trình GitHub Actions trong `.github/workflows/release.yml`. Cách ký và cách phát hành một phiên bản được mô tả trong [docs/release.md](../release.md).

## Cấu trúc dự án

- `TokimoriKit/`: một gói Swift cục bộ. `TokimoriCore` chứa logic lập lịch và các bài kiểm thử; `TokimoriPlatform` bao bọc các API hệ thống (power assertion và pin của IOKit, danh sách tiến trình, `NSWorkspace`).
- `Apps/Tokimori/`: ứng dụng thanh menu (SwiftUI).
- `scripts/`, `packaging/`: tập lệnh đóng gói và mẫu Homebrew cask.

## Giấy phép

[MIT](../../LICENSE) © 2026 zhaoJian
