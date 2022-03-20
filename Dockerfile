FROM python:3.10-buster

WORKDIR /opt

COPY ["./setup.py", "./"]
COPY ["/src/", "./src/"]
COPY ["./tests/", "./tests/"]

RUN python -m pip install --upgrade pip \
    && python setup.py install \
    && pip install -e .
