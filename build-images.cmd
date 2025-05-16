@echo off
echo Building Docker images for the ABVC Solutions microservices application...

cd %~dp0\src\api
echo Building API service image...
docker build -t api-service:latest .

cd %~dp0\src\database
echo Building Database service image...
docker build -t database-service:latest .

echo Docker images built successfully. Use minikube image load to load them into minikube.
