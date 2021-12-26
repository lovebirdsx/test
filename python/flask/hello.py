from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    # a = 1 / 0
    return 'Hello, World!'

@app.route('/projects/')
def projects():
    return 'The project page'

@app.route('/about')
def about():
    return 'The about page'

@app.route('/post/<int:transaction_id>')
def post_transaction(transaction_id):
    return 'Transaction_id = %d' % transaction_id

if __name__ == "__main__":
    app.run(port=8080)