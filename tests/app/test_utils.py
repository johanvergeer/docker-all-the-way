import os
from pathlib import Path
from unittest import TestCase
from unittest.mock import patch

from app.utils import getenv_bool, read_secret


class TestGetEnvBool(TestCase):
    def test_environment_variable_not_set(self):
        self.assertEqual(getenv_bool("FOO", default=True), True)
        self.assertEqual(getenv_bool("FOO", default=False), False)

    def test_environment_variable_set(self):
        value_and_expected = {
            "1": True,
            "True": True,
            "t": True,
            "0": False,
            "False": False,
            "f": False,
        }

        for value, expected in value_and_expected.items():
            with self.subTest(f"'{value}' should be {expected}"):
                with patch.dict(os.environ, {"FOO": value}):
                    self.assertEqual(getenv_bool("FOO", not expected), expected)


class TestReadSecret(TestCase):
    def setUp(self) -> None:
        self.secret_path = Path("/run/secrets") / "foo"

    def tearDown(self) -> None:
        self.secret_path.unlink(missing_ok=True)

    def test_not_found(self) -> None:
        self.assertRaises(FileNotFoundError, read_secret, "foo")

    def test_secret_found(self) -> None:
        the_secret = "my secret text"
        with self.secret_path.open("w+") as secret_file:
            secret_file.write(the_secret)

        self.assertEqual(read_secret("foo"), the_secret)

    def test_secret_found__stripped(self) -> None:
        the_secret = "  my secret text \n \t"
        with self.secret_path.open("w+") as secret_file:
            secret_file.write(the_secret)

        self.assertEqual(read_secret("foo"), "my secret text")
