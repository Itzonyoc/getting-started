# syntax=docker/dockerfile:1

FROM node:18-alpine
WORKDIR /app
COPY . .
# Agregar esta linea si presenta error de yarn self-signed certificate in certificate chain
RUN yarn config set strict-ssl false
RUN yarn install --production
CMD ["node", "src/index.js"]
EXPOSE 3000
