#!/bin/bash

clear
echo "🚀 INSTALLER GEMBOK-SIMPLE (MULTI DOMAIN VERSION)"

# =============================
# FUNGSI INSTALL DOMAIN
# =============================
install_domain() {

read -p "Masukkan domain (contoh: gembok.domain.com): " DOMAIN
read -p "Masukkan email SSL: " EMAIL

WEBROOT="/var/www/$DOMAIN"

echo "📦 Install untuk domain: $DOMAIN"
echo "📁 Path: $WEBROOT"

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
# NGINX CONFIG
# =============================
echo "⚙️ Setup NGINX..."

cat > /etc/nginx/sites-available/$DOMAIN <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    root $WEBROOT;
    index index.php index.html;

    # SECURITY
    location ~ /\.(htaccess|env|git) {
        deny all;
    }

    location ~ ^/(logs)/ {
        deny all;
    }

    location ~ ^/includes/ {
        deny all;
    }

    location ~ ^/uploads/.*\.php$ {
        deny all;
    }

    location ^~ /uploads/ {
        try_files \$uri \$uri/ =404;
    }

    location ~* \.(ini|log|conf)$ {
        deny all;
    }

    # ROUTING
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    # PHP HANDLER
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php$PHP_VERSION-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    client_max_body_size 20M;
    server_tokens off;
}
EOF

ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/

nginx -t && systemctl reload nginx

# =============================
# SSL
# =============================
echo "🔒 Setup SSL..."
certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m $EMAIL --redirect

echo "✅ Domain $DOMAIN selesai!"
echo "🌐 https://$DOMAIN"
echo "------------------------------------"
}

# =============================
# INSTALL AWAL (GLOBAL)
# =============================
echo "🔄 Update system..."
apt update -y && apt upgrade -y

echo "📦 Install dependency..."
apt install -y nginx mysql-server git curl unzip software-properties-common

apt install -y php php-fpm php-mysql php-cli php-curl php-xml php-mbstring \
php-gd php-intl php-zip php-bcmath

apt install -y certbot python3-certbot-nginx ufw

systemctl enable nginx && systemctl restart nginx
systemctl enable mysql && systemctl restart mysql
systemctl enable php*-fpm && systemctl restart php*-fpm

# =============================
# FIREWALL (JALAN SEKALI)
# =============================
echo "🔥 Setup firewall..."
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw --force enable

# =============================
# LOOP MULTI DOMAIN
# =============================
while true; do
    install_domain
    read -p "Tambah domain lagi? (y/n): " AGAIN
    [[ "$AGAIN" != "y" ]] && break
done

# =============================
# DONE
# =============================
echo ""
echo "===================================="
echo "✅ SEMUA INSTALL SELESAI"
echo "===================================="