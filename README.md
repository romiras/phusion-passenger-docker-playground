# phusion-passenger-docker-playground

A playground for Phusion Passenger within Docker

## How to use

1.
```shell
docker build -t phusion-passenger-docker-playground:latest .
docker run \
    -p 8888:80 \
    -e PASSENGER_APP_ENV=production \
    -e "SECRET_KEY_BASE=$SECRET_KEY_BASE" \
    -v "$(pwd)/src/log/production.log:/home/app/webapp/log/production.log" \
    -t phusion-passenger-docker-playground
```
2. Open <http://localhost:8888>.

3. Perform load test

```shell
go-wrk -H 'Accept: */*' -H 'Cache-Control: no-cache' -H 'Host: localhost:8888/' http://localhost:8888/?delay=5
```
