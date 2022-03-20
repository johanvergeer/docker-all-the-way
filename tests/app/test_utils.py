import os
from unittest import TestCase
from unittest.mock import patch

from app.utils import getenv_bool


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
