🚀 Gembok Simple Installer 🚀
Selamat datang di repositori Gembok Simple Installer!
Repositori ini berisi skrip installer yang dirancang untuk memudahkan Anda dalam menyiapkan lingkungan Gembok Simple di server Ubuntu Anda. Dengan skrip ini, Anda dapat mengotomatiskan instalasi Nginx, PHP, MySQL, dan dependensi lainnya yang diperlukan, serta melakukan konfigurasi dasar untuk menjalankan Gembok Simple.
✨ Fitur Utama
Instalasi Otomatis: Menginstal Nginx, PHP (dengan ekstensi yang diperlukan), dan MySQL Server.
Konfigurasi Nginx: Membuat file konfigurasi virtual host Nginx untuk Gembok Simple.
Pengaturan Direktori: Membuat dan mengatur izin yang benar untuk direktori aplikasi Gembok Simple.
Unduh Otomatis: Mengunduh file Gembok Simple dari repositori resminya.
Panduan Konfigurasi: Memberikan panduan langkah demi langkah untuk konfigurasi database dan penyelesaian instalasi melalui web.
🛠️ Teknologi yang Digunakan
Shell Scripting: Untuk otSomatisasi proses instalasi dan konfigurasi.
Nginx: Sebagai web server.
PHP: Bahasa pemrograman backend.
MySQL: Sebagai sistem manajemen database.
📚 Cara Menggunakan
Persiapan Server:
Pastikan Anda memiliki server Ubuntu yang terhubung ke internet.
Akses server Anda melalui SSH.
Unduh Skrip Installer:
Salin skrip installer (yang dapat Anda temukan di repositori Gembok Simple atau skrip yang saya buat sebelumnya) ke server Anda. Misalnya, simpan sebagai install_gembok.sh.
Contoh: wget https://raw.githubusercontent.com/heruhendri/installer-gembok-simple/main/install_gembok.sh (jika file tersebut ada di repo utama) atau gunakan skrip yang telah disesuaikan.
Berikan Izin Eksekusi:
bash
chmod +x install_gembok.sh
Edit Konfigurasi (Penting!):
Buka file install_gembok.sh dengan editor teks (misalnya nano install_gembok.sh).
Ubah variabel-variabel konfigurasi di bagian atas skrip, seperti:
DOMAIN_NAME: Nama domain atau IP server Anda.
WEB_ROOT: Direktori tempat Gembok Simple akan diinstal.
Detail database (nama, user, password).
Detail akun admin, portal, dan sales.
Jalankan Skrip Installer:
bash
sudo ./install_gembok.sh
Ikuti Instruksi Manual:
Setelah skrip selesai, Anda akan diminta untuk melakukan beberapa langkah konfigurasi manual, terutama terkait MySQL (membuat database dan user).
Edit file includes/config.php (di direktori WEB_ROOT Anda) dengan detail database yang benar.
Akses http://your-domain.com/install.php di browser Anda untuk menyelesaikan proses instalasi.
Penting: Hapus file install.php setelah instalasi berhasil demi keamanan.
🤝 Kontributor
heruhendri - Pengembang Awal
📄 Lisensi
Proyek ini dilisensikan di bawah Lisensi MIT - lihat file LICENSE untuk detailnya.