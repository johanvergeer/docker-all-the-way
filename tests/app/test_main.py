from tornado.testing import AsyncHTTPTestCase
from tornado.web import Application

from app.main import make_app


class TestMain(AsyncHTTPTestCase):
    def get_app(self) -> Application:
        return make_app()

    def test_read_main(self) -> None:
        response = self.fetch("/")
        self.assertEqual(response.code, 200)
        self.assertEqual(response.body, b"Hello, World")
