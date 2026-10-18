<p align="center">
  <img src="../assets/icon.png" width="128" alt="Tokimori app icon">
</p>

<h1 align="center">Tokimori</h1>

<p align="center">
  <strong>필요할 때 Mac이 잠자기에 들어가지 않도록 하고, 일정에 따라 앱을 열거나 종료합니다.</strong>
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
  <b>한국어</b> ·
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

Tokimori(時守り, '시간을 지키는 이')는 macOS용 무료 오픈 소스 메뉴 막대 앱입니다. 지금 바로, 매주 일정에 따라, 또는 특정 앱이나 명령이 실행되는 동안 Mac이 잠자기에 들어가지 않도록 하고, 설정한 시간에 앱을 열거나 종료합니다. Dock 아이콘은 없습니다.

대용량 다운로드, 빌드, 동영상 내보내기, AI 에이전트 실행, 원격 접속, 프레젠테이션 중에 Mac이 잠자기에 들어가지 않도록 할 수 있습니다. macOS에 내장된 `caffeinate` 명령과 같은 방식으로 동작하며, 메뉴, 일정, 앱 타이머를 더했습니다. 마우스를 움직이는 방식은 쓰지 않습니다.

<p align="center">
  <img src="../assets/screenshot.png" width="420" alt="Tokimori 메뉴">
</p>

## 목차

