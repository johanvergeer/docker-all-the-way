from tornado.testing import AsyncHTTPTestCase

from app.main import make_app


class TestMain(AsyncHTTPTestCase):
    def get_app(self):
        return make_app()

    def test_read_main(self):
        response = self.fetch("/")
        self.assertEqual(response.code, 200)
        self.assertEqual(response.body, b"Hello, World")
