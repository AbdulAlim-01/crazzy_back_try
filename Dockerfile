FROM cirrusci/flutter:stable

RUN apt-get update && apt-get install -y \
    curl unzip git openjdk-11-jdk

# Set working directory
WORKDIR /app

COPY . .

EXPOSE 8080

CMD ["node", "server.js"]
