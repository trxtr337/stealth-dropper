from http.server import HTTPServer, SimpleHTTPRequestHandler
from socketserver import ThreadingMixIn
import os

class ThreadedHTTPServer(ThreadingMixIn, HTTPServer):
    pass

if __name__ == '__main__':
    os.chdir(os.path.dirname(__file__))  # Рабочая директория = проект
    print("[+] StealthDropper сервер запущен на http://0.0.0.0:8080")
    ThreadedHTTPServer(('0.0.0.0', 8080), SimpleHTTPRequestHandler).serve_forever()
