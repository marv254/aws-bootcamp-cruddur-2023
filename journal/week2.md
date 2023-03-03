# Week 2 — Distributed Tracing

For week 2 coverage i was able to use different tools for distributed tracing and observability:

**1. HoneyComb**

**Instrumente backend flask application to use Open Telemetry (OTEL) with Honeycomb.io as the provider**

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
