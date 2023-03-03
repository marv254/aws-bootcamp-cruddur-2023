# Week 2 — Distributed Tracing

For week 2 coverage i was able to use different tools for distributed tracing and observability:

**1. HoneyComb**

**i). Instrumente backend flask application to use Open Telemetry (OTEL) with Honeycomb.io as the provider**

First you add the dependencies  below to your ```requirements.txt ```
```
opentelemetry-api 
opentelemetry-sdk 
opentelemetry-exporter-otlp-proto-http 
opentelemetry-instrumentation-flask 
opentelemetry-instrumentation-requests
```
then you install these dependencies by running ```pip install -r requirements.txt ```

In our app.py we will then instrument it to use OTEL with HoneyComb.io as the provider

![honeycomb instrument](https://user-images.githubusercontent.com/60808086/222711987-96414d0c-a871-4fb8-bbb8-48b2b3e7f3d0.png)

for it to work with our docker compose file we will have to set env vars to our backend container
```
OTEL_EXPORTER_OTLP_ENDPOINT: "https://api.honeycomb.io"
OTEL_EXPORTER_OTLP_HEADERS: "x-honeycomb-team=${HONEYCOMB_API_KEY}"
OTEL_SERVICE_NAME: "${HONEYCOMB_SERVICE_NAME}"
```
You also have to set API key as environment variable:
```
export HONEYCOMB_API_KEY=""
export HONEYCOMB_SERVICE_NAME="Cruddur"
gp env HONEYCOMB_API_KEY=""
gp env HONEYCOMB_SERVICE_NAME="Cruddur"
```

**ii). Run queries to explore traces within HoneyComb.io**

We already set our cruddur app to automatically send data to our honeycomb account.

![honeycomb ](https://user-images.githubusercontent.com/60808086/222716758-5151540b-1440-41a9-9705-c8d374182733.png)

we then run a query to group our data by traceid

![honeycomb 2](https://user-images.githubusercontent.com/60808086/222716786-d3f0df75-b71d-4b0c-802a-6c1022f990a5.png)

![honeycomb 3](https://user-images.githubusercontent.com/60808086/222716823-99af6495-31bc-404b-a773-bdb27888bec9.png)

**2. Cloudwatch**

Add dependency ```watchtower``` to our ```requirements.txt```.
Install the dependency by issuing ``` pip install -r requirements.txt```

In our ```app.py``` we will instrument our backend to use cloudwatch
```
import watchtower
import logging
from time import strftime
```
```
# Configuring Logger to Use CloudWatch
LOGGER = logging.getLogger(__name__)
LOGGER.setLevel(logging.DEBUG)
console_handler = logging.StreamHandler()
cw_handler = watchtower.CloudWatchLogHandler(log_group='cruddur')
LOGGER.addHandler(console_handler)
LOGGER.addHandler(cw_handler)
LOGGER.info("some message")
```
```
@app.after_request
def after_request(response):
    timestamp = strftime('[%Y-%b-%d %H:%M]')
    LOGGER.error('%s %s %s %s %s %s', timestamp, request.remote_addr, request.method, request.scheme, request.full_path, response.status)
    return response
 ```
 we will then log some text in an API endpoint
 
 ![logger](https://user-images.githubusercontent.com/60808086/222735048-975c9634-2724-43c6-aa95-bdcb5405678c.png)

 set the env var in our backend-flask of our docker-compose file
 ```
       AWS_DEFAULT_REGION: "${AWS_DEFAULT_REGION}"
      AWS_ACCESS_KEY_ID: "${AWS_ACCESS_KEY_ID}"
      AWS_SECRET_ACCESS_KEY: "${AWS_SECRET_ACCESS_KEY}"
  ```

![cloudwatch](https://user-images.githubusercontent.com/60808086/222732221-c6234091-2304-4237-8011-15e944b26024.png)

![cloudwatch 1](https://user-images.githubusercontent.com/60808086/222732320-79af2be6-e09c-4746-9abf-bda10f2964e0.png)

**3. Rollbar**

First you will have to have a rollbar account. Create a new project to store our items.

First you add the dependencies below to your ```requirements.txt ```
```
blinker
rollbar
```
Install the dependency by issuing ``` pip install -r requirements.txt```

we also neeed to set access token as env var 
```
export ROLLBAR_ACCESS_TOKEN=""
gp env ROLLBAR_ACCESS_TOKEN=""
```
also set the env var of backend-flask for docker-compose file
```
export ROLLBAR_ACCESS_TOKEN=""
gp env ROLLBAR_ACCESS_TOKEN=""
```
instrument rollbar in app.py file for our backend
```
import rollbar
import rollbar.contrib.flask
from flask import got_request_exception
```
```
rollbar_access_token = os.getenv('ROLLBAR_ACCESS_TOKEN')
@app.before_first_request
def init_rollbar():
    """init rollbar module"""
    rollbar.init(
        # access token
        rollbar_access_token,
        # environment name
        'production',
        # server root directory, makes tracebacks prettier
        root=os.path.dirname(os.path.realpath(__file__)),
        # flask already sets up logging
        allow_logging_basic_config=False)

    # send exceptions from `app` to rollbar, using flask's signal system.
    got_request_exception.connect(rollbar.contrib.flask.report_exception, app)
 ```
 we will then add an endpoint for testing rollbar in our ``app.py``` file
 ```
 @app.route('/rollbar/test')
def rollbar_test():
    rollbar.report_message('Hello World!', 'warning')
    return "Hello World!"
 ```
 
![rollbar](https://user-images.githubusercontent.com/60808086/222736411-d936cbc7-b13d-4d62-966e-fac6b8d5679a.png)
