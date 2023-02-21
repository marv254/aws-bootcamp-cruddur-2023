FROM python:3.12.0a5-slim

RUN apt-get update && apt-get upgrade -y && pip3 install --upgrade pip
RUN useradd cruddur 
WORKDIR /backend-flask

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .

ENV FLASK_ENV=development

EXPOSE ${PORT}

#change permissions
RUN chown -R cruddur:cruddur /backend-flask
RUN chmod -R 755 /backend-flask

#Run as cruddur
USER cruddur
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0", "--port=4567"]