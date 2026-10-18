<p align="center">
  <img src="../assets/icon.png" width="128" alt="Tokimori app icon">
</p>

<h1 align="center">Tokimori</h1>

<p align="center">
  <strong>Maintenez votre Mac éveillé quand vous en avez besoin, et ouvrez ou quittez des apps selon un horaire.</strong>
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
  <b>Français</b> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.id.md">Bahasa Indonesia</a> ·
  <a href="README.th.md">ไทย</a> ·
  <a href="README.vi.md">Tiếng Việt</a> ·
  <a href="README.ar.md">العربية</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.hi.md">हिन्दी</a>
</p>

Tokimori (時守り, « gardien du temps ») est une app de barre des menus gratuite et open source pour macOS. Elle empêche votre Mac de se mettre en veille — tout de suite, selon un horaire hebdomadaire ou tant qu’une app ou une commande donnée est en cours d’exécution — et ouvre ou quitte des apps aux heures que vous choisissez. Elle n’a pas d’icône dans le Dock.

Utilisez-la pour empêcher votre Mac de se mettre en veille pendant un téléchargement, une compilation, un export vidéo, un agent IA, une session à distance ou une présentation. Elle repose sur le même mécanisme que la commande intégrée `caffeinate`, y ajoute un menu, des horaires et des minuteurs d’app, et ne bouge jamais la souris.

<p align="center">
  <img src="../assets/screenshot.png" width="420" alt="Le menu de Tokimori">
</p>

## Sommaire

