

# 🚀 Gembok Simple Installer

Installer otomatis untuk deploy **Gembok Simple** di VPS / server Linux (Ubuntu/Debian) secara cepat dan praktis hanya dengan satu perintah.

Installer ini akan membantu:

* Setup environment server
* Install dependency yang dibutuhkan
* Konfigurasi web server (NGINX / Apache sesuai script)
* Deploy aplikasi Gembok Simple siap pakai

---

## 📦 Repository

* Repo: [https://github.com/heruhendri/installer-gembok-simple](https://github.com/heruhendri/installer-gembok-simple)
* Installer script:
  [https://raw.githubusercontent.com/heruhendri/installer-gembok-simple/refs/heads/main/installer.sh](https://raw.githubusercontent.com/heruhendri/installer-gembok-simple/refs/heads/main/installer.sh)

---

## ⚙️ Persyaratan Sistem

Pastikan server memenuhi syarat berikut:

* OS: Ubuntu 20.04 / 22.04 / Debian
* Akses: root / sudo
* RAM minimal: 1GB (disarankan 2GB)
* Domain (opsional, tapi direkomendasikan)
* Port 80 & 443 terbuka

---

## 🔧 Cara Install (1 Command)

Jalankan perintah berikut di VPS:

```bash
curl -s https://raw.githubusercontent.com/heruhendri/installer-gembok-simple/refs/heads/multi/installer.sh | bash
```

Atau menggunakan wget:

```bash
wget https://raw.githubusercontent.com/heruhendri/installer-gembok-simple/refs/heads/multi/installer.sh
chmod +x installer.sh
./installer.sh
```

Metode ini umum digunakan untuk menjalankan installer langsung dari internet menggunakan `curl` dan pipe ke `bash` ([LoRaWAN Portal][1])

---

## 🧭 Alur Instalasi

Installer akan menjalankan beberapa tahap otomatis:

1. Update & upgrade sistem
2. Install package penting (nginx, php, dll)
3. Setup folder aplikasi
4. Download source Gembok Simple
5. Konfigurasi web server
6. Setup permission
7. (Opsional) SSL Let's Encrypt

---

## 🌐 Akses Aplikasi

Setelah instalasi selesai:

* Akses via browser:

```
http://domain-anda
```

atau

```
http://IP-VPS
```

---

## 🔒 SSL (HTTPS)

Jika installer mendukung SSL otomatis:

* Akan menggunakan Let's Encrypt
* Domain wajib sudah mengarah ke IP VPS

Jika gagal:

* Pastikan DNS sudah propagate
* Port 80 tidak diblokir Cloudflare (disable proxy sementara)

---

## 🛠️ Perintah Tambahan

### Restart Nginx

```bash
systemctl restart nginx
```

### Cek Status Nginx

```bash
systemctl status nginx
```

### Cek Error Log

```bash
tail -f /var/log/nginx/error.log
```

---

## ⚠️ Troubleshooting

### ❌ 502 Bad Gateway

* Cek PHP-FPM:

```bash
systemctl status php*-fpm
```

---

### ❌ SSL gagal

* Pastikan domain resolve ke VPS
* Disable Cloudflare proxy (gunakan DNS only)

---

### ❌ Permission error

```bash
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
```

---

## 🔄 Update Script

Jika ada update installer:

```bash
curl -s https://raw.githubusercontent.com/heruhendri/installer-gembok-simple/refs/heads/main/installer.sh | bash
```

---

## 📁 Struktur Umum (Contoh)

```
/var/www/html/
├── index.php
├── config/
├── assets/
└── logs/
```

---

## 📌 Catatan

* Installer ini bersifat **auto setup**, jadi sebaiknya digunakan di VPS fresh
* Jangan jalankan di server production tanpa backup
* Pastikan port penting tidak bentrok

---

## 👨‍💻 Author

* GitHub: [https://github.com/heruhendri](https://github.com/heruhendri)

---

# 🔗 Link Instalasi (Ringkas)

### 1. Install cepat (recommended)

```bash
curl -s https://raw.githubusercontent.com/heruhendri/installer-gembok-simple/refs/heads/main/installer.sh | bash
```

### 2. Download manual

```bash
wget https://raw.githubusercontent.com/heruhendri/installer-gembok-simple/refs/heads/main/installer.sh
chmod +x installer.sh
./installer.sh
```

---
