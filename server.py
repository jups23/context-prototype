import pdb
import json
import socket

from flask import Flask
from flask import request

app = Flask(__name__)

UDP_IP = "localhost"
UDP_PORT = 6000
sock = socket.socket(socket.AF_INET, # Internet
             socket.SOCK_DGRAM) # UDP

@app.route('/', methods=["POST"])
def hello_world():
    # TODO: use get_json() and
    #[[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters];
    # pdb.set_trace()
    sock.sendto(json.dumps(request.form), (UDP_IP, UDP_PORT))
    return "OK"

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)