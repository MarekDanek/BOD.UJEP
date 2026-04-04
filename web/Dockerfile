FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Prisma generate musí proběhnout během buildu
RUN DATABASE_URL="file:./dev.db" npx prisma generate

EXPOSE 3000

CMD ["npm", "run", "dev"]