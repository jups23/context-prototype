from flask import Flask
from flask import request

app = Flask(__name__)

@app.route('/', methods=["GET", "POST"])
def hello_world():
    print request.form
    return "Hello World!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=False)