# Usar la imagen base oficial de Node.js
FROM node:14

# Establecer el directorio de trabajo
WORKDIR /usr/src/app

# Copiar archivos necesarios
COPY package*.json ./
RUN npm install --legacy-peer-deps
COPY . .

# Exponer el puerto de la app
EXPOSE 80

# Ejecutar la aplicación
CMD ["npm", "start"]

