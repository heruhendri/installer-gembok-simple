#!/bin/bash

clear
echo "🚀 INSTALLER GEMBOK-SIMPLE (FINAL FIX VERSION)"

# =============================
# INPUT
# =============================
read -p "Masukkan domain (contoh: gembok.domain.com): " DOMAIN
read -p "Masukkan email SSL: " EMAIL

WEBROOT="/var/www/gembok-simple"

# =============================
# UPDATE
# =============================
echo "🔄 Update system..."
apt update -y && apt upgrade -y

# =============================
# INSTALL PACKAGE
# =============================
echo "📦 Install dependency..."
apt install -y nginx mysql-server git curl unzip software-properties-common

apt install -y php php-fpm php-mysql php-cli php-curl php-xml php-mbstring \
php-gd php-intl php-zip php-bcmath

# =============================
# INSTALL SSL
# =============================
apt install -y certbot python3-certbot-nginx

# =============================
# SERVICE START
# =============================
systemctl enable nginx
systemctl restart nginx

systemctl enable mysql
systemctl restart mysql

systemctl enable php*-fpm
systemctl restart php*-fpm

# =============================
# CLONE PROJECT
# =============================
echo "📥 Clone repo..."
rm -rf $WEBROOT
git clone https://github.com/heruhendri/gembok-simple.git $WEBROOT

chown -R www-data:www-data $WEBROOT
chmod -R 755 $WEBROOT

# =============================
# DETEKSI PHP
# =============================
PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
echo "📌 PHP Version: $PHP_VERSION"

# =============================
# NGINX CONFIG (FIX + SECURITY)
# =============================
echo "⚙️ Setup NGINX..."

cat > /etc/nginx/sites-available/gembok <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    root $WEBROOT;
    index index.php index.html;

    # =============================
    # SECURITY BLOCK
    # =============================

    # Block hidden files (.env, .git, dll)
    location ~ /\.(htaccess|env|git) {
        deny all;
    }

    # Block sensitive directories
    location ~ ^/(logs)/ {
        deny all;
    }

    location ~ ^/includes/ {
        deny all;
    }

    # Disable PHP execution di uploads
    location ~ ^/uploads/.*\.php$ {
        deny all;
    }

    # Allow akses file upload (gambar dll)
    location ^~ /uploads/ {
        try_files \$uri \$uri/ =404;
    }

    # Block config files
    location ~* \.(ini|log|conf)$ {
        deny all;
    }

    # =============================
    # MAIN ROUTING
    # =============================
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    # =============================
    # PHP HANDLER (ANTI 502)
    # =============================
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php$PHP_VERSION-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    # =============================
    # LIMIT & HARDENING
    # =============================
    client_max_body_size 20M;
    server_tokens off;
}
EOF

ln -sf /etc/nginx/sites-available/gembok /etc/nginx/sites-enabled/

nginx -t && systemctl reload nginx

# =============================
# FIREWALL
# =============================
echo "🔥 Setup firewall..."
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw --force enable

# =============================
# SSL
# =============================
echo "🔒 Setup SSL..."
certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m $EMAIL --redirect

# =============================
# FINAL CHECK
# =============================
echo "🔍 Validasi PHP Extension..."
php -m | grep -E "gd|intl"

# =============================
# DONE
# =============================
echo ""
echo "===================================="
echo "✅ INSTALL SELESAI (FIX VERSION)"
echo "🌐 https://$DOMAIN"
echo "===================================="