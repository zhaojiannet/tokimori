<p align="center">
  <img src="../assets/icon.png" width="128" alt="Tokimori app icon">
</p>

<h1 align="center">Tokimori</h1>

<p align="center">
  <strong>在需要時讓 Mac 保持喚醒，並依排程打開或結束 App。</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-14%2B-blue" alt="macOS 14 or later">
  <img src="https://img.shields.io/badge/Swift-6-orange" alt="Swift 6">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT License">
</p>

<p align="center">
  <a href="../../README.md">English</a> ·
  <a href="README.zh-Hans.md">简体中文</a> ·
  <b>繁體中文</b> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.fr.md">Français</a> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.id.md">Bahasa Indonesia</a> ·
  <a href="README.th.md">ไทย</a> ·
  <a href="README.vi.md">Tiếng Việt</a> ·
  <a href="README.ar.md">العربية</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.hi.md">हिन्दी</a>
</p>

Tokimori（時守り，意思是「守護時間的人」）是一款免費、開源的 macOS 選單列 App。它可以防止 Mac 進入睡眠：可以立即開始、依每週排程進行，或在特定 App 或指令執行期間保持喚醒；它也能在你設定的時間打開或結束 App。它不會在 Dock 中顯示圖像。

下載大型檔案、編譯、輸出影片、執行 AI 代理、遠端連線或簡報時，都可以用它防止 Mac 睡眠。它和系統內建的 `caffeinate` 指令使用同一套機制，另外加上選單、每週排程和 App 計時器，也不會模擬移動滑鼠。

<p align="center">
  <img src="../assets/screenshot.png" width="420" alt="Tokimori 選單">
</p>

## 目錄

