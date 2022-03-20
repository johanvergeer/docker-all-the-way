from os import getenv


def getenv_bool(variable_name: str, default: bool = False):
    return getenv(variable_name, default=str(default)).lower() in {"true", "1", "t"}
