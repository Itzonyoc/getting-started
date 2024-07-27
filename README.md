CURSO DEVOPS DESDE CERO

SEGUIR LOS SIGUIENTES PASOS PARA EL EJEMPLO DE DOCKER Y DOCKER-COMPOSE:

CONTENEDOR DE UNA APLICACIÓN:
1. Compilar la imagen:
docker build -t getting-started:1.0.0 .

2. Subir la imagen a un repositorio publico, docker HUB: 
(en ejemplo el repositorio getting-started existe en Docker HUB)
docker tag getting-started:1.0.0 <CUENTA_DOCKER_HUB>/getting-started:1.3.0
docker image push <CUENTA_DOCKER_HUB>/getting-started:1.3.0

3. Crear un contenedor con la imagen de la aplicación y validar en:  
(en el ejemplo se utiliza un repositorio publico creado en clase)
docker run -d -p 127.0.0.1:3000:3000 katvelasquezh/getting-started:1.3.0

MULTIPLES CONTENEDORES:
1. Crear un network
docker network create todo-app

2. Ejecutar la BD
docker run -d --network todo-app --network-alias mysql -v todo-mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=todos mysql:8.0

3. Ejecutar la aplicación con BD
docker run -dp 127.0.0.1:3000:3000 -w //app -v "/$(pwd):/app" --network todo-app -e MYSQL_HOST=mysql -e MYSQL_USER=root -e MYSQL_PASSWORD=secret -e MYSQL_DB=todos katvelasquezh/getting-started:1.3.0

EJEMPLO CON DOCKER-COMPOSE:
1. Ejecutar aplicación con BD:
docker-compose up -d





====================================================================================================================
# Getting started

This repository is a sample application for users following the getting started guide at https://docs.docker.com/get-started/.

The application is based on the application from the getting started tutorial at https://github.com/docker/getting-started