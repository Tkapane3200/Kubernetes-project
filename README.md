# ABVC Solutions Kubernetes Deployment

This project demonstrates deploying a microservices application to Kubernetes for ABVC Solutions. It includes a REST API service and a database service.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Project Structure

```
.
├── kubernetes/                    # Kubernetes configuration files
│   ├── api-service.yaml           # API service deployment, service, and HPA
│   ├── database-service.yaml      # Database service deployment and service
│   ├── namespace.yaml             # Namespace definition
│   └── persistent-volume.yaml     # PV and PVC definitions
├── src/                           # Source code for microservices
│   ├── api/                       # API service
│   │   ├── app.js                 # API service implementation
│   │   ├── Dockerfile             # Docker build instructions
│   │   └── package.json           # Node.js dependencies
│   └── database/                  # Database service
│       ├── app.js                 # Database service implementation
│       ├── Dockerfile             # Docker build instructions
│       └── package.json           # Node.js dependencies
├── build-images.cmd               # Script to build Docker images
├── deploy.cmd                     # Script to deploy to Kubernetes
└── README.md                      # This file
```

## Setup Instructions

### 1. Start Minikube

```bash
minikube start
```

### 2. Build Docker Images

Run the build script to create the Docker images:

```bash
build-images.cmd
```

### 3. Load Images into Minikube

Since Minikube uses its own Docker daemon, you need to load the images into Minikube:

```bash
minikube image load api-service:latest
minikube image load database-service:latest
```

### 4. Deploy to Kubernetes

Run the deployment script:

```bash
deploy.cmd
```

### 5. Verify Deployment

Check that all resources are running correctly:

```bash
kubectl get all -n abvc-app
```

### 6. Access the Application

Get the URL to access the API service:

```bash
minikube service api-service -n abvc-app --url
```

## Testing the Application

### Create an Item

```bash
curl -X POST -H "Content-Type: application/json" -d '{"name":"Test Item","description":"This is a test item"}' http://<service-url>/api/items
```

### Get All Items

```bash
curl http://<service-url>/api/items
```

### Get Item by ID

```bash
curl http://<service-url>/api/items/1
```

### Update Item

```bash
curl -X PUT -H "Content-Type: application/json" -d '{"name":"Updated Item","description":"This is an updated item"}' http://<service-url>/api/items/1
```

### Delete Item

```bash
curl -X DELETE http://<service-url>/api/items/1
```

## Test Data Persistence

1. Create some items using the API
2. Delete the database pod:
   ```bash
   kubectl delete pod -n abvc-app -l app=database-service
   ```
3. Wait for the pod to restart
4. Verify that your items still exist by getting all items

## Test Autoscaling

Generate load on the API service to trigger autoscaling:

```bash
# In one terminal window, watch the HPA:
kubectl get hpa api-service-hpa -n abvc-app --watch

# In another terminal window, generate load (requires hey load testing tool):
hey -z 2m -c 50 http://<service-url>/api/items
```

## Cleanup

To remove all resources:

```bash
kubectl delete namespace abvc-app
kubectl delete pv data-pv
minikube stop
```
