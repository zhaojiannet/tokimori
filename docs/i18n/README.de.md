<p align="center">
  <img src="../assets/icon.png" width="128" alt="Tokimori app icon">
</p>

<h1 align="center">Tokimori</h1>

<p align="center">
  <strong>Halte deinen Mac wach, wenn du ihn brauchst, und öffne oder beende Apps nach Zeitplan.</strong>
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
  <b>Deutsch</b> ·
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

Tokimori (時守り, „Hüter der Zeit“) ist eine kostenlose Open-Source-Menüleisten-App für macOS. Sie verhindert, dass dein Mac in den Ruhezustand wechselt – sofort, nach einem Wochenplan oder solange eine bestimmte App oder ein Befehl läuft – und öffnet oder beendet Apps zu den Zeiten, die du festlegst. Sie hat kein Dock-Symbol.

So bleibt dein Mac bei Downloads, Builds, Videoexporten, KI-Agenten, Fernzugriff oder Präsentationen wach. Tokimori nutzt denselben Mechanismus wie der eingebaute Befehl `caffeinate`, ergänzt um ein Menü, Zeitpläne und App-Timer, und bewegt nie die Maus.

<p align="center">
  <img src="../assets/screenshot.png" width="420" alt="Das Tokimori-Menü">
</p>

## Inhalt

