# Week 1 — App Containerization

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
