# Week 1 — App Containerization

**1.Dockerizing Cruddur App**

From week 1 of the live stream,  i learnt how i can dockerize any application. For our cruddur app it was using react as the frontend so we used a base image from node while the backend was using python flask so we used a base image of python

**Frontend Dockerfile of cruddur app**
```
FROM node:16.18

ENV PORT=3000

COPY . /frontend-react-js
WORKDIR /frontend-react-js
RUN npm install
EXPOSE ${PORT}
CMD ["npm", "start"]
```

**Backend Dockerfile of cruddur app**
```
FROM python:3.10-slim-buster

WORKDIR /backend-flask

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .

ENV FLASK_ENV=development

EXPOSE ${PORT}
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0", "--port=4567"]
```
**2. Creating Docker Compose File for Cruddur Application**

With docker compose we can easily run multiple containers by creating a docker compose file in yaml format and  just issuing ```docker-compose up``` in the CLI, there is no need to build and run the containers seperately. I learnt how to create the docker compose file for our cruddur application and how to run it on both the CLI and vscode

**DockerCompose file for Cruddur application**
```
version: "3.8"
services:
  backend-flask:
    environment:
      FRONTEND_URL: "https://3000-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
      BACKEND_URL: "https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
    build: ./backend-flask
    ports:
      - "4567:4567"
    volumes:
      - ./backend-flask:/backend-flask
  frontend-react-js:
    environment:
      REACT_APP_BACKEND_URL: "https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
    build: ./frontend-react-js
    ports:
      - "3000:3000"
    volumes:
      - ./frontend-react-js:/frontend-react-js

# the name flag is a hack to change the default prepend folder
# name when outputting the image names
networks: 
  internal-network:
    driver: bridge
    name: cruddur
```
