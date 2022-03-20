FROM python:3.10-slim-buster

RUN mkdir /run/secrets/

WORKDIR /opt

COPY ["./setup.py", "./"]
COPY ["/src/", "./src/"]
COPY ["./tests/", "./tests/"]

# Install Postgres dependencies
RUN apt update \
    && apt upgrade  -y \
    && apt -y install libpq-dev gcc

RUN python -m pip install --upgrade pip \
    && python setup.py install \
    && pip install -e .
