FROM 888846118547.dkr.ecr.us-east-1.amazonaws.com/cruddur-python:3.10-slim-buster

RUN apt-get update && apt-get upgrade -y && pip3 install --upgrade pip
RUN useradd cruddur 
WORKDIR /backend-flask

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .

EXPOSE ${PORT}

ENV PYTHONUNBUFFERED=1

#change permissions
RUN chown -R cruddur:cruddur /backend-flask
RUN chmod -R 755 /backend-flask

#Run as cruddur
USER cruddur
CMD [ "python3", "-m" ,"-u", "flask", "run", "--host=0.0.0.0", "--port=4567", "--debug"]