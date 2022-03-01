FROM python:3.10-buster

WORKDIR /opt

COPY src ./src
COPY poetry.lock pyproject.toml ./

RUN pip install --upgrade --no-cache-dir pip && \
    pip install --no-cache-dir poetry && \
    poetry config virtualenvs.create false && \
    poetry install -n && \
    pip uninstall --yes poetry

ENTRYPOINT ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--reload"]
