<p align="center">
  <img src="../assets/icon.png" width="128" alt="Tokimori app icon">
</p>

<h1 align="center">Tokimori</h1>

<p align="center">
  <strong>Mantén el Mac activo cuando lo necesites y abre o cierra apps según un horario.</strong>
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
  <b>Español</b> ·
  <a href="README.pt.md">Português</a> ·
  <a href="README.id.md">Bahasa Indonesia</a> ·
  <a href="README.th.md">ไทย</a> ·
  <a href="README.vi.md">Tiếng Việt</a> ·
  <a href="README.ar.md">العربية</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.hi.md">हिन्दी</a>
</p>

Tokimori (時守り, «guardián del tiempo») es una app gratuita y de código abierto para la barra de menús de macOS. Evita que el Mac entre en reposo —ahora mismo, según un horario semanal o mientras se ejecuta una app o un comando concretos— y abre o cierra apps a las horas que tú elijas. No tiene icono en el Dock.

Úsala para que el Mac no entre en reposo durante descargas, compilaciones, exportaciones de vídeo, agentes de IA, sesiones remotas o presentaciones. Usa el mismo mecanismo que el comando integrado `caffeinate`, añade un menú, horarios y temporizadores de apps, y nunca mueve el ratón.

<p align="center">
  <img src="../assets/screenshot.png" width="420" alt="El menú de Tokimori">
</p>

## Contenido

