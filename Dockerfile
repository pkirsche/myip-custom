# Build stage
FROM node:24-alpine AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Production stage
FROM node:24-alpine AS production-stage
WORKDIR /app

# Only production dependencies
COPY --from=build-stage /app/package*.json ./
RUN npm ci --omit=dev

# App files
COPY --from=build-stage /app/dist ./dist
COPY --from=build-stage /app/backend-server.js ./
COPY --from=build-stage /app/frontend-server.js ./
COPY --from=build-stage /app/api ./api
COPY --from=build-stage /app/common ./common

# Entrypoint
COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x entrypoint.sh

EXPOSE 18966

CMD ["./entrypoint.sh"]
