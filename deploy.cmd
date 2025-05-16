@echo off
echo Deploying ABVC Solutions microservices application to Kubernetes...

echo Creating namespace...
kubectl apply -f kubernetes\namespace.yaml

echo Creating persistent volume and persistent volume claim...
kubectl apply -f kubernetes\persistent-volume.yaml

echo Deploying database service...
kubectl apply -f kubernetes\database-service.yaml

echo Deploying API service with autoscaling...
kubectl apply -f kubernetes\api-service.yaml

echo Deployment complete! Use this command to check status:
echo kubectl get all -n abvc-app
echo.
echo After deployment is complete, access the API at:
echo minikube service api-service -n abvc-app
