from http.server import BaseHTTPRequestHandler, HTTPServer
import json
from http import HTTPStatus
import time
import logging
import os

hostName = os.getenv("HOST", "localhost")
hostPort = int(os.getenv("PORT", 9000))

def get_logger(class_name):
	logging.basicConfig(
		level=logging.INFO,
		format='{"timestamp": "%(asctime)s", "relative_time": "%(relativeCreated)d", "thread":, "%(threadName)s" , "level": "%(levelname)s", "class": "%(name)s",  "message": "%(message)s"}',
		handlers=[
			logging.FileHandler("{0}.log".format("execution")),
			logging.StreamHandler()
		])
	return logging.getLogger(class_name)

class Server(BaseHTTPRequestHandler):
    def __init__(self, *args):
        self.logger = get_logger(__name__)
        self.server_version = "ChimeraMock/0.0.1"
        super().__init__(*args)

    def do_POST(self):
        if "/oauth" == self.path:
            content_len = int(self.headers.get('content-length', 0))
            post_body = json.loads(self.rfile.read(content_len).decode('utf8'))
            if "username" in post_body.keys() and "password" in post_body.keys():
                if post_body["username"] == "user" and post_body["password"] == "secret123":
                    response = json.dumps({
                        'access_token': "ab125af548"
                    }).encode()
                    self.send_response(HTTPStatus.OK)
                    self.send_header("Content-type", "application/json")
                    self.end_headers()
                    self.wfile.write(response)
                    return
                self.send_error(HTTPStatus.UNAUTHORIZED)
                return
            else:
                self.send_error(HTTPStatus.BAD_REQUEST)
                return
        self.send_error(HTTPStatus.NOT_FOUND)

    def do_GET(self):
        if "/restricted" == self.path:
            if self.headers.get("Authorization") == "Bearer ab125af548":
                response = json.dumps({
                    'content': "secrets"
                }).encode()
                self.send_response(HTTPStatus.OK)
                self.send_header("Content-type", "application/json")
                self.end_headers()
                self.wfile.write(response)
                return
            else:
                self.send_error(HTTPStatus.UNAUTHORIZED)
                return
        self.send_error(HTTPStatus.NOT_FOUND)

if __name__ == "__main__":
    try:
        mock_server = HTTPServer((hostName, hostPort), Server)
        mock_server.serve_forever()
    except KeyboardInterrupt:
        mock_server.server_close()
