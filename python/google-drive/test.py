from fileclient import FileClient

def test_list():
    cl = FileClient()
    cl.list_recent()

def test_about():
    cl = FileClient()
    cl.show_about()

def test_rw():
    cl = FileClient()
    path = 'foo.txt'
    content = 'Hello World'
    # cl.write(path, content)

    result = cl.read(path)

    print(result)
    # assert(content == result)

# test_list()
# test_about()
test_rw()
