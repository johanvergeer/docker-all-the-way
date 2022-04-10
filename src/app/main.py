from tornado.httpserver import HTTPServer
from tornado.ioloop import IOLoop
from tornado.web import Application, RequestHandler

from app.utils import getenv_bool


class MainHandler(RequestHandler):
    def get(self) -> None:
        self.write("Hello, World")


def make_app() -> Application:
    return Application(
        [
            (r"/", MainHandler),
        ],
        debug=getenv_bool("DEBUG", default=False),
    )


def main() -> None:
    app = make_app()

    server = HTTPServer(app)
    server.listen(8000)

    IOLoop.current().start()


if __name__ == "__main__":
    main()
