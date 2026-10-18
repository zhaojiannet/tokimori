<p align="center">
  <img src="../assets/icon.png" width="128" alt="Tokimori app icon">
</p>

<h1 align="center">Tokimori</h1>

<p align="center">
  <strong>Buat Mac tetap terjaga saat Anda membutuhkannya, serta buka atau tutup app sesuai jadwal.</strong>
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
  <b>Bahasa Indonesia</b> ·
  <a href="README.th.md">ไทย</a> ·
  <a href="README.vi.md">Tiếng Việt</a> ·
  <a href="README.ar.md">العربية</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.hi.md">हिन्दी</a>
</p>

Tokimori (時守り, "penjaga waktu") adalah app bar menu gratis dan sumber terbuka untuk macOS. App ini mencegah Mac Anda tidur — saat ini juga, sesuai jadwal mingguan, atau selama app atau perintah tertentu berjalan — dan membuka atau menutup app pada waktu yang Anda tetapkan. App ini tidak memiliki ikon Dock.

Gunakan untuk mencegah Mac tidur saat mengunduh, build, ekspor video, menjalankan agen AI, sesi jarak jauh, atau presentasi. Cara kerjanya sama dengan perintah bawaan `caffeinate`, ditambah menu, jadwal, dan pengatur waktu app, dan tidak pernah menggerakkan mouse.

<p align="center">
  <img src="../assets/screenshot.png" width="420" alt="Menu Tokimori">
</p>

## Daftar isi

