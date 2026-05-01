# Použijeme obraz s Flutterem
FROM debian:latest AS build-env

# Instalace potřebných nástrojů
RUN apt-get update && apt-get install -y curl git wget unzip bzip2 libglu1-mesa
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Nastavení cesty
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Povolení webu a sestavení
RUN flutter config --enable-web
COPY . /app
WORKDIR /app
RUN flutter pub get
RUN flutter build web --release --no-wasm-dry-run

# Finální fáze - lehký webový server Nginx
FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]