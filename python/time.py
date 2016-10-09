from datetime import datetime
import time

start = datetime.now()


time.sleep(1)

end = datetime.now()

print(start.strftime('%b-%d-%y %H:%M:%S'))
print(end.strftime('%b-%d-%y %H:%M:%S'))
print(end-start)
print('Pack ok & Time used: ' + str(end-start))


