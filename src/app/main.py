import tornado.web
from tornado.httpserver import HTTPServer
from tornado.ioloop import IOLoop

from app.utils import getenv_bool


class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Hello, World")


def make_app():
    return tornado.web.Application(
        [
            (r"/", MainHandler),
        ],
        debug=getenv_bool("DEBUG", default=False),
    )


def main():
    app = make_app()

    server = HTTPServer(app)
    server.listen(8000)

    IOLoop.current().start()


if __name__ == "__main__":
    main()
