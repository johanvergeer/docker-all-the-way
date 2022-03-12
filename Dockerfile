FROM python:3.10-buster

RUN pip install poetry

RUN python -m venv /venv
ENV VIRTUAL_ENV=/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

WORKDIR /opt

COPY ["./poetry.lock", "./pyproject.toml", "./"]
COPY ["/src/", "./src/"]
COPY ["./tests/", "./tests/"]

RUN poetry install --no-interaction --remove-untracked
