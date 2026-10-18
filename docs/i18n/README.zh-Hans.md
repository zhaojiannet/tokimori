<p align="center">
  <img src="../assets/icon.png" width="128" alt="Tokimori app icon">
</p>

<h1 align="center">Tokimori</h1>

<p align="center">
  <strong>在需要时使 Mac 保持唤醒，并按计划打开或退出 App。</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-14%2B-blue" alt="macOS 14 or later">
  <img src="https://img.shields.io/badge/Swift-6-orange" alt="Swift 6">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT License">
</p>

<p align="center">
  <a href="../../README.md">English</a> ·
  <b>简体中文</b> ·
  <a href="README.zh-Hant.md">繁體中文</a> ·
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

Tokimori（時守り，意为“守护时间的人”）是一款免费、开源的 macOS 菜单栏 App。它可以阻止 Mac 进入睡眠：可以立即开始，可以按每周计划进行，也可以在某个 App 或命令运行期间保持唤醒；它还能在你设定的时间打开或退出 App。它不在程序坞中显示图标。

下载大文件、编译、导出视频、运行 AI 代理、远程连接或演示时，都可以用它防止 Mac 睡眠。它和系统自带的 `caffeinate` 命令用的是同一套机制，另外加上了菜单、每周计划和 App 定时器，也不会模拟移动鼠标。

<p align="center">
  <img src="../assets/screenshot.png" width="420" alt="Tokimori 菜单">
</p>

## 目录

