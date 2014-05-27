import pdb
import socket

from flask import Flask
from flask import request

app = Flask(__name__)

UDP_IP = "localhost"
UDP_PORT = 6000
sock = socket.socket(socket.AF_INET, # Internet
             socket.SOCK_DGRAM) # UDP


@app.route('/', methods=["GET", "POST"])
def hello_world():
    data = float(request.form.get('attitudePitch'))
    if abs(data):
        print data
        sock.sendto(str(data), (UDP_IP, UDP_PORT))


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=False)