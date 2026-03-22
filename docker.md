# DevOps Bootcamp Docker Assignment

## Overview

This assignment required dockerizing a frontend and backend application, pushing the images to Docker Hub, and running the entire stack using Docker Compose with PostgreSQL.

---

## Step 1: Running the Application Locally

Both frontend and backend applications were cloned from GitHub and installed using npm.

Commands used:

npm install
npm run dev

The application ran successfully locally.

Screenshot:
![Local App](screenshots/local-app.png)
![alt text](image-4.png)

---

## Step 2: Dockerizing the Backend

A multi-stage Dockerfile was created to build the Node.js backend and produce a lightweight production image.

Key optimizations:
- Multi-stage builds
- Removed development dependencies
- Alpine base image

---

## Step 3: Dockerizing the Frontend

The frontend was built using Node.js and served using Nginx in the final stage.

This reduced the final image size and made it production-ready.

---

## Step 4: Pushing Images to Docker Hub

Images were built and pushed to my Docker Hub repository.

Docker Hub Repo:
https://hub.docker.com/r/Golori

Screenshot:
![alt text](image-5.png)

---

## Step 5: Docker Compose

Docker Compose was used to connect:

- Frontend
- Backend
- PostgreSQL database

Command used:

docker compose up -d

Screenshot:
![Docker Running](screenshots/docker-running.png)
![alt text](image-3.png)

---

## Conclusion

The application was successfully dockerized, optimized using multi-stage builds, pushed to Docker Hub, and deployed locally using Docker Compose.