- [功能](#功能)
- [安装](#安装)
- [使用方法](#使用方法)
- [工作原理](#工作原理)
- [常见问题](#常见问题)
- [已知限制](#已知限制)
- [从源码构建](#从源码构建)

## 功能

- **一键保持唤醒。** 可以一直开启，也可以开启 30 分钟、1、2 或 4 小时，或者持续到你选定的时间。系统保持唤醒期间，屏幕仍会按原有设置熄灭。
- **屏幕常亮，或立即熄屏。** 可以选择同时让屏幕保持常亮。**立即熄屏** 会让屏幕变暗，而 Mac 继续运行。
- **计划。** 例如，让 Mac 在每个工作日的 09:00 到 18:00 保持唤醒。时段可以跨过午夜，此时它归属于开始的那一天。
- **运行期间。** 在某个 App 打开期间，或某个命令行进程运行期间保持 Mac 唤醒。进程可以按名称匹配（`ffmpeg`），也可以按命令行中包含的文本匹配（`claude`，适用于在 `node` 或 `python` 中运行的工具）。
- **App 定时器。** 在选定的日期和时间打开或退出某个 App，同一个 App 可以设置多个定时器。如果 App 在 30 秒后仍未退出（例如它在询问你是否保存），Tokimori 会通知你或强制退出它，具体由每个定时器单独设定。
- **电池保护。** 当 Mac 使用电池供电且电量低于你设定的水平（默认 20%）时，Tokimori 会停止保持唤醒。接上电源后，计划和运行时规则会恢复。
- **快捷指令操作。** *使 Mac 保持唤醒*、*停止使 Mac 保持唤醒* 和 *Mac 是否保持唤醒* 可以在“快捷指令”App 中使用，例如用于专注模式或 Wi-Fi 自动化。
- **15 种语言。** 英语、简体中文、繁体中文、日语、韩语、德语、法语、西班牙语、葡萄牙语、印度尼西亚语、泰语、越南语、阿拉伯语、俄语和印地语，可在 App 内切换。

## 安装

需要 macOS 14 Sonoma 或更高版本。

1. 打开 [Releases 页面](https://github.com/zhaojiannet/tokimori/releases)，在最新版本的 **Assets** 下载 `Tokimori-<version>.dmg`。
2. 双击下载的 DMG 将其打开。
3. 把 **Tokimori** 拖到同一窗口中显示的**应用程序**文件夹。
4. 推出 DMG，然后从“应用程序”文件夹打开 Tokimori。首次打开时，macOS 会要求你允许它运行，见[首次启动](#首次启动)。

无需安装程序，也不需要管理员密码。

**更新：** 下载新的 DMG，再次把 Tokimori 拖到“应用程序”文件夹，替换旧版本。你的规则会保留。要查看是否有新版本，请在“设置 › 通用”中点按 **检查更新…**。

**卸载：** 从 Tokimori 的菜单中退出它，然后把它移到废纸篓。如果还要删除它的规则和设置，请删除 `~/Library/Application Support/net.zhaojian.tokimori` 和 `~/Library/Preferences/net.zhaojian.tokimori.plist`。如果你开启了 **登录时打开**，请先关闭它，或者在“系统设置 › 通用 › 登录项”中移除 Tokimori。

### 首次启动

Tokimori 尚未经过 Apple 公证，因此首次打开时会被 macOS 阻止。按以下步骤允许一次即可：

1. 双击 Tokimori。当 macOS 提示无法验证 Tokimori 时，点按 **完成**。不要点按蓝色的 **移到废纸篓** 按钮。

   <img src="../assets/first-launch-1.png" width="341" alt="第一个警告：点按完成">

2. 打开 **系统设置 › 隐私与安全**，向下滚动到 **安全性**，点按 Tokimori 旁边的 **仍要打开**。完成第 1 步后，这个按钮大约会保留一小时。

   <img src="../assets/first-launch-2.png" width="560" alt="隐私与安全：点按仍要打开">

3. 输入登录密码或使用触控 ID。在随后出现的对话框中，再次点按 **仍要打开**。

   <img src="../assets/first-launch-3.png" width="341" alt="确认框：点按仍要打开">

此后，Tokimori 就能正常打开了。DMG 中的 `First Launch.txt` 也包含这些步骤。

## 使用方法

点按菜单栏中的沙漏图标。Mac 正被保持唤醒时，沙子会缓缓流下，沙漏每 30 分钟翻转一次；Mac 可以照常睡眠时，沙漏静止不动，沙子全部停在上方。

- **保持唤醒** 用于开启或关闭保持唤醒。它下方会列出当前是什么在让 Mac 保持唤醒，以及持续到什么时候。
- 点按时长按钮，会保持唤醒相应的时长。**直到…** 可以选择一个时间；如果这个时间今天已经过去，则表示明天的这个时间。
- **屏幕常亮** 只作用于你手动开启的保持唤醒。计划和运行时规则各有自己的设置。只要任一生效的来源要求屏幕常亮，屏幕就会保持常亮。
- 最后一行显示下一个 App 定时器。

如果在计划生效期间关闭保持唤醒，Tokimori 会询问你的意图：

- **停到 18:00**：在本时段剩余时间内保持关闭，下次计划会再次开启。
- **停用这个计划**：关闭这个计划，直到你在设置中重新开启它。
- **继续保持唤醒**：不做任何更改。

关闭保持唤醒还会暂停当前生效的运行时规则，直到对应的 App 或进程退出。

打开 **设置…** 管理规则。每条规则都是一张卡片，直接在卡片上编辑：更改会立即生效，卡片上的开关用于开启或关闭规则，废纸篓按钮用于删除规则。

- **通用：** 登录时打开、在菜单栏图标旁显示剩余时间、电池保护、语言、更新。
- **计划：** **添加计划** 会添加一个工作日 09:00–18:00 的计划；名称、日期和时间可在卡片上修改。
- **运行时：** **添加** 会列出当前打开的 App；选择其中一个，或者选择 **其他 App…**，或者选择 **命令行进程…** 并输入进程名称或其命令行的一部分。
- **App 定时器：** **添加定时器** 会列出当前打开的 App。新定时器会在工作日 09:00 打开该 App；如果该 App 已有打开定时器，则改为在 18:00 退出它。对于退出，可以选择 App 在 30 秒后仍未退出时如何处理。如果一个定时器会与另一个定时器在同一分钟打开和退出同一个 App，它就无法开启。

<p align="center">
  <img src="../assets/settings-general.png" width="380" alt="设置：通用">
  <img src="../assets/settings-schedules.png" width="380" alt="设置：计划">
  <img src="../assets/settings-while-running.png" width="380" alt="设置：运行时">
  <img src="../assets/settings-app-timers.png" width="380" alt="设置：App 定时器">
</p>

添加第一条规则时，Tokimori 会询问是否在登录时打开，因为规则只在它打开时运行。在有规则开启的情况下退出 Tokimori，会请你确认一次（可以关闭这个提问）。

## 工作原理

- 保持唤醒使用 `PreventUserIdleSystemSleep` 类型的 IOKit 电源断言，机制与 `caffeinate -i` 相同。**屏幕常亮** 会额外添加 `PreventUserIdleDisplaySleep`。在“终端”中运行 `pmset -g assertions` 即可看到这些断言。Tokimori 不会移动鼠标，也不会运行 `caffeinate`。
- 断言属于 Tokimori 进程，因此 Tokimori 退出或崩溃时，macOS 会自动释放它们。Mac 不会因为残留的断言而一直保持唤醒。
- Tokimori 会在以下情况重新计算：时段开始或结束时、Mac 唤醒时、时间或时区更改时、App 打开或退出时；对于进程和电池电量，则每 30 秒计算一次。
- 如果 App 定时器的时间点落在 Mac 睡眠期间或 Tokimori 未运行期间，只要 Tokimori 在 10 分钟内察觉，仍会执行；更早的则会跳过。这样，早上打开笔记本盖子时，不会一下子执行一连串过时的打开和退出操作。
- 打开 App 使用 `NSWorkspace`；退出时会请求 App 正常退出，强制退出则使用 `NSRunningApplication.forceTerminate()`。macOS 不允许沙盒 App 退出其他 App，因此 Tokimori 没有启用沙盒，也不在 Mac App Store 上架。
- 规则存储在 `~/Library/Application Support/net.zhaojian.tokimori/configuration.json` 中。唯一的网络请求是检查更新，而且只在你点按时才会发出。

## 常见问题

**合上盖子时，它能让 MacBook 保持唤醒吗？**
不能。合上盖子会让 MacBook 进入睡眠，与电源断言无关，除非连接了外接显示器、键盘和电源（合盖模式）。

**它能唤醒 Mac 来执行 App 定时器吗？**
不能。在设定时间唤醒处于睡眠状态的 Mac 需要管理员权限（`pmset schedule`）。定时器在 Mac 唤醒时运行，并有上文所述的 10 分钟宽限期。

**为什么屏幕还是会熄灭？**
默认只阻止系统睡眠，这通常正是下载、构建和远程会话所需要的。如果用于演示或监控，请开启 **屏幕常亮**。

**它能在 macOS 26 上配合快捷指令自动化使用吗？**
可以。在个人自动化中使用 Tokimori 的操作即可，例如“当我连接到 Wi-Fi 时……使 Mac 保持唤醒”。

## 已知限制

- 如果你在“系统设置 › 锁定屏幕”中设置了显示器关闭后需要输入密码，**立即熄屏** 也可能会锁定 Mac。
- 按命令行匹配只能看到由你的用户帐户启动的进程。
- App 定时器精确到分钟，并且依赖 Tokimori 处于运行状态。
- 界面翻译尚未经过母语人士审校。

## 从源码构建

需要 Xcode 27。

```sh
swift test --package-path TokimoriKit
xcodebuild -project Tokimori.xcodeproj -scheme Tokimori build
```

构建 DMG：

```sh
scripts/package.sh
```

输出位于 `.build/dist/`，同时还会根据 `packaging/tokimori.rb` 生成一个已填好版本号和校验和的 Homebrew cask。不设置环境变量时，App 会进行临时签名（ad hoc），且不经过公证；此时 DMG 会包含 `First Launch.txt`。设置 `DEVELOPER_ID`（Developer ID Application 证书名称）即可用该证书签名；再设置 `NOTARY_PROFILE`（用 `xcrun notarytool store-credentials` 保存的凭证配置），即可进行公证并装订票据。

发布版本由 `.github/workflows/release.yml` 中的 GitHub Actions 工作流构建。签名方式以及如何发布新版本，见 [docs/release.md](../release.md)。

## 项目结构

- `TokimoriKit/`：本地 Swift 包。`TokimoriCore` 包含调度逻辑及其测试；`TokimoriPlatform` 封装系统 API（IOKit 电源断言和电池、进程列表、`NSWorkspace`）。
- `Apps/Tokimori/`：菜单栏 App（SwiftUI）。
- `scripts/`、`packaging/`：打包脚本和 Homebrew cask 模板。

## 许可证

[MIT](../../LICENSE) © 2026 zhaoJian
