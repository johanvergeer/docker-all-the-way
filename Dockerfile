# syntax=docker/dockerfile:1

FROM python:3.10-slim as base

WORKDIR /opt

ENV PATH="/root/.local/bin:$PATH"

RUN \
    # update and upgrade to retrieve the latest security updates
    # Run `dcup --build --no-cache` or `dcdev build --no-cache` to get the security updates while developing
    apt update \
    && apt upgrade -y \
    # Install Poetry for dependency management
    && apt install -y --no-install-recommends curl \
    && curl -sSL https://install.python-poetry.org > poetry-install.sh \
    && cat poetry-install.sh | python3 - \
    # Poetry doesn't have to create a virtual environment inside the Docker image
    && poetry config virtualenvs.create false \
    # curl is no longer needed after installation of Poetry. This will reduce the image size by 2MB
    && apt --purge autoremove -y curl \
    # Install database dependencies
    # `--no-install-recommends` skips installation of extra dependencies which reduces the image size by 25MB
    && apt install -y --no-install-recommends libpq-dev gcc

# Copy files required for Poetry to install the dependencies
COPY ["./poetry.lock", "./pyproject.toml", "./"]
# Copy source files. These will be used by `poetry install`
COPY ["/src/", "./src/"]

FROM base as develop

# Test files are only required for development
COPY ["./tests/", "./tests/"]

RUN \
  # Install with development dependencies
  poetry install --no-interaction --remove-untracked

FROM base as production

RUN \
    # Install without development dependencies
    poetry install --no-dev --no-interaction \
    # Poetry commands will not be run in the production Docker container
    && poetry-install.sh | python3 - --uninstall \
    # The poetry files and src files are no longer needed
    && rm -rf poetry.lock ./pyproject.toml poetry-install.sh src
