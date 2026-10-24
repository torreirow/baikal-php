# Baïkal (upstream image ckulka/baikal:nginx) with PHP 8.3 instead of PHP 8.1.
#
# PHP 8.1 is end-of-life and does not receive the PHP2Shell fix (CVE-2026-109618/109619);
# upstream does not publish an image with a patched PHP. Only the PHP packages (from
# packages.sury.org, already configured in the upstream image) are replaced. Baïkal, the
# nginx configuration and the entrypoint scripts come unchanged from the pinned upstream image.
ARG UPSTREAM=ckulka/baikal@sha256:1a901125d121a3e414cda87c617bd322c57ae86b9d2aedbff7b3a7ac84bb23aa
FROM ${UPSTREAM}

ARG PHP_MIN=8.3.36

RUN apt-get update \
  && apt-get purge -y 'php8.1*' \
  && apt-get install -y --no-install-recommends \
    php8.3-curl php8.3-fpm php8.3-mbstring php8.3-mysql php8.3-pgsql php8.3-sqlite3 php8.3-xml \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/* /etc/php/8.1 \
  && sed -i 's/www-data/nginx/' /etc/php/8.3/fpm/pool.d/www.conf \
  && sed -i 's/^listen = .*/listen = \/var\/run\/php-fpm.sock/' /etc/php/8.3/fpm/pool.d/www.conf \
  && php -r 'exit(version_compare(PHP_VERSION, $argv[1], ">=") ? 0 : 1);' "$PHP_MIN"
