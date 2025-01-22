<h1>Question 1. Understanding docker first run</h1>
Run docker with the python:3.12.8 image in an interactive mode, use the entrypoint bash. <br>
<br>
What's the version of pip in the image?

- 24.3.1<br>
- 24.2.1<br>
- 23.3.1<br>
- 23.2.1

```python
#code
(base) neda@taxi-rides-vm:~$ sudo docker run -it python:3.12.8 bash
root@c553063c0be6:/# pip --version
pip 24.3.1 from /usr/local/lib/python3.12/site-packages/pip (python 3.12)
```
<h1>Question 2. Understanding Docker networking and docker-compose</h1>
Given the following docker-compose.yaml, what is the hostname and port that pgadmin should use to connect to the postgres database?<br>

```python
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin  

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```
- postgres:5433
- localhost:5432
- db:5433
- postgres:5432
- db:5432

Docker Compose automatically sets up a network where services can communicate using their service names as hostnames. Within the Docker network, pgAdmin connects to the PostgreSQL service using the internal container port (5432) of the db service. The external port mapping (5433:5432) is irrelevant for internal communication between services in the same Docker network. so:<br>
**Hostname:** db<br>
**Port:** 5432
