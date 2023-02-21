FROM node:16.18

RUN apt-get update && apt-get upgrade -y
RUN adduser cruddur 

ENV PORT=3000

COPY . /frontend-react-js
WORKDIR /frontend-react-js
RUN npm install -g npm@9.5.0
RUN npm i 

EXPOSE ${PORT}

#change permissions
RUN chown -R cruddur:cruddur /frontend-react-js
RUN chmod -R 755 /frontend-react-js

#Run as cruddur
USER cruddur

CMD ["npm", "start"]