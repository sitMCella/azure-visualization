# Frontend Application

Azure visualization frontend application.

## Build Docker image

```sh
docker build -t azure-visualisation .
```

## Execute Docker container

```sh
docker run --rm --name azure-visualisation -d -p 80:80 azure-visualisation:latest 
```