- [Funktionen](#funktionen)
- [Installation](#installation)
- [Verwendung](#verwendung)
- [Funktionsweise](#funktionsweise)
- [Häufige Fragen](#häufige-fragen)
- [Bekannte Einschränkungen](#bekannte-einschränkungen)
- [Aus dem Quellcode bauen](#aus-dem-quellcode-bauen)

## Funktionen

- **Wach halten mit einem Klick.** Unbegrenzt, für 30 Minuten, 1, 2 oder 4 Stunden oder bis zu einer gewählten Uhrzeit. Das System bleibt wach, während sich das Display weiterhin wie gewohnt ausschalten kann.
- **Display eingeschaltet lassen oder sofort ausschalten.** Auf Wunsch bleibt auch das Display an. **Display ausschalten** schaltet das Display dunkel, während dein Mac weiterläuft.
- **Zeitpläne.** Halte deinen Mac zum Beispiel an jedem Werktag von 09:00 bis 18:00 wach. Ein Zeitraum kann nach Mitternacht enden; er gehört dann zu dem Tag, an dem er beginnt.
- **Solange aktiv.** Halte deinen Mac wach, solange eine App geöffnet ist oder ein Befehlszeilenprozess läuft – erkannt am Namen (`ffmpeg`) oder an Text in der Befehlszeile (`claude`, für Tools, die in `node` oder `python` laufen).
- **App-Timer.** Öffne oder beende eine App an ausgewählten Tagen zu einer festen Uhrzeit. Eine App kann mehrere Timer haben. Wenn eine App nach 30 Sekunden nicht beendet ist (etwa weil sie fragt, ob gesichert werden soll), benachrichtigt dich Tokimori oder erzwingt das Beenden – das wählst du pro Timer.
- **Batterieschutz.** Läuft dein Mac im Batteriebetrieb und sinkt die Ladung unter einen gewählten Wert (standardmäßig 20 %), hält Tokimori ihn nicht mehr wach. Zeitpläne und Regeln für laufende Apps greifen wieder, sobald du das Netzteil anschließt.
- **Kurzbefehle-Aktionen.** *Mac wach halten*, *Mac nicht mehr wach halten* und *Wird Mac wach gehalten* lassen sich in der App „Kurzbefehle“ verwenden, zum Beispiel in einer Fokus- oder WLAN-Automation.
- **15 Sprachen.** Englisch, vereinfachtes Chinesisch, traditionelles Chinesisch, Japanisch, Koreanisch, Deutsch, Französisch, Spanisch, Portugiesisch, Indonesisch, Thai, Vietnamesisch, Arabisch, Russisch und Hindi, umschaltbar in der App.

## Installation

Erfordert macOS 14 Sonoma oder neuer.

1. Öffne die [Releases-Seite](https://github.com/zhaojiannet/tokimori/releases) und lade unter **Assets** des neuesten Release `Tokimori-<version>.dmg` herunter.
2. Doppelklicke auf das geladene DMG, um es zu öffnen.
3. Ziehe **Tokimori** auf den Ordner **Programme**, der im selben Fenster angezeigt wird.
4. Wirf das DMG aus und öffne Tokimori dann aus dem Ordner „Programme“. Beim ersten Mal fragt macOS nach deiner Erlaubnis; siehe [Erster Start](#erster-start).

Es gibt kein Installationsprogramm, und es ist kein Administratorpasswort nötig.

**Aktualisieren:** Lade das neue DMG und ziehe Tokimori erneut in „Programme“, um die alte Version zu ersetzen. Deine Regeln bleiben erhalten. Ob eine neuere Version verfügbar ist, erfährst du mit **Nach Updates suchen …** unter Einstellungen › Allgemein.

**Deinstallieren:** Beende Tokimori über sein Menü und lege es in den Papierkorb. Um auch die Regeln und Einstellungen zu entfernen, lösche `~/Library/Application Support/net.zhaojian.tokimori` und `~/Library/Preferences/net.zhaojian.tokimori.plist`. Wenn du **Beim Anmelden öffnen** aktiviert hast, deaktiviere es vorher oder entferne Tokimori unter „Systemeinstellungen › Allgemein › Anmeldeobjekte“.

### Erster Start

Tokimori ist noch nicht von Apple notarisiert, deshalb blockiert macOS es beim ersten Öffnen. Erlaube es einmalig:

1. Doppelklicke auf Tokimori. Wenn macOS meldet, dass Tokimori nicht überprüft werden konnte, klicke auf **Fertig**. Klicke nicht auf die blaue Taste **In den Papierkorb legen**.

   <img src="../assets/first-launch-1.png" width="341" alt="Die erste Warnung: auf Fertig klicken">

2. Öffne **Systemeinstellungen › Datenschutz & Sicherheit**, scrolle nach unten zu **Sicherheit** und klicke neben Tokimori auf **Dennoch öffnen**. Die Taste ist nach Schritt 1 etwa eine Stunde lang verfügbar.

   <img src="../assets/first-launch-2.png" width="560" alt="Datenschutz & Sicherheit: auf Dennoch öffnen klicken">

3. Gib dein Anmeldepasswort ein oder verwende Touch ID. Klicke im folgenden Dialog erneut auf **Dennoch öffnen**.

   <img src="../assets/first-launch-3.png" width="341" alt="Die Bestätigung: auf Dennoch öffnen klicken">

Danach öffnet sich Tokimori ganz normal. Das DMG enthält diese Schritte auch in `First Launch.txt`.

## Verwendung

Klicke auf die Sanduhr in der Menüleiste. Solange etwas deinen Mac wach hält, rieselt ihr Sand nach unten, und die Sanduhr dreht sich alle 30 Minuten um; kann dein Mac wie gewohnt in den Ruhezustand wechseln, steht sie still und der ganze Sand liegt oben.

- **Wach halten** schaltet das Wachhalten ein oder aus. Darunter zeigt Tokimori, was deinen Mac gerade wach hält und bis wann.
- Die Dauer-Tasten halten den Mac für die jeweilige Zeit wach. Mit **Bis …** wählst du eine Uhrzeit; eine Uhrzeit, die heute schon vorbei ist, bedeutet morgen.
- **Display eingeschaltet lassen** gilt für das Wachhalten, das du selbst einschaltest. Zeitpläne und Regeln für laufende Apps haben jeweils eine eigene Einstellung. Das Display bleibt an, sobald eine aktive Quelle das verlangt.
- Die letzte Zeile zeigt den nächsten App-Timer.

Schaltest du das Wachhalten aus, während ein Zeitplan aktiv ist, fragt Tokimori, was du meinst:

- **Stoppen bis 18:00** – bleibt für den Rest dieses Zeitraums aus; der Zeitplan schaltet sich beim nächsten Mal wieder ein.
- **Diesen Zeitplan deaktivieren** – der Zeitplan bleibt aus, bis du ihn in den Einstellungen wieder einschaltest.
- **Wach bleiben** – ändert nichts.

Das Ausschalten pausiert außerdem aktive Regeln für laufende Apps, bis die betreffende App oder der Prozess beendet wird.

Öffne **Einstellungen …**, um Regeln zu verwalten. Jede Regel ist eine Karte, die du direkt bearbeitest: Änderungen gelten sofort, der Schalter auf der Karte schaltet sie ein oder aus, und die Papierkorbtaste löscht sie.

- **Allgemein:** beim Anmelden öffnen, Restzeit neben dem Menüleistensymbol anzeigen, Batterieschutz, Sprache, Updates.
- **Zeitpläne:** **Zeitplan hinzufügen** fügt Werktage von 09:00 bis 18:00 hinzu; Name, Tage und Uhrzeiten änderst du auf der Karte.
- **Solange aktiv:** **Hinzufügen** listet die gerade geöffneten Apps auf; wähle eine davon, wähle **Andere App …** oder wähle **Befehlszeilenprozess …** und gib den Namen oder einen Teil der Befehlszeile ein.
- **App-Timer:** **Timer hinzufügen** listet die gerade geöffneten Apps auf. Ein neuer Timer öffnet die App an Werktagen um 09:00 oder beendet sie um 18:00, falls die App bereits einen Timer zum Öffnen hat. Beim Beenden wählst du, was passiert, wenn die App nach 30 Sekunden nicht beendet ist. Ein Timer, der dieselbe App in derselben Minute öffnen und beenden würde wie ein anderer, lässt sich nicht einschalten.

<p align="center">
  <img src="../assets/settings-general.png" width="380" alt="Einstellungen: Allgemein">
  <img src="../assets/settings-schedules.png" width="380" alt="Einstellungen: Zeitpläne">
  <img src="../assets/settings-while-running.png" width="380" alt="Einstellungen: Solange aktiv">
  <img src="../assets/settings-app-timers.png" width="380" alt="Einstellungen: App-Timer">
</p>

Wenn du deine erste Regel hinzufügst, fragt Tokimori, ob es beim Anmelden geöffnet werden soll, denn Regeln laufen nur, solange es geöffnet ist. Beendest du Tokimori, während Regeln aktiv sind, wirst du einmal um Bestätigung gebeten (diese Frage lässt sich abschalten).

## Funktionsweise

- Das Wachhalten verwendet eine IOKit-Power-Assertion vom Typ `PreventUserIdleSystemSleep`, denselben Mechanismus wie `caffeinate -i`. **Display eingeschaltet lassen** fügt `PreventUserIdleDisplaySleep` hinzu. Führe `pmset -g assertions` im Terminal aus, um sie zu sehen. Tokimori bewegt weder die Maus noch führt es `caffeinate` aus.
- Assertions gehören zum Tokimori-Prozess, daher gibt macOS sie automatisch frei, wenn Tokimori beendet wird oder abstürzt. Dein Mac kann also nie wegen einer übrig gebliebenen Assertion wach bleiben.
- Tokimori rechnet neu, wenn ein Zeitraum beginnt oder endet, wenn dein Mac aufwacht, wenn sich Uhrzeit oder Zeitzone ändern, wenn Apps geöffnet oder beendet werden, und alle 30 Sekunden für Prozesse und Batteriestand.
- Ein App-Timer, der in eine Zeit fällt, in der dein Mac schläft oder Tokimori nicht läuft, wird trotzdem ausgeführt, wenn Tokimori es innerhalb von 10 Minuten bemerkt; ältere werden übersprungen, damit du beim Aufklappen am Morgen keine Flut veralteter Öffnen- und Beenden-Aktionen bekommst.
- Zum Öffnen dient `NSWorkspace`; beim Beenden wird die App gebeten, sich normal zu beenden, und das erzwungene Beenden verwendet `NSRunningApplication.forceTerminate()`. macOS erlaubt Apps in einer Sandbox nicht, andere Apps zu beenden, deshalb läuft Tokimori ohne Sandbox und ist nicht im Mac App Store erhältlich.
- Regeln werden in `~/Library/Application Support/net.zhaojian.tokimori/configuration.json` gespeichert. Die einzige Netzwerkanfrage ist die Update-Prüfung, und auch nur, wenn du darauf klickst.

## Häufige Fragen

**Hält es mein MacBook bei geschlossenem Deckel wach?**
Nein. Das Schließen des Deckels versetzt ein MacBook unabhängig von Power-Assertions in den Ruhezustand, es sei denn, ein externes Display, eine Tastatur und das Netzteil sind angeschlossen (Clamshell-Modus).

**Kann es meinen Mac aufwecken, um einen App-Timer auszuführen?**
Nein. Einen schlafenden Mac zu einer festen Zeit aufzuwecken erfordert Administratorrechte (`pmset schedule`). Timer laufen, während dein Mac wach ist, mit der oben beschriebenen Kulanzzeit von 10 Minuten.

**Warum schaltet sich das Display trotzdem aus?**
Standardmäßig wird nur der System-Ruhezustand verhindert – das ist für Downloads, Builds und Remote-Sitzungen meist genau das Richtige. Für Präsentationen oder Überwachung schalte **Display eingeschaltet lassen** ein.

**Funktioniert es mit Kurzbefehle-Automationen unter macOS 26?**
Ja. Verwende die Tokimori-Aktionen in einer persönlichen Automation, etwa „Wenn ich mich mit WLAN verbinde … Mac wach halten“.

## Bekannte Einschränkungen

- **Display ausschalten** kann deinen Mac auch sperren, wenn du unter „Systemeinstellungen › Sperrbildschirm“ festgelegt hast, dass nach dem Ausschalten des Displays ein Passwort erforderlich ist.
- Die Erkennung über die Befehlszeile sieht nur Prozesse, die von deinem Benutzeraccount gestartet wurden.
- App-Timer arbeiten minutengenau und setzen voraus, dass Tokimori läuft.
- Die Übersetzungen der Benutzeroberfläche wurden noch nicht von Muttersprachlern geprüft.

## Aus dem Quellcode bauen

Erfordert Xcode 27.

```sh
swift test --package-path TokimoriKit
xcodebuild -project Tokimori.xcodeproj -scheme Tokimori build
```

Ein DMG bauen:

```sh
scripts/package.sh
```

Die Ausgabe landet in `.build/dist/`, zusammen mit einem Homebrew-Cask, der aus `packaging/tokimori.rb` erzeugt und mit Version und Prüfsumme gefüllt wird. Ohne Umgebungsvariablen wird die App ad hoc signiert und nicht notarisiert; das DMG enthält dann `First Launch.txt`. Setze `DEVELOPER_ID` (den Namen eines Developer-ID-Application-Zertifikats), um damit zu signieren, und zusätzlich `NOTARY_PROFILE` (ein mit `xcrun notarytool store-credentials` gespeichertes Anmeldeprofil), um zu notarisieren und das Ticket anzuheften.

Releases werden vom GitHub-Actions-Workflow in `.github/workflows/release.yml` gebaut. Wie dabei signiert wird und wie man ein Release veröffentlicht, steht in [docs/release.md](../release.md).

## Projektstruktur

- `TokimoriKit/`: ein lokales Swift-Paket. `TokimoriCore` enthält die Zeitplanlogik und ihre Tests; `TokimoriPlatform` kapselt die System-APIs (IOKit-Power-Assertions und Batterie, Prozessliste, `NSWorkspace`).
- `Apps/Tokimori/`: die Menüleisten-App (SwiftUI).
- `scripts/`, `packaging/`: das Paketierungsskript und die Homebrew-Cask-Vorlage.

## Lizenz

[MIT](../../LICENSE) © 2026 zhaoJian
