import os
from recorder import Recorder

def write_file(path, content):
	with open(path, 'w') as outfile:
		outfile.write(content)

def test():
	file1 = 'file1'
	record_file = 'record.json'
	if os.path.isfile(file1):
		os.remove(file1)
	if os.path.isfile(record_file):
		os.remove(record_file)

	recorder = Recorder(record_file)
	assert(recorder.need_update(file1))
	write_file(file1, 'file1')
	recorder.record(file1)
	assert(not recorder.need_update(file1))
	write_file(file1, 'file1_modifyed_1')
	assert(recorder.need_update(file1))
	recorder.record(file1)
	assert(not recorder.need_update(file1))

	recorder2 = Recorder(record_file)
	assert(not recorder2.need_update(file1))
	write_file(file1, 'file1_modifyed_2')
	assert(recorder2.need_update(file1))


test()