- [功能](#功能)
- [安裝](#安裝)
- [使用方式](#使用方式)
- [運作原理](#運作原理)
- [常見問題](#常見問題)
- [已知限制](#已知限制)
- [從原始碼建置](#從原始碼建置)

## 功能

- **一鍵保持喚醒。** 可以無限期開啟，也可以開啟 30 分鐘、1、2 或 4 小時，或持續到你選定的時間。系統保持喚醒期間，顯示器仍會依照原本的設定關閉。
- **保持顯示器開啟，或立即關閉顯示器。** 可以選擇讓顯示器也保持開啟。**關閉顯示器** 會讓螢幕變暗，而 Mac 繼續運作。
- **排程。** 例如讓 Mac 在每個工作日的 09:00 到 18:00 保持喚醒。時段可以跨過午夜，此時它屬於開始的那一天。
- **執行期間。** 在某個 App 開啟期間，或某個命令列程序執行期間保持 Mac 喚醒。程序可以依名稱比對（`ffmpeg`），也可以依命令列中的文字比對（`claude`，適用於在 `node` 或 `python` 中執行的工具）。
- **App 計時器。** 在選定的日期和時間打開或結束某個 App，同一個 App 可以設定多個計時器。如果 App 在 30 秒後仍未結束（例如正在詢問你是否儲存），Tokimori 會通知你或強制結束它，由每個計時器各自設定。
- **電池保護。** 當 Mac 使用電池且電量低於你設定的程度（預設 20%）時，Tokimori 會停止保持喚醒。接上電源後，排程和執行時規則會恢復。
- **捷徑動作。** *讓 Mac 保持喚醒*、*停止讓 Mac 保持喚醒* 和 *Mac 是否保持喚醒* 可以在「捷徑」App 中使用，例如用於專注模式或 Wi-Fi 自動化操作。
- **15 種語言。** 英文、簡體中文、繁體中文、日文、韓文、德文、法文、西班牙文、葡萄牙文、印尼文、泰文、越南文、阿拉伯文、俄文和印地文，可在 App 內切換。

## 安裝

需要 macOS 14 Sonoma 或以上版本。

1. 打開 [Releases 頁面](https://github.com/zhaojiannet/tokimori/releases)，在最新版本的 **Assets** 下載 `Tokimori-<version>.dmg`。
2. 按兩下下載的 DMG 將其打開。
3. 將 **Tokimori** 拖到同一視窗中顯示的「**應用程式**」檔案夾。
4. 退出 DMG，然後從「應用程式」檔案夾打開 Tokimori。第一次打開時，macOS 會要求你允許它執行，請參閱[首次啟動](#首次啟動)。

不需要安裝程式，也不需要管理者密碼。

**更新：** 下載新的 DMG，再次將 Tokimori 拖到「應用程式」檔案夾，取代舊版本。你的規則會保留。若要查看是否有新版本，請在「設定 › 一般」中按一下 **檢查更新項目⋯**。

**解除安裝：** 從 Tokimori 的選單結束它，然後將它丟到垃圾桶。若也要移除它的規則和設定，請刪除 `~/Library/Application Support/net.zhaojian.tokimori` 和 `~/Library/Preferences/net.zhaojian.tokimori.plist`。如果你開啟了 **登入時打開**，請先將它關閉，或在「系統設定 › 一般 › 登入項目」中移除 Tokimori。

### 首次啟動

Tokimori 尚未經過 Apple 公證，因此第一次打開時會被 macOS 阻擋。依照以下步驟允許一次即可：

1. 按兩下 Tokimori。當 macOS 表示無法驗證 Tokimori 時，按一下 **完成**。不要按藍色的 **丟到垃圾桶** 按鈕。

   <img src="../assets/first-launch-1.png" width="341" alt="第一個警告：按一下完成">

2. 打開 **系統設定 › 隱私權與安全性**，向下捲動到 **安全性**，按一下 Tokimori 旁的 **強制打開**。完成步驟 1 後，這個按鈕大約會保留一小時。

   <img src="../assets/first-launch-2.png" width="560" alt="隱私權與安全性：按一下強制打開">

3. 輸入登入密碼或使用 Touch ID。在接著出現的對話框中，再按一次 **強制打開**。

   <img src="../assets/first-launch-3.png" width="341" alt="確認框：按一下強制打開">

之後 Tokimori 就能正常打開。DMG 中的 `First Launch.txt` 也記載了這些步驟。

## 使用方式

按一下選單列中的沙漏。當有東西讓 Mac 保持喚醒時，沙會緩緩流下，沙漏每 30 分鐘翻轉一次；Mac 可以照常睡眠時，沙漏靜止不動，沙全部留在上方。

- **保持喚醒** 用來開啟或關閉保持喚醒。下方會列出目前是什麼讓 Mac 保持喚醒，以及持續到何時。
- 按下時間長度按鈕，就會保持喚醒該段時間。**直到⋯** 可讓你選擇時間；如果今天已經過了該時間，則代表明天。
- **保持顯示器開啟** 只適用於你自行開啟的保持喚醒。排程和執行時規則各有自己的設定。只要任何生效中的來源要求，顯示器就會保持開啟。
- 最後一行顯示下一個 App 計時器。

如果在排程生效期間關閉保持喚醒，Tokimori 會詢問你的意思：

- **暫停至 18:00**：在本時段剩餘時間內保持關閉，下次排程會再次開啟。
- **關閉此排程**：關閉這個排程，直到你在設定中重新開啟它。
- **繼續保持喚醒**：不做任何變更。

關閉保持喚醒也會暫停生效中的執行時規則，直到該 App 或程序結束。

打開 **設定⋯** 管理規則。每條規則都是一張可直接編輯的卡片：變更會立即生效，卡片上的開關可開啟或關閉規則，垃圾桶按鈕可刪除規則。

- **一般：** 登入時打開、在選單列圖像旁顯示剩餘時間、電池保護、語言、更新。
- **排程：** **新增排程** 會加入一個工作日 09:00–18:00 的排程；名稱、日期和時間可在卡片上修改。
- **執行時：** **新增** 會列出目前開啟的 App；選擇其中一個、選擇 **其他 App⋯**，或選擇 **命令列程序⋯** 並輸入程序名稱或其命令列的一部分。
- **App 計時器：** **新增計時器** 會列出目前開啟的 App。新的計時器會在工作日 09:00 打開該 App；若該 App 已有打開用的計時器，則改為在 18:00 結束它。若是結束，可選擇 App 在 30 秒後仍未結束時要怎麼做。若某個計時器會與另一個計時器在同一分鐘打開和結束同一個 App，就無法開啟它。

<p align="center">
  <img src="../assets/settings-general.png" width="380" alt="設定：一般">
  <img src="../assets/settings-schedules.png" width="380" alt="設定：排程">
  <img src="../assets/settings-while-running.png" width="380" alt="設定：執行時">
  <img src="../assets/settings-app-timers.png" width="380" alt="設定：App 計時器">
</p>

加入第一條規則時，Tokimori 會詢問是否要在登入時打開，因為規則只會在它開啟時執行。在有規則開啟的情況下結束 Tokimori，會請你確認一次（可以關閉這個詢問）。

## 運作原理

- 保持喚醒使用類型為 `PreventUserIdleSystemSleep` 的 IOKit 電源斷言，機制與 `caffeinate -i` 相同。**保持顯示器開啟** 會再加上 `PreventUserIdleDisplaySleep`。在「終端機」中執行 `pmset -g assertions` 即可看到它們。Tokimori 不會移動滑鼠，也不會執行 `caffeinate`。
- 斷言屬於 Tokimori 程序，因此 Tokimori 結束或當機時，macOS 會自動釋放它們。Mac 絕不會因為殘留的斷言而一直保持喚醒。
- Tokimori 會在時段開始或結束、Mac 喚醒、時間或時區變更、App 打開或結束時重新計算；程序和電池電量則每 30 秒檢查一次。
- 若 App 計時器的時間落在 Mac 睡眠期間或 Tokimori 未執行期間，只要 Tokimori 在 10 分鐘內察覺，仍會執行；更早的則會略過，這樣早上掀開螢幕時，不會一口氣執行一連串過時的打開和結束動作。
- 打開 App 使用 `NSWorkspace`；結束時會請 App 正常結束，強制結束則使用 `NSRunningApplication.forceTerminate()`。macOS 不允許沙盒化的 App 結束其他 App，因此 Tokimori 沒有沙盒化，也不在 Mac App Store 上架。
- 規則儲存在 `~/Library/Application Support/net.zhaojian.tokimori/configuration.json`。唯一的網路請求是檢查更新，而且只在你按下時才會發出。

## 常見問題

**闔上螢幕時，它能讓 MacBook 保持喚醒嗎？**
不能。闔上螢幕會讓 MacBook 進入睡眠，與電源斷言無關，除非連接了外接顯示器、鍵盤和電源（闔蓋模式）。

**它能喚醒 Mac 來執行 App 計時器嗎？**
不能。在設定時間喚醒睡眠中的 Mac 需要管理者權限（`pmset schedule`）。計時器會在 Mac 喚醒時執行，並有上文所述的 10 分鐘寬限期。

**為什麼顯示器還是會關閉？**
預設只防止系統睡眠，這通常正是下載、建置和遠端連線所需要的。用於簡報或監看時，請開啟 **保持顯示器開啟**。

**它能搭配 macOS 26 的捷徑自動化操作使用嗎？**
可以。在個人自動化操作中使用 Tokimori 的動作即可，例如「當我連接 Wi-Fi 時……讓 Mac 保持喚醒」。

## 已知限制

- 如果你在「系統設定 › 鎖定畫面」中設定顯示器關閉後需要密碼，**關閉顯示器** 也可能會鎖定 Mac。
- 依命令列比對只能看到由你的使用者帳號啟動的程序。
- App 計時器精確到分鐘，且必須在 Tokimori 執行時才會運作。
- 介面翻譯尚未經過母語人士審閱。

## 從原始碼建置

需要 Xcode 27。

```sh
swift test --package-path TokimoriKit
xcodebuild -project Tokimori.xcodeproj -scheme Tokimori build
```

建置 DMG：

```sh
scripts/package.sh
```

輸出位於 `.build/dist/`，同時還會依據 `packaging/tokimori.rb` 產生一個已填入版本號和校驗和的 Homebrew cask。未設定環境變數時，App 會使用臨時（ad hoc）簽署且不經公證；此時 DMG 會包含 `First Launch.txt`。設定 `DEVELOPER_ID`（Developer ID Application 憑證名稱）即可用它簽署；再設定 `NOTARY_PROFILE`（用 `xcrun notarytool store-credentials` 儲存的憑證設定檔）即可進行公證並裝訂。

發行版本由 `.github/workflows/release.yml` 中的 GitHub Actions 工作流程建置。簽署方式以及如何發布新版本，請參閱 [docs/release.md](../release.md)。

## 專案結構

- `TokimoriKit/`：本機 Swift 套件。`TokimoriCore` 包含排程邏輯及其測試；`TokimoriPlatform` 封裝系統 API（IOKit 電源斷言和電池、程序列表、`NSWorkspace`）。
- `Apps/Tokimori/`：選單列 App（SwiftUI）。
- `scripts/`、`packaging/`：打包腳本和 Homebrew cask 範本。

## 授權條款

[MIT](../../LICENSE) © 2026 zhaoJian
