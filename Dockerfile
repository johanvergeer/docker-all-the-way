FROM python:3.10-slim-buster

RUN mkdir /run/secrets/

RUN pip install poetry

RUN python -m venv /venv
ENV VIRTUAL_ENV=/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

WORKDIR /opt

COPY ["./poetry.lock", "./pyproject.toml", "./"]
COPY ["/src/", "./src/"]
COPY ["./tests/", "./tests/"]

# Install Postgres dependencies
RUN apt update \
    && apt upgrade  -y \
    && apt -y install libpq-dev gcc

RUN poetry install --no-interaction --remove-untracked
