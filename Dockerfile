# Build (Construccion)

# Usar node v 18 alpine

FROM node:18-alpine AS build

# Crear el directorio '/app'
WORKDIR /app


# Copiar los archivos de dependencias (package.json, package-lock.json)
COPY package.json package-lock.json ./


# Instalar las dependencias (--nmp ci-- CI/CD)
RUN npm ci --legacy-peer-deps


# Copiar todo el codigo fuente a la imagen
COPY . .

# Construir el proyecto en modo produccion (npm run build)
RUN npm run build

#production (Ejecucion)
# Usar ngnix v 1.25 alpine
FROM nginx:1.25-alpine

# Borrar la configuracion por defecto de nginx
# /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/conf.d/default.conf

# Copiar la configuracion del archivo nginx.conf
# /etc/nginx/conf.d/default.conf
COPY .nginx.conf /etc/nginx/conf.d/default.conf

# Copiar los archivos en la etapa 'build'
# build: /app/dist/angular-pro-angular-lite
# copiar a: /usr/share/nginx/html
COPY --from=build /app/dist/admin-pro-angular-lite /usr/share/nginx/html

# Exponer el puerto 80
EXPOSE 80


CMD ["nginx", "-g", "daemon off;"]


