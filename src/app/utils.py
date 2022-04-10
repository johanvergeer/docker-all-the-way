from os import getenv
from pathlib import Path


def getenv_bool(variable_name: str, default: bool = False) -> bool:
    return getenv(variable_name, default=str(default)).lower() in {"true", "1", "t"}


def read_secret(secret_name: str) -> str:
    with (Path("/run/secrets") / secret_name).open() as secret_file:
        return secret_file.readline().strip()
