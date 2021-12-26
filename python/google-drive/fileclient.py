# -*- coding: utf-8 -*-

from __future__ import print_function
import httplib2
import os
import io

from apiclient import discovery
from apiclient.http import MediaFileUpload, MediaIoBaseUpload, MediaIoBaseDownload
from oauth2client import client
from oauth2client import tools
from oauth2client.file import Storage

import ssl
from functools import wraps

# <http://stackoverflow.com/questions/14102416/python-requests-requests-exceptions-sslerror-errno-8-ssl-c504-eof-occurred>
def sslwrap(func):
    @wraps(func)
    def bar(*args, **kw):
        kw['ssl_version'] = ssl.PROTOCOL_TLSv1
        return func(*args, **kw)
    return bar
ssl.wrap_socket = sslwrap(ssl.wrap_socket)

# If modifying these scopes, delete your previously saved credentials
# at ~/.credentials/drive-python-quickstart.json
SCOPES = 'https://www.googleapis.com/auth/drive'
CLIENT_SECRET_FILE = 'client_secret.json'
APPLICATION_NAME = 'Drive API Python Quickstart'

class FileClient:

    def __init__(self):
        credentials = self._get_credentials()
        http = credentials.authorize(httplib2.Http())
        self.service = discovery.build('drive', 'v3', http=http)

    def _get_credentials(self):
        """Gets valid user credentials from storage.

        If nothing has been stored, or if the stored credentials are invalid,
        the OAuth2 flow is completed to obtain the new credentials.

        Returns:
            Credentials, the obtained credential.
        """
        home_dir = os.path.expanduser('~')
        credential_dir = os.path.join(home_dir, '.credentials')
        if not os.path.exists(credential_dir):
            os.makedirs(credential_dir)
        credential_path = os.path.join(credential_dir,
                                    'drive-python-quickstart.json')

        store = Storage(credential_path)
        credentials = store.get()
        if not credentials or credentials.invalid:
            flow = client.flow_from_clientsecrets(CLIENT_SECRET_FILE, SCOPES)
            flow.user_agent = APPLICATION_NAME
            credentials = tools.run_flow(flow, store)
            print('Storing credentials to ' + credential_path)
        return credentials
    
    def list_recent(self):
        """Shows basic usage of the Google Drive API.

        Creates a Google Drive API service object and outputs the names and IDs
        for up to 10 files.
        """
        results = self.service.files().list(
            pageSize=10, fields="nextPageToken, files(id, name)").execute()
        items = results.get('files', [])
        if not items:
            print('No files found.')
        else:
            print('Files:')
            for item in items:
                print(item['name'].encode('utf-8'), item['id'])

    def show_about(self):
        about = self.service.about().get(fields="user").execute()
        print(about)

    def read(self, path):
        file_id = self.get_file_id(path)
        # 只能用export, 使用get_media会提示只能下载二进制文件
        request = self.service.files().export(fileId=file_id, mimeType='text/plain')
        fh = io.BytesIO()
        downloader = MediaIoBaseDownload(fh, request)
        done = False
        while not done:
            status, done = downloader.next_chunk()
        
        fh.seek(io.SEEK_SET)
        return fh.read()

    def write(self, path, content):
        media = MediaIoBaseUpload(io.BytesIO(content), mimetype='text/plain')        
        file_id = self.get_file_id(path)
        if file_id:
            self.service.files().update(fileId=file_id, media_body=media).execute()
        else:
            file_metadata = {'name': os.path.basename(path)}
            self.service.files().create(media_body=media, body=file_metadata).execute()

    def get_file_id(self, path):
        query = "name='%s' and not trashed" % path
        results = self.service.files().list(
            orderBy='createdTime',
            q=query,
            fields="files(id, name)").execute()
        items = results.get('files', [])
        if items:
            for item in items:
                print(item['name'].encode('utf-8'), item['id'])
            return items[0]['id']

    def out_pemission(self, path):
        file_id = self.get_file_id(path)
        result = self.service.permissions().list(fileId=file_id).execute()
        print(result)

    def list(self, dir):
        pass

cl = FileClient()
# cl.out_pemission('foo.txt')
# cl.show_about()
# cl.list_recent()
# print(cl.read('foo.txt'))

path = 'foo.txt'
content = 'Hello World'
cl.write(path, content)

result = cl.read(path)
open(path, 'w').write(result)
