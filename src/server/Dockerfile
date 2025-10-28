FROM node:18-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

# Install netcat so we can wait for the DB to be ready before starting the app
RUN apk add --no-cache netcat-openbsd

EXPOSE 3000

# At container start, wait until the DB host/port are reachable, then start the server
CMD sh -c 'until nc -z "$DB_HOST" "${DB_PORT:-3306}"; do echo "Waiting for DB at $DB_HOST:$DB_PORT..."; sleep 1; done; npm start'