- [Fitur](#fitur)
- [Instalasi](#instalasi)
- [Penggunaan](#penggunaan)
- [Cara kerja](#cara-kerja)
- [Tanya jawab](#tanya-jawab)
- [Keterbatasan yang diketahui](#keterbatasan-yang-diketahui)
- [Membangun dari kode sumber](#membangun-dari-kode-sumber)

## Fitur

- **Tetap terjaga dengan sekali klik.** Nyalakan tanpa batas waktu, selama 30 menit, 1, 2, atau 4 jam, atau hingga waktu yang Anda pilih. Sistem tetap terjaga, sementara layar tetap bisa mati sesuai jadwal biasanya.
- **Biarkan layar menyala, atau matikan sekarang.** Jika mau, layar juga bisa dibiarkan menyala. **Matikan Layar** menggelapkan layar sementara Mac tetap berjalan.
- **Jadwal.** Misalnya, buat Mac tetap terjaga setiap hari kerja dari pukul 09:00 hingga 18:00. Sebuah periode boleh berakhir lewat tengah malam; periode itu tetap termasuk hari ketika ia dimulai.
- **Saat berjalan.** Buat Mac tetap terjaga selama sebuah app terbuka, atau selama proses baris perintah berjalan — dicocokkan berdasarkan namanya (`ffmpeg`) atau teks di baris perintahnya (`claude`, untuk alat yang berjalan di dalam `node` atau `python`).
- **Pengatur waktu app.** Buka atau tutup app pada hari yang dipilih dan waktu yang ditetapkan. Satu app bisa memiliki beberapa pengatur waktu. Jika app belum keluar setelah 30 detik (misalnya karena sedang meminta Anda menyimpan), Tokimori akan memberi tahu Anda atau memaksanya keluar — Anda yang memilih untuk tiap pengatur waktu.
- **Perlindungan baterai.** Saat Mac berjalan dengan baterai di bawah level yang Anda pilih (20% secara default), Tokimori berhenti membuatnya tetap terjaga. Jadwal dan aturan app yang berjalan kembali aktif begitu Anda mencolokkan daya.
- **Tindakan Pintasan.** *Buat Mac Tetap Terjaga*, *Berhenti Membuat Mac Tetap Terjaga*, dan *Apakah Mac Sedang Tetap Terjaga* dapat digunakan di app Pintasan, misalnya dalam automasi Fokus atau Wi-Fi.
- **15 bahasa.** Inggris, Tionghoa Sederhana, Tionghoa Tradisional, Jepang, Korea, Jerman, Prancis, Spanyol, Portugis, Indonesia, Thai, Vietnam, Arab, Rusia, dan Hindi, yang bisa diganti di dalam app.

## Instalasi

Memerlukan macOS 14 Sonoma atau lebih baru.

1. Buka [halaman Releases](https://github.com/zhaojiannet/tokimori/releases), lalu di bagian **Assets** dari rilis terbaru, unduh `Tokimori-<version>.dmg`.
2. Klik dua kali DMG yang diunduh untuk membukanya.
3. Seret **Tokimori** ke folder **Aplikasi** yang ditampilkan di jendela yang sama.
4. Keluarkan DMG, lalu buka Tokimori dari folder Aplikasi. Pertama kali, macOS meminta Anda mengizinkannya; lihat [Peluncuran pertama](#peluncuran-pertama).

Tidak ada penginstal dan tidak perlu kata sandi administrator.

**Memperbarui:** unduh DMG yang baru dan seret Tokimori ke Aplikasi lagi untuk menggantikan salinan lama. Aturan Anda tetap tersimpan. Untuk melihat apakah ada versi yang lebih baru, klik **Periksa Pembaruan…** di Pengaturan › Umum.

**Menghapus instalan:** keluar dari Tokimori melalui menunya dan pindahkan ke Tong Sampah. Untuk juga menghapus aturan dan pengaturannya, hapus `~/Library/Application Support/net.zhaojian.tokimori` dan `~/Library/Preferences/net.zhaojian.tokimori.plist`. Jika Anda menyalakan **Buka saat masuk**, matikan terlebih dahulu, atau hapus Tokimori di Pengaturan Sistem › Umum › Item Masuk.

### Peluncuran pertama

Tokimori belum dinotarisasi oleh Apple, sehingga macOS memblokirnya saat pertama kali Anda membukanya. Izinkan sekali:

1. Klik dua kali Tokimori. Saat macOS menyatakan tidak dapat memverifikasi Tokimori, klik **Selesai**. Jangan klik tombol biru **Pindahkan ke Tong Sampah**.

   <img src="../assets/first-launch-1.png" width="341" alt="Peringatan pertama: klik Selesai">

2. Buka **Pengaturan Sistem › Privasi & Keamanan**, gulir ke bawah ke **Keamanan**, lalu klik **Tetap Buka** di samping Tokimori. Tombol ini tersedia sekitar satu jam setelah langkah 1.

   <img src="../assets/first-launch-2.png" width="560" alt="Privasi & Keamanan: klik Tetap Buka">

3. Masukkan kata sandi login Anda atau gunakan Touch ID. Pada dialog berikutnya, klik **Tetap Buka** lagi.

   <img src="../assets/first-launch-3.png" width="341" alt="Konfirmasi: klik Tetap Buka">

Setelah ini, Tokimori terbuka seperti biasa. DMG juga memuat langkah-langkah ini di `First Launch.txt`.

## Penggunaan

Klik jam pasir di bar menu. Selama ada yang membuat Mac tetap terjaga, pasirnya mengalir turun dan jam pasir berbalik setiap 30 menit; saat Mac bisa tidur seperti biasa, jam pasir diam dengan semua pasir berada di atas.

- **Tetap Terjaga** menyalakan atau mematikan mode tetap terjaga. Di bawahnya, Tokimori menampilkan apa yang membuat Mac tetap terjaga saat ini dan sampai kapan.
- Tombol durasi membuat Mac tetap terjaga selama waktu tersebut. **Hingga…** memungkinkan Anda memilih waktu; waktu yang sudah lewat hari ini berarti besok.
- **Biarkan layar menyala** berlaku untuk mode tetap terjaga yang Anda nyalakan sendiri. Jadwal dan aturan app yang berjalan masing-masing memiliki pengaturan sendiri. Layar tetap menyala jika ada sumber aktif yang memintanya.
- Baris terakhir menampilkan pengatur waktu app berikutnya.

Jika Anda mematikan mode tetap terjaga saat sebuah jadwal sedang aktif, Tokimori menanyakan maksud Anda:

- **Hentikan Hingga 18:00** — tetap mati selama sisa periode ini; jadwal akan menyala lagi pada kesempatan berikutnya.
- **Matikan Jadwal Ini** — jadwal dimatikan sampai Anda menyalakannya lagi di Pengaturan.
- **Tetap Terjaga** — tidak mengubah apa pun.

Mematikannya juga menjeda aturan app yang berjalan yang sedang aktif, sampai app atau proses tersebut keluar.

Buka **Pengaturan…** untuk mengelola aturan. Setiap aturan berupa kartu yang diedit langsung di tempat: perubahan langsung berlaku, sakelar di kartu menyalakan atau mematikannya, dan tombol tong sampah menghapusnya.

- **Umum:** buka saat masuk, tampilkan sisa waktu di samping ikon bar menu, perlindungan baterai, bahasa, pembaruan.
- **Jadwal:** **Tambah Jadwal** menambahkan hari kerja 09:00–18:00; ubah nama, hari, dan waktunya di kartu.
- **Saat Berjalan:** **Tambah** menampilkan daftar app yang sedang terbuka; pilih salah satunya, pilih **App Lain…**, atau pilih **Proses Baris Perintah…** lalu ketik namanya atau sebagian baris perintahnya.
- **Pengatur Waktu App:** **Tambah Pengatur Waktu** menampilkan daftar app yang sedang terbuka. Pengatur waktu baru membuka app pada pukul 09:00 di hari kerja, atau menutupnya pada pukul 18:00 jika app itu sudah memiliki pengatur waktu pembuka. Untuk menutup, pilih apa yang terjadi jika app belum keluar setelah 30 detik. Pengatur waktu yang akan membuka dan menutup app yang sama pada menit yang sama dengan pengatur waktu lain tidak dapat dinyalakan.

<p align="center">
  <img src="../assets/settings-general.png" width="380" alt="Pengaturan: Umum">
  <img src="../assets/settings-schedules.png" width="380" alt="Pengaturan: Jadwal">
  <img src="../assets/settings-while-running.png" width="380" alt="Pengaturan: Saat Berjalan">
  <img src="../assets/settings-app-timers.png" width="380" alt="Pengaturan: Pengatur Waktu App">
</p>

Saat Anda menambahkan aturan pertama, Tokimori menanyakan apakah ia perlu dibuka saat masuk, karena aturan hanya berjalan selama Tokimori terbuka. Keluar dari Tokimori saat ada aturan yang aktif akan meminta konfirmasi sekali (pertanyaan ini bisa dimatikan).

## Cara kerja

- Mode tetap terjaga menggunakan power assertion IOKit bertipe `PreventUserIdleSystemSleep`, mekanisme yang sama dengan `caffeinate -i`. **Biarkan layar menyala** menambahkan `PreventUserIdleDisplaySleep`. Jalankan `pmset -g assertions` di Terminal untuk melihatnya. Tokimori tidak menggerakkan mouse dan tidak menjalankan `caffeinate`.
- Assertion dimiliki oleh proses Tokimori, sehingga macOS melepaskannya secara otomatis jika Tokimori keluar atau mogok. Mac tidak akan pernah tetap terjaga karena assertion yang tertinggal.
- Tokimori menghitung ulang saat periode dimulai atau berakhir, saat Mac bangun, saat waktu atau zona waktu berubah, saat app dibuka atau ditutup, dan setiap 30 detik untuk proses dan level baterai.
- Pengatur waktu app yang jatuh saat Mac sedang tidur atau Tokimori tidak berjalan tetap dijalankan jika Tokimori mengetahuinya dalam 10 menit; yang lebih lama dilewati, sehingga Anda tidak mendapatkan rentetan pembukaan dan penutupan yang sudah usang saat membuka penutup di pagi hari.
- Membuka app menggunakan `NSWorkspace`; menutup app memintanya keluar secara normal, dan paksa keluar menggunakan `NSRunningApplication.forceTerminate()`. macOS tidak mengizinkan app dalam sandbox menutup app lain, sehingga Tokimori tidak menggunakan sandbox dan tidak ada di Mac App Store.
- Aturan disimpan di `~/Library/Application Support/net.zhaojian.tokimori/configuration.json`. Satu-satunya permintaan jaringan adalah pemeriksaan pembaruan, dan itu pun hanya saat Anda mengekliknya.

## Tanya jawab

**Apakah app ini membuat MacBook tetap terjaga saat penutupnya ditutup?**
Tidak. Menutup penutup membuat MacBook tidur apa pun power assertion yang ada, kecuali jika layar eksternal, papan ketik, dan daya tersambung (mode clamshell).

**Bisakah app ini membangunkan Mac untuk menjalankan pengatur waktu app?**
Tidak. Membangunkan Mac yang sedang tidur pada waktu tertentu memerlukan hak administrator (`pmset schedule`). Pengatur waktu berjalan saat Mac terjaga, dengan masa tenggang 10 menit seperti dijelaskan di atas.

**Mengapa layar tetap mati?**
Secara default hanya tidur sistem yang dicegah, dan biasanya itulah yang Anda perlukan untuk unduhan, build, dan sesi jarak jauh. Nyalakan **Biarkan layar menyala** untuk presentasi atau pemantauan.

**Apakah app ini bisa digunakan dengan automasi Pintasan di macOS 26?**
Ya. Gunakan tindakan Tokimori dalam automasi pribadi, misalnya "Saat saya tersambung ke Wi-Fi … Buat Mac Tetap Terjaga".

## Keterbatasan yang diketahui

- **Matikan Layar** juga dapat mengunci Mac jika di Pengaturan Sistem › Layar Terkunci Anda mewajibkan kata sandi setelah layar mati.
- Pencocokan berdasarkan baris perintah hanya melihat proses yang dimulai oleh akun pengguna Anda.
- Pengatur waktu app bekerja dengan ketelitian menit dan bergantung pada Tokimori yang sedang berjalan.
- Terjemahan antarmuka belum ditinjau oleh penutur asli.

## Membangun dari kode sumber

Memerlukan Xcode 27.

```sh
swift test --package-path TokimoriKit
xcodebuild -project Tokimori.xcodeproj -scheme Tokimori build
```

Untuk membangun DMG:

```sh
scripts/package.sh
```

Hasilnya ada di `.build/dist/`, bersama Homebrew cask yang dibuat dari `packaging/tokimori.rb` dengan versi dan checksum yang sudah diisi. Tanpa variabel lingkungan, app ditandatangani secara ad hoc dan tidak dinotarisasi; DMG kemudian menyertakan `First Launch.txt`. Atur `DEVELOPER_ID` (nama sertifikat Developer ID Application) untuk menandatangani dengannya, dan atur juga `NOTARY_PROFILE` (profil kredensial yang disimpan dengan `xcrun notarytool store-credentials`) untuk melakukan notarisasi dan staple.

Rilis dibangun oleh alur kerja GitHub Actions di `.github/workflows/release.yml`. Cara penandatanganannya, dan cara menerbitkan rilis, dijelaskan di [docs/release.md](../release.md).

## Struktur proyek

- `TokimoriKit/`: paket Swift lokal. `TokimoriCore` berisi logika penjadwalan beserta pengujiannya; `TokimoriPlatform` membungkus API sistem (power assertion dan baterai IOKit, daftar proses, `NSWorkspace`).
- `Apps/Tokimori/`: app bar menu (SwiftUI).
- `scripts/`, `packaging/`: skrip pengemasan dan templat Homebrew cask.

## Lisensi

[MIT](../../LICENSE) © 2026 zhaoJian
