FROM python:3.10-slim-buster as base

RUN mkdir /run/secrets/

RUN pip install poetry

RUN python -m venv /venv
ENV VIRTUAL_ENV=/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

WORKDIR /opt

COPY ["./poetry.lock", "./pyproject.toml", "./"]
COPY ["/src/", "./src/"]

# Install Postgres dependencies
RUN apt update \
    && apt upgrade  -y \
    && apt -y install libpq-dev gcc

FROM base as develop

COPY ["./tests/", "./tests/"]

RUN poetry install --no-interaction --remove-untracked

FROM base as production

RUN poetry install --no-dev --no-interaction

RUN rm -rf poetry.lock ./pyproject.toml src

RUN apt-get clean && apt-get autoremove
