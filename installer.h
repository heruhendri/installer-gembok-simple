#!/bin/bash

# --- Konfigurasi ---
# Ganti dengan domain atau IP server Anda
DOMAIN_NAME="your_domain.com"
# Ganti dengan direktori root web Anda (misalnya /var/www/gembok)
WEB_ROOT="/var/www/gembok"
# Ganti dengan nama database, user, dan password yang Anda inginkan
DB_NAME="gembok_db"
DB_USER="gembok_user"
DB_PASS="your_strong_password"
# Ganti dengan username dan password admin Gembok yang Anda inginkan
ADMIN_USER="admin"
ADMIN_PASS="your_admin_password"
# Ganti dengan username dan password portal pelanggan yang Anda inginkan
PORTAL_USER="user"
PORTAL_PASS="your_portal_password"
# Ganti dengan username dan password portal sales yang Anda inginkan
SALES_USER="sales"
SALES_PASS="your_sales_password"

# --- Update Sistem ---
echo "Memperbarui daftar paket..."
sudo apt update
sudo apt upgrade -y

# --- Instal Nginx ---
echo "Menginstal Nginx..."
sudo apt install nginx -y

# --- Instal PHP dan Ekstensinya ---
echo "Menginstal PHP dan ekstensi yang diperlukan..."
sudo apt install php-fpm php-mysql php-mbstring php-xml php-curl php-zip -y

# --- Instal MySQL Server ---
echo "Menginstal MySQL Server..."
sudo apt install mysql-server -y

# Konfigurasi MySQL (memerlukan interaksi manual atau skrip terpisah untuk otomatisasi penuh)
echo "Silakan konfigurasikan MySQL secara manual atau gunakan skrip konfigurasi MySQL terpisah."
echo "Setelah MySQL terinstal, jalankan: sudo mysql_secure_installation"

# --- Buat Direktori Aplikasi ---
echo "Membuat direktori aplikasi di $WEB_ROOT..."
sudo mkdir -p $WEB_ROOT
sudo chown -R www-data:www-data $WEB_ROOT
sudo chmod -R 755 $WEB_ROOT

# --- Unduh Gembok Simple ---
echo "Mengunduh Gembok Simple dari GitHub..."
cd /tmp
git clone https://github.com/heruhendri/gembok-simple.git gembok-simple-repo
sudo mv gembok-simple-repo/* $WEB_ROOT/
sudo rm -rf gembok-simple-repo
cd $WEB_ROOT

# --- Konfigurasi Database ---
echo "Membuat database dan user MySQL..."
# Skrip ini tidak akan mengotomatiskan konfigurasi MySQL karena memerlukan password root.
# Anda perlu menjalankan perintah berikut secara manual setelah MySQL terinstal:
#
# sudo mysql -u root -p
# CREATE DATABASE $DB_NAME;
# CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
# GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
# FLUSH PRIVILEGES;
# EXIT;
#
# Kemudian, edit file includes/config.php dan perbarui DB_HOST, DB_NAME, DB_USER, DB_PASS.

echo "Silakan buat database dan user MySQL secara manual."
echo "Setelah itu, edit file: $WEB_ROOT/includes/config.php"
echo "Perbarui nilai DB_NAME, DB_USER, dan DB_PASS sesuai dengan yang Anda buat."

# --- Konfigurasi Nginx ---
echo "Membuat konfigurasi Nginx untuk Gembok Simple..."
sudo tee /etc/nginx/sites-available/gembok <<EOF
server {
    listen 80;
    server_name $DOMAIN_NAME;

    root $WEB_ROOT;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock; # Sesuaikan versi PHP jika perlu
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }

    # Izinkan akses ke direktori assets, uploads, dll.
    location ~ ^/(assets|uploads|images|css|js|fonts)/ {
        try_files \$uri =404;
    }

    # Lokasi untuk file install.php (jika masih ada setelah instalasi)
    location /install.php {
        try_files \$uri =404;
    }
}
EOF

echo "Menghapus konfigurasi default Nginx..."
sudo rm /etc/nginx/sites-enabled/default

echo "Membuat symbolic link untuk konfigurasi Gembok..."
sudo ln -s /etc/nginx/sites-available/gembok /etc/nginx/sites-enabled/

echo "Menguji konfigurasi Nginx..."
sudo nginx -t

echo "Memuat ulang Nginx..."
sudo systemctl reload nginx

# --- Konfigurasi PHP-FPM ---
# Pastikan PHP-FPM mendengarkan pada socket yang benar di konfigurasi Nginx
# Jika Anda menggunakan versi PHP yang berbeda, sesuaikan baris 'fastcgi_pass' di atas.
echo "Memastikan PHP-FPM berjalan..."
sudo systemctl enable php7.4-fpm # Sesuaikan versi PHP jika perlu
sudo systemctl start php7.4-fpm # Sesuaikan versi PHP jika perlu

# --- Instalasi Web Installer (jika ada) ---
# Skrip ini mengasumsikan Anda akan menjalankan install.php secara manual
# atau Anda perlu mengotomatiskan langkah-langkah di install.php.
echo "Skrip installer selesai."
echo "Langkah selanjutnya:"
echo "1. Konfigurasikan database MySQL secara manual jika belum dilakukan."
echo "2. Edit file: $WEB_ROOT/includes/config.php dan perbarui pengaturan database."
echo "3. Akses http://$DOMAIN_NAME/install.php di browser Anda untuk menyelesaikan instalasi."
echo "4. Setelah instalasi selesai, hapus file install.php dari server Anda."
echo "5. Atur hak akses yang sesuai untuk direktori uploads, logs, dll."

# --- Pengaturan Hak Akses Tambahan (Contoh) ---
echo "Mengatur hak akses untuk direktori penting..."
sudo chown -R www-data:www-data $WEB_ROOT/uploads
sudo chown -R www-data:www-data $WEB_ROOT/logs
sudo chown -R www-data:www-data $WEB_ROOT/backups
sudo chmod -R 755 $WEB_ROOT/uploads
sudo chmod -R 755 $WEB_ROOT/logs
sudo chmod -R 755 $WEB_ROOT/backups

echo "Skrip installer Gembok Simple selesai dijalankan."
echo "Silakan lanjutkan dengan langkah-langkah manual yang disebutkan di atas."