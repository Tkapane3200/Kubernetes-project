@echo off
echo This script will generate load on the API service to test autoscaling
echo Before running, make sure to have the correct service URL

if "%1"=="" (
    echo Usage: load-test.cmd [API_URL]
    echo Example: load-test.cmd http://192.168.49.2:30080/api/items
    exit /b 1
)

echo Generating load on %1
echo Open another terminal and run: kubectl get hpa api-service-hpa -n abvc-app --watch
echo.
echo Press Ctrl+C to stop the load test
echo.

:loop
curl -s %1 > nul
timeout /t 1 /nobreak > nul
curl -s -X POST -H "Content-Type: application/json" -d "{\"name\":\"Test Item\",\"description\":\"Generated for load testing\"}" %1 > nul
timeout /t 1 /nobreak > nul
goto loop
