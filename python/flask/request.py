from flask import Flask, request

app = Flask(__name__)


"""
在浏览器访问 http://127.0.0.1:5000/test?a=100&b=100
输出结果 a + b = 200
"""
@app.route('/test')
def test():
    a = int(request.args.get('a'))
    b = int(request.args.get('b'))
    return 'a + b = %d' % (a+b)
