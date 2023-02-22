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

**3. Implementing Docker Security best practices**

From the top 10 lessons i learnt that the containers should not run as a root user so i created a new user called cruddur for both the frontend container and the backend container, i also change the permission for application to allow cruddur user to run the application. I also ensured that all the packages inside the containers are all up to date.

![dockerfile-updated vuln](https://user-images.githubusercontent.com/60808086/220614519-7cdbc53b-8ae6-46a1-8558-93e2f724a99a.png)

**4. Scanning Cruddur Application for Vulnerablities using Synk**

From docker security lecture, i learnt the various tools that can be used to scan our docker files. I used synk since it has a free tier. I scanned our cruddur application and i was shocked by the number of vulnerabilies it had.

**Synk Overview** 

Our Cruddur App had a total of 8 critical severity  and 22 of high severity

![synk scan](https://user-images.githubusercontent.com/60808086/220615843-eb4b6c41-6fb8-477d-92d1-363edca29fd7.png)

**Frontend Dockerfile Vulnerabilties**

Synk recommended i upgrade my base image from ```node:16.18``` to ```node:16.19.0```

![frontend-vuln](https://user-images.githubusercontent.com/60808086/220615918-e956edd1-0d40-4862-bcd3-3924ef3248f1.png)

**Backend Dockerfile Vulnerabilites**

Synk recommended i upgrade my base image from ```python:3.10-slim-buster``` to ```python:3.12.0a5-slim```

![backend-vulnerablities](https://user-images.githubusercontent.com/60808086/220615962-ec735270-c01a-4815-9203-ac4496ed3257.png)

**5. Resolved some of the Vulnerabilities**

I implemented some of the recommendations by changing the base image for both frontend and backend dockerfiles

![base image change](https://user-images.githubusercontent.com/60808086/220621178-bba94fbb-27a9-46ae-bf31-41c88045e3cf.png)

**Synk overview**


The vulnerabilties of our cruddur applications reduced to 2 critical severity and 8 high severity

![sync scan after implementing](https://user-images.githubusercontent.com/60808086/220620477-b32beec0-d7ce-4fe5-9c95-e03a7caee22d.png)

**Frontend scan**

![frontend scan after](https://user-images.githubusercontent.com/60808086/220620341-7b5fe37c-0b9b-47e1-86f1-1cca42c19b66.png)

**Backend scan**

![backend scan after](https://user-images.githubusercontent.com/60808086/220620414-b01aaf96-8ab3-452e-9e1e-57c0940a628a.png)




