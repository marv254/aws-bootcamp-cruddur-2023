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

**2. AWS X-Ray**

**Instrument AWS X-Ray for backend flask**

First we weill set our env vars 
```
export AWS_REGION="ca-central-1"
gp env AWS_REGION="ca-central-1"
```
add dependencies in ```requirements.txt``` 
```
aws-xray-sdk
```
we will then install these dependencies by issuing  ```pip install -r requirements.txt```

In our ```app.py``` file we will add the code below to instrument AWS X-Ray

```
from aws_xray_sdk.core import xray_recorder
from aws_xray_sdk.ext.flask.middleware import XRayMiddleware

xray_url = os.getenv("AWS_XRAY_URL")
xray_recorder.configure(service='Cruddur', dynamic_naming=xray_url)
XRayMiddleware(app, xray_recorder)
```
Setting up  AWS X-Ray Resources

Add ```aws/json/xray.json```
```
{
  "SamplingRule": {
      "RuleName": "Cruddur",
      "ResourceARN": "*",
      "Priority": 9000,
      "FixedRate": 0.1,
      "ReservoirSize": 5,
      "ServiceName": "backend-flask",
      "ServiceType": "*",
      "Host": "*",
      "HTTPMethod": "*",
      "URLPath": "*",
      "Version": 1
  }
}
```

we will then create a log group by issuing the commands below:
```
FLASK_ADDRESS="https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
aws xray create-group \
   --group-name "Cruddur" \
   --filter-expression "service(\"backend-flask")
   ```
we will then use the x-ray.json file that we created earlier to create our sampling rule for x-ray
```
aws xray create-sampling-rule --cli-input-json file://aws/json/xray.json
```
we will also need to add a x-ray daemon service in our docker-compose fiel

```
  xray-daemon:
    image: "amazon/aws-xray-daemon"
    environment:
      AWS_ACCESS_KEY_ID: "${AWS_ACCESS_KEY_ID}"
      AWS_SECRET_ACCESS_KEY: "${AWS_SECRET_ACCESS_KEY}"
      AWS_REGION: "us-east-1"
    command:
      - "xray -o -b xray-daemon:2000"
    ports:
      - 2000:2000/udp
```
Finally we will set two env vars to our backend-flask in our docker-compose.yml file
```
      AWS_XRAY_URL: "*4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}*"
      AWS_XRAY_DAEMON_ADDRESS: "xray-daemon:2000"
```