- [기능](#기능)
- [설치](#설치)
- [사용법](#사용법)
- [작동 방식](#작동-방식)
- [자주 묻는 질문](#자주-묻는-질문)
- [알려진 제한 사항](#알려진-제한-사항)
- [소스에서 빌드](#소스에서-빌드)

## 기능

- **클릭 한 번으로 깨어 있게 유지.** 무기한, 30분, 1·2·4시간, 또는 선택한 시간까지 켤 수 있습니다. 시스템은 깨어 있지만 디스플레이는 평소 설정대로 꺼질 수 있습니다.
- **디스플레이를 켜 두거나 지금 끄기.** 필요하면 디스플레이도 켜 둘 수 있습니다. **디스플레이 끄기**는 Mac이 계속 작동하는 동안 화면만 어둡게 합니다.
- **일정.** 예를 들어 평일마다 09:00부터 18:00까지 Mac을 깨어 있게 할 수 있습니다. 기간이 자정을 넘겨 끝날 수도 있으며, 이 경우 시작한 날에 속합니다.
- **실행 중.** 앱이 열려 있는 동안, 또는 명령줄 프로세스가 실행되는 동안 Mac을 깨어 있게 합니다. 프로세스는 이름(`ffmpeg`)이나 명령줄에 포함된 텍스트(`node`나 `python` 안에서 실행되는 도구라면 `claude`)로 찾습니다.
- **앱 타이머.** 선택한 요일의 정해진 시간에 앱을 열거나 종료합니다. 같은 앱에 타이머를 여러 개 둘 수 있습니다. 30초가 지나도 앱이 종료되지 않으면(예: 저장할지 묻고 있는 경우) Tokimori가 알림을 보내거나 강제 종료합니다. 타이머마다 선택할 수 있습니다.
- **배터리 보호.** Mac이 배터리로 작동하고 잔량이 설정한 수준(기본값 20%) 아래로 내려가면 Tokimori는 깨어 있게 유지하는 것을 멈춥니다. 전원을 연결하면 일정과 실행 중 규칙이 다시 적용됩니다.
- **단축어 동작.** *Mac 잠자기 방지*, *Mac 잠자기 방지 중단*, *Mac 잠자기 방지 여부*를 단축어 앱에서 사용할 수 있습니다. 예를 들어 집중 모드나 Wi-Fi 자동화에 넣을 수 있습니다.
- **15개 언어.** 영어, 중국어 간체, 중국어 번체, 일본어, 한국어, 독일어, 프랑스어, 스페인어, 포르투갈어, 인도네시아어, 태국어, 베트남어, 아랍어, 러시아어, 힌디어를 지원하며 앱 안에서 바꿀 수 있습니다.

## 설치

macOS 14 Sonoma 이상이 필요합니다.

1. [Releases 페이지](https://github.com/zhaojiannet/tokimori/releases)를 열고 최신 릴리스의 **Assets**에서 `Tokimori-<version>.dmg`를 다운로드합니다.
2. 다운로드한 DMG를 이중 클릭하여 엽니다.
3. **Tokimori**를 같은 윈도우에 보이는 **응용 프로그램** 폴더로 드래그합니다.
4. DMG를 추출한 다음 응용 프로그램 폴더에서 Tokimori를 엽니다. 처음에는 macOS가 허용할지 묻습니다. [처음 실행하기](#처음-실행하기)를 참고하십시오.

설치 프로그램은 없으며 관리자 암호도 필요하지 않습니다.

**업데이트:** 새 DMG를 다운로드하고 Tokimori를 다시 응용 프로그램 폴더로 드래그하여 이전 버전을 대치합니다. 규칙은 유지됩니다. 새 버전이 나왔는지 확인하려면 설정 › 일반에서 **업데이트 확인…**를 클릭합니다.

**제거:** Tokimori 메뉴에서 종료한 다음 휴지통으로 옮깁니다. 규칙과 설정까지 지우려면 `~/Library/Application Support/net.zhaojian.tokimori`와 `~/Library/Preferences/net.zhaojian.tokimori.plist`를 삭제합니다. **로그인 시 열기**를 켰다면 먼저 끄거나, 시스템 설정 › 일반 › 로그인 항목에서 Tokimori를 제거합니다.

### 처음 실행하기

Tokimori는 아직 Apple의 공증을 받지 않았기 때문에 처음 열 때 macOS가 차단합니다. 한 번만 다음과 같이 허용하십시오.

1. Tokimori를 이중 클릭합니다. macOS가 Tokimori를 확인할 수 없다고 하면 **완료**를 클릭합니다. 파란색 **휴지통으로 이동** 버튼은 클릭하지 마십시오.

   <img src="../assets/first-launch-1.png" width="341" alt="첫 번째 경고: 완료 클릭">

2. **시스템 설정 › 개인정보 보호 및 보안**을 열고 **보안**까지 스크롤한 다음 Tokimori 옆의 **그래도 열기**를 클릭합니다. 이 버튼은 1단계 후 약 1시간 동안 표시됩니다.

   <img src="../assets/first-launch-2.png" width="560" alt="개인정보 보호 및 보안: 그래도 열기 클릭">

3. 로그인 암호를 입력하거나 Touch ID를 사용합니다. 이어서 나타나는 대화상자에서 **그래도 열기**를 다시 클릭합니다.

   <img src="../assets/first-launch-3.png" width="341" alt="확인 대화상자: 그래도 열기 클릭">

이후에는 Tokimori가 정상적으로 열립니다. 이 단계는 DMG 안의 `First Launch.txt`에도 들어 있습니다.

## 사용법

메뉴 막대의 모래시계를 클릭합니다. 무언가가 Mac을 깨어 있게 하는 동안에는 모래가 흘러내리고 모래시계가 30분마다 뒤집힙니다. Mac이 평소처럼 잠자기에 들어갈 수 있으면 모래가 모두 위에 있는 채로 멈춰 있습니다.

- **잠자기 방지**로 잠자기 방지를 켜거나 끕니다. 그 아래에 지금 무엇이 Mac을 깨어 있게 하고 있는지, 언제까지인지가 표시됩니다.
- 시간 버튼을 누르면 그 시간 동안 깨어 있게 유지합니다. **종료 시간 지정…**로 시간을 고를 수 있으며, 오늘 이미 지난 시간을 고르면 내일을 뜻합니다.
- **디스플레이 켜 두기**는 직접 켠 잠자기 방지에 적용됩니다. 일정과 실행 중 규칙에는 각각 자체 설정이 있습니다. 활성화된 소스 중 하나라도 요청하면 디스플레이는 켜진 상태로 유지됩니다.
- 마지막 줄에는 다음 앱 타이머가 표시됩니다.

일정이 활성화된 동안 잠자기 방지를 끄면 Tokimori가 어떤 의도인지 묻습니다.

- **18:00까지 중단** — 이번 기간의 남은 시간 동안 꺼진 상태로 두고, 다음 번에 일정이 다시 켜집니다.
- **이 일정 끄기** — 설정에서 다시 켤 때까지 이 일정을 끕니다.
- **계속 깨어 있기** — 아무것도 바꾸지 않습니다.

끄면 활성화된 실행 중 규칙도 해당 앱이나 프로세스가 종료될 때까지 일시 정지됩니다.

규칙을 관리하려면 **설정…** 화면을 엽니다. 각 규칙은 그 자리에서 편집하는 카드입니다. 변경 사항은 바로 적용되고, 카드의 스위치로 켜거나 끄며, 휴지통 버튼으로 삭제합니다.

- **일반:** 로그인 시 열기, 메뉴 막대 아이콘 옆에 남은 시간 표시, 배터리 보호, 언어, 업데이트.
- **일정:** **일정 추가** 버튼은 평일 09:00–18:00 일정을 추가합니다. 이름, 요일, 시간은 카드에서 바꿉니다.
- **실행 중:** **추가** 버튼은 지금 열려 있는 앱을 나열합니다. 그중 하나를 고르거나, **기타 앱…** 항목을 선택하거나, **명령줄 프로세스…** 항목을 선택한 다음 프로세스 이름이나 명령줄의 일부를 입력합니다.
- **앱 타이머:** **타이머 추가** 버튼은 지금 열려 있는 앱을 나열합니다. 새 타이머는 평일 09:00에 앱을 열고, 그 앱에 이미 열기 타이머가 있으면 18:00에 종료합니다. 종료의 경우 30초 후에도 앱이 종료되지 않으면 어떻게 할지 선택합니다. 다른 타이머와 같은 분에 같은 앱을 열고 종료하게 되는 타이머는 켤 수 없습니다.

<p align="center">
  <img src="../assets/settings-general.png" width="380" alt="설정: 일반">
  <img src="../assets/settings-schedules.png" width="380" alt="설정: 일정">
  <img src="../assets/settings-while-running.png" width="380" alt="설정: 실행 중">
  <img src="../assets/settings-app-timers.png" width="380" alt="설정: 앱 타이머">
</p>

첫 규칙을 추가하면 Tokimori는 로그인 시 열지 묻습니다. 규칙은 Tokimori가 열려 있는 동안에만 실행되기 때문입니다. 규칙이 켜져 있는 상태에서 Tokimori를 종료하면 한 번 확인을 요청합니다(이 질문은 끌 수 있습니다).

## 작동 방식

- 잠자기 방지는 `PreventUserIdleSystemSleep` 유형의 IOKit 전원 어서션을 사용하며, `caffeinate -i`와 같은 메커니즘입니다. **디스플레이 켜 두기**는 `PreventUserIdleDisplaySleep`을 추가합니다. 터미널에서 `pmset -g assertions`를 실행하면 확인할 수 있습니다. Tokimori는 마우스를 움직이거나 `caffeinate`를 실행하지 않습니다.
- 어서션은 Tokimori 프로세스에 속하므로 Tokimori가 종료되거나 충돌하면 macOS가 자동으로 해제합니다. 남은 어서션 때문에 Mac이 계속 깨어 있는 일은 절대 없습니다.
- Tokimori는 기간이 시작되거나 끝날 때, Mac이 깨어날 때, 시간이나 시간대가 바뀔 때, 앱이 열리거나 종료될 때 다시 계산하며, 프로세스와 배터리 잔량은 30초마다 다시 계산합니다.
- Mac이 잠자기 중이거나 Tokimori가 실행되지 않는 동안 예정된 앱 타이머는 Tokimori가 10분 안에 알아차리면 그래도 실행됩니다. 그보다 오래된 것은 건너뛰므로, 아침에 덮개를 열 때 지난 열기와 종료가 한꺼번에 실행되지 않습니다.
- 열기에는 `NSWorkspace`를 사용합니다. 종료는 앱에 정상적으로 종료하도록 요청하고, 강제 종료는 `NSRunningApplication.forceTerminate()`를 사용합니다. macOS는 샌드박스 앱이 다른 앱을 종료하는 것을 허용하지 않으므로 Tokimori는 샌드박스가 적용되지 않았으며 Mac App Store에도 없습니다.
- 규칙은 `~/Library/Application Support/net.zhaojian.tokimori/configuration.json`에 저장됩니다. 유일한 네트워크 요청은 업데이트 확인이며, 그것도 클릭할 때만 이루어집니다.

## 자주 묻는 질문

**덮개를 닫아도 MacBook을 깨어 있게 할 수 있습니까?**
아니요. 외장 디스플레이, 키보드, 전원이 연결된 경우(클램셸 모드)가 아니면 덮개를 닫을 때 전원 어서션과 관계없이 MacBook은 잠자기에 들어갑니다.

**앱 타이머를 실행하려고 Mac을 깨울 수 있습니까?**
아니요. 잠자기 중인 Mac을 정해진 시간에 깨우려면 관리자 권한(`pmset schedule`)이 필요합니다. 타이머는 Mac이 깨어 있는 동안 실행되며, 위에서 설명한 10분의 유예 시간이 있습니다.

**왜 디스플레이는 여전히 꺼집니까?**
기본적으로 시스템 잠자기만 막습니다. 다운로드, 빌드, 원격 세션에는 보통 이것으로 충분합니다. 프레젠테이션이나 모니터링에는 **디스플레이 켜 두기**를 켜십시오.

**macOS 26의 단축어 자동화와 함께 사용할 수 있습니까?**
예. '내가 Wi-Fi에 연결할 때 … Mac 잠자기 방지'처럼 개인용 자동화에서 Tokimori 동작을 사용하십시오.

## 알려진 제한 사항

- 시스템 설정 › 잠금 화면에서 디스플레이가 꺼진 후 암호를 요구하도록 설정했다면 **디스플레이 끄기**가 Mac을 잠글 수도 있습니다.
- 명령줄로 찾기는 사용자 계정으로 시작된 프로세스만 볼 수 있습니다.
- 앱 타이머는 분 단위로 작동하며 Tokimori가 실행 중이어야 합니다.
- 인터페이스 번역은 아직 원어민의 검토를 받지 않았습니다.

## 소스에서 빌드

Xcode 27이 필요합니다.

```sh
swift test --package-path TokimoriKit
xcodebuild -project Tokimori.xcodeproj -scheme Tokimori build
```

DMG를 빌드하려면:

```sh
scripts/package.sh
```

결과물은 `.build/dist/`에 생성되며, `packaging/tokimori.rb`에서 버전과 체크섬을 채워 생성한 Homebrew cask도 함께 들어갑니다. 환경 변수가 없으면 앱은 애드혹 서명되고 공증되지 않으며, 이 경우 DMG에 `First Launch.txt`가 포함됩니다. `DEVELOPER_ID`(Developer ID Application 인증서 이름)를 설정하면 그 인증서로 서명하고, `NOTARY_PROFILE`(`xcrun notarytool store-credentials`로 저장한 자격 증명 프로필)도 설정하면 공증과 스테이플링을 합니다.

릴리스는 `.github/workflows/release.yml`의 GitHub Actions 워크플로로 빌드됩니다. 서명 방식과 릴리스를 게시하는 방법은 [docs/release.md](../release.md)에 설명되어 있습니다.

## 프로젝트 구조

- `TokimoriKit/`: 로컬 Swift 패키지. `TokimoriCore`에는 일정 로직과 테스트가 있고, `TokimoriPlatform`은 시스템 API(IOKit 전원 어서션과 배터리, 프로세스 목록, `NSWorkspace`)를 감쌉니다.
- `Apps/Tokimori/`: 메뉴 막대 앱(SwiftUI).
- `scripts/`, `packaging/`: 패키징 스크립트와 Homebrew cask 템플릿.

## 라이선스

[MIT](../../LICENSE) © 2026 zhaoJian
