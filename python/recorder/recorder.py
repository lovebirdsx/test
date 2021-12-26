import json
import hashlib
import os.path
import os
import time

def read_json_file(path):
	if not os.path.isfile(path):
		return {}
	content = open(path, 'r').read()
	return json.loads(content)

def write_json_file(path, t):
	with open(path, 'w') as outfile:
		json.dump(t, outfile, sort_keys=True, indent=4, separators=(',', ': '))

def get_file_md5(file):
    hash_md5 = hashlib.md5()
    with open(file, 'rb') as f:
        for chunk in iter(lambda: f.read(4096), b''):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()

def get_file_modify_time(path):
	return os.stat(path).st_mtime

def read_file(file):
	return open(file, 'r').read()

def write_file(file, content):
	with open(file, 'w') as outfile:
		outfile.write(content)

class Recorder:
	def __init__(self, record_file):
		self.record_file = record_file
		self.records = read_json_file(record_file)

	def record(self, file):
		md5 = get_file_md5(file)
		modify_time = get_file_modify_time(file)
		self.records[file] = (modify_time, md5, time.ctime(modify_time))
		write_json_file(self.record_file, self.records)

	def need_update(self, file):
		if not file in self.records:
			return True

		if not os.path.isfile(file):
			return True

		if type(self.records[file]) == type(''):
			return True

		modify_time_prev = self.records[file][0]
		modify_time = get_file_modify_time(file)

		if modify_time == modify_time_prev:
			return False

		md5 = get_file_md5(file)
		md5_prev = self.records[file][1]
		return md5 != md5_prev