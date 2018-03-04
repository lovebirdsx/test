#coding=utf8

from shutil import copytree
import os, time
import sys

def test_path():
	print(os.path.join('d:', r'\program'))
	print(os.path.join(r'd:\program', r'test'))

def compare_filetime(fa, fb):
	ta = os.stat(fa).st_mtime
	tb = os.stat(fb).st_mtime
	if ta > tb:
		return 1
	elif ta == tb:
		return 0
	else:
		return -1

def testtime():
	print(compare_filetime('e:/program/a', 'e:/program/b'))
	print(compare_filetime('e:/program/a', 'e:/program/a'))
	print(compare_filetime('e:/program/b', 'e:/program/a'))

def test_listfile():
	names = os.listdir('e:/program')
	for name in names:
		print(name)

def test_file():
	print(os.path.exists('e:/program/a'))
	print(os.path.exists('e:/program/aaa'))

def test_parm():
	def foo(a,b,c):
		print('a=', a)
		print('b=', b)
		print('c=', c)

	foo(**{'a':1,'b':2,'c':3})

def test_mutiline_str():
	print(
	"""i am yours
	wahaha
	hahaha
	""")

def test_get_dir():
	print(os.path.dirname('c:/test/test.bat'))

def test_make_dir():
	os.makedirs('test/test/test/test/a')

def test_dict():
	dic = {
		'a': 'value_a',
		'b': 'value_b',
		'c': {
			'c1' : 'foo',
			'c2' : 'bar',
		},
		'd' : (
			{'name': 'sale1', 'lr_file': 'sale1/sale1_lr.json'},
			{'name': 'sale2', 'lr_file': 'sale2/sale2_lr.json'},
		)
	}

	# for k in dic:
	# 	print(k, dic[k])

	for (k, v) in dic.items():
		print(k, v)

	for k in dic.keys():
		print(k)

def test_system():
	os.system('echo hello')

def test_conditon_expression():
	print('hello' if 1 else 'world')
	print('hello' if 0 else 'world')

def test_string_format():
	cnstr = u'本机'
	str = '%s %s %d' % ('hello', cnstr.encode('utf-8'), 123)
	str = '%s %s %d' % ('hello', '本机', 123)

	cmd_fmt_str = ("lr.exe --auto-run 1 --battle_rate %d --input input\\%s.lua --output %s"
                   " --designd %s"
                   " --prog-args-start no_set_battle_speed=1"
                  )
	str = cmd_fmt_str % (1, u'test', 'test', '本机')
	print(str)

def test_exception():
	def foo():
		raise Exception('foo error')

	try:
		foo()
	except Exception as e:
		print(str(e))

def test_listbox():
	root = Tk()
	def printList(event):
	    print(lb.get(lb.curselection()))
	lb = Listbox(root)
	lb.bind('<<ListboxSelect>>',printList)
	for i in range(10):
	    lb.insert(END,str(i*100))
	lb.pack()
	root.mainloop()

def test_checkbutton():
	def var_states():
		print(var.get())

	root = Tk()
	var = IntVar()
	chk = Checkbutton(root, text='hello', variable=var, command=var_states)
	chk.pack()


	root.mainloop()

def get_dir_name(path):
	return os.path.split(path)[-2]

def test_get_dir_name():
	print(get_dir_name('sale/sale1_lr.json'))

def test_sub_string():
	path = 'sale/sale1_lr.json'
	print(path[0 : -7] + 'ext_lr.json')

def test_str_find():
	path = 'sale/sale1_lr.json'
	print(path.rfind('/'))

def get_lr_name(path):
	sep_id = path.rfind('/')
	return path[sep_id + 1 : -8]

def test_lr_name():
	print(get_lr_name('sale/sale1_lr.json'))
	print(get_lr_name('sale1_lr.json'))
	print(get_lr_name('sale1/sale/sale1_lr.json'))

def test_for():
	for x in xrange(1,10):
		print(x)

def test_arg():
	print(sys.argv[0])
	if len(sys.argv) > 1:
		print(sys.argv[1])

def test_default_arg():
	def foo(a, b='default_b'):
		print(a, b)

	foo('hello')
	foo('hello', 'world')

def test_list():
	a = (1,2,3)
	for x in a:
		print(x)
	for i in range(0, len(a)):
		print(a[i])

def test_sort():
	l = [
		{'id': 3, 'name': 'foo'}, 
		{'id': 1, 'name': 'bar'}, 
		{'id': 4, 'name': 'car'}, 
		{'id': 2, 'name': 'fuc'}, 
	]

	l.sort(lambda a, b: cmp(a['id'], b['id']))
	print(l)

# test_sort()
# print 'hello world'.find('hello1')
print(help(str.startswith))