- [Funciones](#funciones)
- [Instalación](#instalación)
- [Uso](#uso)
- [Cómo funciona](#cómo-funciona)
- [Preguntas frecuentes](#preguntas-frecuentes)
- [Limitaciones conocidas](#limitaciones-conocidas)
- [Compilar desde el código fuente](#compilar-desde-el-código-fuente)

## Funciones

- **Mantener activo con un clic.** Actívalo de forma indefinida, durante 30 minutos, 1, 2 o 4 horas, o hasta la hora que elijas. El sistema permanece activo mientras la pantalla puede seguir apagándose según su configuración habitual.
- **Mantener la pantalla encendida o apagarla ahora.** Si quieres, también puedes mantener la pantalla encendida. **Apagar la pantalla** oscurece la pantalla mientras el Mac sigue funcionando.
- **Horarios.** Por ejemplo, mantén el Mac activo todos los días laborables de 09:00 a 18:00. Un periodo puede terminar después de medianoche; en ese caso pertenece al día en que empieza.
- **Durante la ejecución.** Mantén el Mac activo mientras una app esté abierta o mientras se ejecute un proceso de línea de comandos, identificado por su nombre (`ffmpeg`) o por un texto de su línea de comandos (`claude`, para herramientas que se ejecutan dentro de `node` o `python`).
- **Temporizadores de apps.** Abre o cierra una app los días elegidos a una hora fija. Una misma app puede tener varios temporizadores. Si una app no se ha cerrado al cabo de 30 segundos (por ejemplo, porque te pregunta si quieres guardar), Tokimori te avisa o fuerza su cierre; lo eliges en cada temporizador.
- **Protección de la batería.** Cuando el Mac funciona con batería por debajo del nivel que elijas (20 % por omisión), Tokimori deja de mantenerlo activo. Los horarios y las reglas de ejecución se reanudan en cuanto lo conectas a la corriente.
- **Acciones de Atajos.** *Mantener el Mac activo*, *Dejar de mantener el Mac activo* e *¿Se mantiene activo el Mac?* pueden usarse en la app Atajos, por ejemplo en una automatización de Concentración o de Wi-Fi.
- **15 idiomas.** Inglés, chino simplificado, chino tradicional, japonés, coreano, alemán, francés, español, portugués, indonesio, tailandés, vietnamita, árabe, ruso e hindi, que se pueden cambiar dentro de la app.

## Instalación

Requiere macOS 14 Sonoma o posterior.

1. Abre la [página de Releases](https://github.com/zhaojiannet/tokimori/releases) y, en **Assets** de la versión más reciente, descarga `Tokimori-<version>.dmg`.
2. Haz doble clic en el DMG descargado para abrirlo.
3. Arrastra **Tokimori** a la carpeta **Aplicaciones** que aparece en la misma ventana.
4. Expulsa el DMG y abre Tokimori desde la carpeta Aplicaciones. La primera vez, macOS te pide que lo permitas; consulta [Primer inicio](#primer-inicio).

No hay instalador y no se necesita contraseña de administrador.

**Actualizar:** descarga el nuevo DMG y vuelve a arrastrar Tokimori a Aplicaciones, reemplazando la copia anterior. Tus reglas se conservan. Para saber si hay una versión más reciente, haz clic en **Buscar actualizaciones…** en Ajustes › General.

**Desinstalar:** sal de Tokimori desde su menú y trasládalo a la papelera. Para eliminar también sus reglas y ajustes, borra `~/Library/Application Support/net.zhaojian.tokimori` y `~/Library/Preferences/net.zhaojian.tokimori.plist`. Si activaste **Abrir al iniciar sesión**, desactívalo antes o elimina Tokimori en Ajustes del Sistema › General › Ítems de inicio.

### Primer inicio

Tokimori aún no está notarizado por Apple, así que macOS lo bloquea la primera vez que lo abres. Permítelo una vez:

1. Haz doble clic en Tokimori. Cuando macOS indique que no ha podido verificar Tokimori, haz clic en **Aceptar**. No hagas clic en el botón azul **Trasladar a la Papelera**.

   <img src="../assets/first-launch-1.png" width="341" alt="El primer aviso: haz clic en Aceptar">

2. Abre **Ajustes del Sistema › Privacidad y seguridad**, desplázate hasta **Seguridad** y haz clic en **Abrir igualmente** junto a Tokimori. El botón está disponible durante aproximadamente una hora después del paso 1.

   <img src="../assets/first-launch-2.png" width="560" alt="Privacidad y seguridad: haz clic en Abrir igualmente">

3. Introduce tu contraseña de inicio de sesión o usa Touch ID. En el cuadro de diálogo que aparece, vuelve a hacer clic en **Abrir igualmente**.

   <img src="../assets/first-launch-3.png" width="341" alt="La confirmación: haz clic en Abrir igualmente">

A partir de entonces, Tokimori se abre con normalidad. El DMG también incluye estos pasos en `First Launch.txt`.

## Uso

Haz clic en el reloj de arena de la barra de menús. Mientras algo mantiene el Mac activo, la arena cae y el reloj se da la vuelta cada 30 minutos; cuando el Mac puede entrar en reposo con normalidad, se queda quieto con toda la arena arriba.

- **Mantener activo** activa o desactiva el modo activo. Debajo, Tokimori muestra qué mantiene el Mac activo en este momento y hasta cuándo.
- Los botones de duración mantienen el Mac activo durante ese tiempo. **Hasta…** te permite elegir una hora; una hora que ya ha pasado hoy significa mañana.
- **Mantener la pantalla encendida** se aplica al modo activo que enciendes tú. Los horarios y las reglas de ejecución tienen cada uno su propio ajuste. La pantalla permanece encendida si cualquier fuente activa lo pide.
- La última línea muestra el próximo temporizador de app.

Si desactivas el modo activo mientras un horario está en curso, Tokimori te pregunta qué quieres hacer:

- **Detener hasta 18:00**: permanece desactivado el resto de este periodo; el horario vuelve a activarse la próxima vez.
- **Desactivar este horario**: el horario queda desactivado hasta que vuelvas a activarlo en los ajustes.
- **Seguir activo**: no cambia nada.

Desactivarlo también pausa las reglas de ejecución activas, hasta que esa app o ese proceso se cierre.

Abre **Ajustes…** para gestionar las reglas. Cada regla es una tarjeta que se edita directamente: los cambios se aplican al instante, el interruptor de la tarjeta la activa o desactiva y el botón de la papelera la elimina.

- **General:** abrir al iniciar sesión, mostrar el tiempo restante junto al icono de la barra de menús, protección de la batería, idioma, actualizaciones.
- **Horarios:** **Añadir horario** añade los días laborables de 09:00 a 18:00; cambia el nombre, los días y las horas en la tarjeta.
- **Durante la ejecución:** **Añadir** muestra las apps abiertas en este momento; elige una, elige **Otra app…** o elige **Proceso de línea de comandos…** y escribe su nombre o parte de su línea de comandos.
- **Temporizadores de apps:** **Añadir temporizador** muestra las apps abiertas en este momento. Un temporizador nuevo abre la app a las 09:00 los días laborables, o la cierra a las 18:00 si la app ya tiene un temporizador de apertura. Para cerrar, elige qué ocurre si la app no se ha cerrado al cabo de 30 segundos. No se puede activar un temporizador que abriría y cerraría la misma app en el mismo minuto que otro.

<p align="center">
  <img src="../assets/settings-general.png" width="380" alt="Ajustes: General">
  <img src="../assets/settings-schedules.png" width="380" alt="Ajustes: Horarios">
  <img src="../assets/settings-while-running.png" width="380" alt="Ajustes: Durante la ejecución">
  <img src="../assets/settings-app-timers.png" width="380" alt="Ajustes: Temporizadores de apps">
</p>

Cuando añades tu primera regla, Tokimori pregunta si debe abrirse al iniciar sesión, porque las reglas solo se ejecutan mientras está abierto. Salir de Tokimori con reglas activas pide confirmación una vez (puedes desactivar esa pregunta).

## Cómo funciona

- El modo activo usa una aserción de energía de IOKit de tipo `PreventUserIdleSystemSleep`, el mismo mecanismo que `caffeinate -i`. **Mantener la pantalla encendida** añade `PreventUserIdleDisplaySleep`. Ejecuta `pmset -g assertions` en Terminal para verlas. Tokimori no mueve el ratón ni ejecuta `caffeinate`.
- Las aserciones pertenecen al proceso de Tokimori, así que macOS las libera automáticamente si Tokimori se cierra o falla. El Mac nunca puede quedarse activo por una aserción olvidada.
- Tokimori vuelve a calcular cuando empieza o termina un periodo, cuando el Mac sale del reposo, cuando cambia la hora o la zona horaria, cuando se abren o cierran apps, y cada 30 segundos para los procesos y el nivel de batería.
- Un temporizador de app que coincide con un momento en que el Mac está en reposo o Tokimori no se está ejecutando se lleva a cabo igualmente si Tokimori lo detecta en un plazo de 10 minutos; los más antiguos se omiten, para que no recibas una ráfaga de aperturas y cierres desfasados al abrir la tapa por la mañana.
- Para abrir se usa `NSWorkspace`; para cerrar se pide a la app que salga con normalidad, y el cierre forzado usa `NSRunningApplication.forceTerminate()`. macOS no permite que las apps en sandbox cierren otras apps, por lo que Tokimori no usa sandbox y no está en la Mac App Store.
- Las reglas se guardan en `~/Library/Application Support/net.zhaojian.tokimori/configuration.json`. La única petición de red es la búsqueda de actualizaciones, y solo cuando haces clic en ella.

## Preguntas frecuentes

**¿Mantiene activo mi MacBook con la tapa cerrada?**
No. Cerrar la tapa pone un MacBook en reposo independientemente de las aserciones de energía, salvo que haya conectados una pantalla externa, un teclado y la corriente (modo tapa cerrada).

**¿Puede activar mi Mac para ejecutar un temporizador de app?**
No. Activar un Mac en reposo a una hora fija requiere permisos de administrador (`pmset schedule`). Los temporizadores se ejecutan mientras el Mac está activo, con el margen de 10 minutos descrito arriba.

**¿Por qué se sigue apagando la pantalla?**
Por omisión solo se impide el reposo del sistema, que suele ser lo que quieres para descargas, compilaciones y sesiones remotas. Activa **Mantener la pantalla encendida** para presentaciones o tareas de supervisión.

**¿Funciona con las automatizaciones de Atajos en macOS 26?**
Sí. Usa las acciones de Tokimori en una automatización personal, como «Cuando me conecte a una red Wi-Fi … Mantener el Mac activo».

## Limitaciones conocidas

- **Apagar la pantalla** también puede bloquear el Mac si en Ajustes del Sistema › Pantalla bloqueada has configurado que se pida la contraseña al apagarse la pantalla.
- La identificación por línea de comandos solo ve los procesos iniciados por tu cuenta de usuario.
- Los temporizadores de apps tienen precisión de minutos y dependen de que Tokimori esté en ejecución.
- Las traducciones de la interfaz aún no han sido revisadas por hablantes nativos.

## Compilar desde el código fuente

Requiere Xcode 27.

```sh
swift test --package-path TokimoriKit
xcodebuild -project Tokimori.xcodeproj -scheme Tokimori build
```

Para crear un DMG:

```sh
scripts/package.sh
```

El resultado se genera en `.build/dist/`, junto con un cask de Homebrew generado a partir de `packaging/tokimori.rb` con la versión y la suma de comprobación ya rellenadas. Sin variables de entorno, la app se firma ad hoc y no se notariza; en ese caso el DMG incluye `First Launch.txt`. Define `DEVELOPER_ID` (el nombre de un certificado Developer ID Application) para firmar con él, y define también `NOTARY_PROFILE` (un perfil de credenciales guardado con `xcrun notarytool store-credentials`) para notarizar y grapar el ticket.

Las versiones publicadas se compilan con el flujo de trabajo de GitHub Actions de `.github/workflows/release.yml`. Cómo firma y cómo publicar una versión se explica en [docs/release.md](../release.md).

## Estructura del proyecto

- `TokimoriKit/`: un paquete Swift local. `TokimoriCore` contiene la lógica de programación y sus pruebas; `TokimoriPlatform` envuelve las API del sistema (aserciones de energía y batería de IOKit, lista de procesos, `NSWorkspace`).
- `Apps/Tokimori/`: la app de la barra de menús (SwiftUI).
- `scripts/`, `packaging/`: el script de empaquetado y la plantilla del cask de Homebrew.

## Licencia

[MIT](../../LICENSE) © 2026 zhaoJian
