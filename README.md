# phusion-passenger-docker-playground

A playground for Phusion Passenger within Docker

## How to use

1.
```shell
docker build -t phusion-passenger-docker-playground:latest .
docker run -p 8888:80 -e PASSENGER_APP_ENV=production -t phusion-passenger-docker-playground:latest
```
2. Open <http://localhost:8888>.