- [Fonctionnalités](#fonctionnalités)
- [Installation](#installation)
- [Utilisation](#utilisation)
- [Fonctionnement](#fonctionnement)
- [Questions fréquentes](#questions-fréquentes)
- [Limites connues](#limites-connues)
- [Compiler depuis les sources](#compiler-depuis-les-sources)

## Fonctionnalités

- **Maintenir éveillé en un clic.** Activez-le sans limite, pour 30 minutes, 1, 2 ou 4 heures, ou jusqu’à l’heure de votre choix. Le système reste éveillé, tandis que l’écran peut toujours s’éteindre selon son réglage habituel.
- **Garder l’écran allumé, ou l’éteindre tout de suite.** Vous pouvez aussi garder l’écran allumé. **Éteindre l’écran** assombrit l’écran pendant que votre Mac continue de fonctionner.
- **Horaires.** Maintenez par exemple votre Mac éveillé chaque jour de semaine de 09:00 à 18:00. Une période peut se terminer après minuit ; elle appartient alors au jour où elle commence.
- **Pendant l’exécution.** Maintenez votre Mac éveillé tant qu’une app est ouverte ou qu’un processus en ligne de commande s’exécute — reconnu par son nom (`ffmpeg`) ou par un texte de sa ligne de commande (`claude`, pour les outils qui s’exécutent dans `node` ou `python`).
- **Minuteurs d’app.** Ouvrez ou quittez une app certains jours à une heure donnée. Une même app peut avoir plusieurs minuteurs. Si une app n’a pas quitté au bout de 30 secondes (par exemple parce qu’elle vous demande d’enregistrer), Tokimori vous avertit ou force sa fermeture — vous choisissez pour chaque minuteur.
- **Protection de la batterie.** Quand votre Mac fonctionne sur batterie en dessous d’un niveau que vous choisissez (20 % par défaut), Tokimori cesse de le maintenir éveillé. Les horaires et les règles d’exécution reprennent dès que vous le branchez.
- **Actions Raccourcis.** *Maintenir le Mac éveillé*, *Ne plus maintenir le Mac éveillé* et *Le Mac est-il maintenu éveillé* peuvent être utilisées dans l’app Raccourcis, par exemple dans une automatisation de concentration ou de Wi-Fi.
- **15 langues.** Anglais, chinois simplifié, chinois traditionnel, japonais, coréen, allemand, français, espagnol, portugais, indonésien, thaï, vietnamien, arabe, russe et hindi, à changer directement dans l’app.

## Installation

Nécessite macOS 14 Sonoma ou ultérieur.

1. Ouvrez la [page Releases](https://github.com/zhaojiannet/tokimori/releases) et, sous **Assets** de la dernière version, téléchargez `Tokimori-<version>.dmg`.
2. Double-cliquez sur le DMG téléchargé pour l’ouvrir.
3. Faites glisser **Tokimori** sur le dossier **Applications** affiché dans la même fenêtre.
4. Éjectez le DMG, puis ouvrez Tokimori depuis le dossier Applications. La première fois, macOS vous demande de l’autoriser ; voir [Premier lancement](#premier-lancement).

Il n’y a pas de programme d’installation et aucun mot de passe administrateur n’est nécessaire.

**Mise à jour :** téléchargez le nouveau DMG et faites de nouveau glisser Tokimori dans Applications pour remplacer l’ancienne copie. Vos règles sont conservées. Pour savoir si une version plus récente est disponible, cliquez sur **Rechercher des mises à jour…** dans Réglages › Général.

**Désinstallation :** quittez Tokimori depuis son menu et placez-le dans la corbeille. Pour supprimer aussi ses règles et réglages, supprimez `~/Library/Application Support/net.zhaojian.tokimori` et `~/Library/Preferences/net.zhaojian.tokimori.plist`. Si vous avez activé **Ouvrir à l’ouverture de session**, désactivez-le d’abord, ou retirez Tokimori dans Réglages Système › Général › Ouverture.

### Premier lancement

Tokimori n’est pas encore notarié par Apple, donc macOS le bloque la première fois que vous l’ouvrez. Autorisez-le une fois :

1. Double-cliquez sur Tokimori. Quand macOS indique qu’il n’a pas pu vérifier Tokimori, cliquez sur **Terminé**. Ne cliquez pas sur le bouton bleu **Placer dans la corbeille**.

   <img src="../assets/first-launch-1.png" width="341" alt="Le premier avertissement : cliquez sur Terminé">

2. Ouvrez **Réglages Système › Confidentialité et sécurité**, faites défiler jusqu’à **Sécurité** et cliquez sur **Ouvrir quand même** à côté de Tokimori. Le bouton reste disponible environ une heure après l’étape 1.

   <img src="../assets/first-launch-2.png" width="560" alt="Confidentialité et sécurité : cliquez sur Ouvrir quand même">

3. Saisissez votre mot de passe de session ou utilisez Touch ID. Dans la fenêtre qui suit, cliquez de nouveau sur **Ouvrir quand même**.

   <img src="../assets/first-launch-3.png" width="341" alt="La confirmation : cliquez sur Ouvrir quand même">

Ensuite, Tokimori s’ouvre normalement. Le DMG contient aussi ces étapes dans `First Launch.txt`.

## Utilisation

Cliquez sur le sablier dans la barre des menus. Tant que quelque chose maintient votre Mac éveillé, son sable s’écoule et le sablier se retourne toutes les 30 minutes ; quand votre Mac peut se mettre en veille normalement, il reste immobile avec tout le sable en haut.

- **Maintenir éveillé** active ou désactive le maintien en éveil. En dessous, Tokimori indique ce qui maintient votre Mac éveillé en ce moment et jusqu’à quand.
- Les boutons de durée maintiennent le Mac éveillé pendant la durée correspondante. **Jusqu’à…** vous permet de choisir une heure ; une heure déjà passée aujourd’hui désigne demain.
- **Garder l’écran allumé** s’applique au maintien en éveil que vous activez vous-même. Les horaires et les règles d’exécution ont chacun leur propre réglage. L’écran reste allumé si une source active le demande.
- La dernière ligne indique le prochain minuteur d’app.

Si vous désactivez le maintien en éveil pendant qu’un horaire est actif, Tokimori vous demande ce que vous voulez faire :

- **Arrêter jusqu’à 18:00** — reste désactivé pour le reste de cette période ; l’horaire se réactive la fois suivante.
- **Désactiver cet horaire** — l’horaire est désactivé jusqu’à ce que vous le réactiviez dans les réglages.
- **Rester éveillé** — ne change rien.

La désactivation met aussi en pause les règles d’exécution actives, jusqu’à ce que l’app ou le processus concerné quitte.

Ouvrez **Réglages…** pour gérer les règles. Chaque règle est une carte que vous modifiez directement : les changements s’appliquent immédiatement, l’interrupteur de la carte l’active ou la désactive, et le bouton corbeille la supprime.

- **Général :** ouverture à l’ouverture de session, affichage du temps restant à côté de l’icône de la barre des menus, protection de la batterie, langue, mises à jour.
- **Horaires :** **Ajouter un horaire** ajoute les jours de semaine de 09:00 à 18:00 ; modifiez le nom, les jours et les heures sur la carte.
- **Pendant l’exécution :** **Ajouter** liste les apps actuellement ouvertes ; choisissez-en une, choisissez **Autre app…**, ou choisissez **Processus en ligne de commande…** et saisissez son nom ou une partie de sa ligne de commande.
- **Minuteurs d’app :** **Ajouter un minuteur** liste les apps actuellement ouvertes. Un nouveau minuteur ouvre l’app à 09:00 les jours de semaine, ou la quitte à 18:00 si l’app a déjà un minuteur d’ouverture. Pour la fermeture, choisissez ce qui se passe si l’app n’a pas quitté au bout de 30 secondes. Un minuteur qui ouvrirait et quitterait la même app à la même minute qu’un autre ne peut pas être activé.

<p align="center">
  <img src="../assets/settings-general.png" width="380" alt="Réglages : Général">
  <img src="../assets/settings-schedules.png" width="380" alt="Réglages : Horaires">
  <img src="../assets/settings-while-running.png" width="380" alt="Réglages : Pendant l’exécution">
  <img src="../assets/settings-app-timers.png" width="380" alt="Réglages : Minuteurs d’app">
</p>

Quand vous ajoutez votre première règle, Tokimori vous demande s’il doit s’ouvrir à l’ouverture de session, car les règles ne s’exécutent que lorsqu’il est ouvert. Quitter Tokimori alors que des règles sont actives demande une confirmation une fois (vous pouvez désactiver cette question).

## Fonctionnement

- Le maintien en éveil utilise une assertion d’alimentation IOKit de type `PreventUserIdleSystemSleep`, le même mécanisme que `caffeinate -i`. **Garder l’écran allumé** ajoute `PreventUserIdleDisplaySleep`. Exécutez `pmset -g assertions` dans Terminal pour les voir. Tokimori ne bouge pas la souris et n’exécute pas `caffeinate`.
- Les assertions appartiennent au processus Tokimori, donc macOS les libère automatiquement si Tokimori quitte ou plante. Votre Mac ne peut jamais rester éveillé à cause d’une assertion oubliée.
- Tokimori recalcule quand une période commence ou se termine, quand votre Mac se réveille, quand l’heure ou le fuseau horaire change, quand des apps s’ouvrent ou quittent, et toutes les 30 secondes pour les processus et le niveau de batterie.
- Un minuteur d’app qui tombe pendant que votre Mac est en veille ou que Tokimori ne tourne pas est quand même exécuté si Tokimori s’en aperçoit dans les 10 minutes ; les plus anciens sont ignorés, pour éviter une rafale d’ouvertures et de fermetures périmées quand vous ouvrez l’écran le matin.
- L’ouverture utilise `NSWorkspace` ; la fermeture demande à l’app de quitter normalement, et la fermeture forcée utilise `NSRunningApplication.forceTerminate()`. macOS ne permet pas aux apps en sandbox de quitter d’autres apps ; Tokimori n’est donc pas en sandbox et n’est pas sur le Mac App Store.
- Les règles sont enregistrées dans `~/Library/Application Support/net.zhaojian.tokimori/configuration.json`. La seule requête réseau est la recherche de mises à jour, et uniquement quand vous cliquez dessus.

## Questions fréquentes

**Maintient-il mon MacBook éveillé écran rabattu ?**
Non. Rabattre l’écran met un MacBook en veille quelles que soient les assertions d’alimentation, sauf si un écran externe, un clavier et l’alimentation sont branchés (mode « clapet fermé »).

**Peut-il réveiller mon Mac pour exécuter un minuteur d’app ?**
Non. Réveiller un Mac en veille à une heure donnée nécessite des droits d’administrateur (`pmset schedule`). Les minuteurs s’exécutent pendant que votre Mac est éveillé, avec le délai de grâce de 10 minutes décrit plus haut.

**Pourquoi l’écran s’éteint-il quand même ?**
Par défaut, seule la suspension d’activité du système est empêchée, ce qui convient généralement aux téléchargements, aux compilations et aux sessions à distance. Activez **Garder l’écran allumé** pour les présentations ou la surveillance.

**Fonctionne-t-il avec les automatisations Raccourcis sous macOS 26 ?**
Oui. Utilisez les actions Tokimori dans une automatisation personnelle, par exemple « Quand je me connecte au Wi-Fi … Maintenir le Mac éveillé ».

## Limites connues

- **Éteindre l’écran** peut aussi verrouiller votre Mac si, dans Réglages Système › Écran de verrouillage, vous exigez un mot de passe après l’extinction de l’écran.
- La reconnaissance par ligne de commande ne voit que les processus lancés par votre compte utilisateur.
- Les minuteurs d’app fonctionnent à la minute près et nécessitent que Tokimori soit en cours d’exécution.
- Les traductions de l’interface n’ont pas encore été relues par des locuteurs natifs.

## Compiler depuis les sources

Nécessite Xcode 27.

```sh
swift test --package-path TokimoriKit
xcodebuild -project Tokimori.xcodeproj -scheme Tokimori build
```

Pour créer un DMG :

```sh
scripts/package.sh
```

Le résultat est placé dans `.build/dist/`, avec un cask Homebrew généré à partir de `packaging/tokimori.rb`, version et somme de contrôle renseignées. Sans variables d’environnement, l’app est signée ad hoc et n’est pas notariée ; le DMG inclut alors `First Launch.txt`. Définissez `DEVELOPER_ID` (le nom d’un certificat Developer ID Application) pour signer avec ce certificat, et définissez aussi `NOTARY_PROFILE` (un profil d’identifiants enregistré avec `xcrun notarytool store-credentials`) pour notarier et agrafer le ticket.

Les versions publiées sont compilées par le workflow GitHub Actions de `.github/workflows/release.yml`. La façon dont il signe, et la procédure pour publier une version, sont décrites dans [docs/release.md](../release.md).

## Structure du projet

- `TokimoriKit/` : un package Swift local. `TokimoriCore` contient la logique de planification et ses tests ; `TokimoriPlatform` encapsule les API système (assertions d’alimentation IOKit et batterie, liste des processus, `NSWorkspace`).
- `Apps/Tokimori/` : l’app de barre des menus (SwiftUI).
- `scripts/`, `packaging/` : le script de création du paquet et le modèle de cask Homebrew.

## Licence

[MIT](../../LICENSE) © 2026 zhaoJian
