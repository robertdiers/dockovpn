from flask import Flask, make_response
import os
import time

app = Flask(__name__)

logfile = '/opt/dockovpn/openvpn-status.log'


@app.route('/metrics')
def metrics():
    returnvalue = ''

    # simply count the lines to get number of logged in devices

    # OpenVPN CLIENT LIST
    # Updated,2024-10-30 10:22:39
    # Common Name,Real Address,Bytes Received,Bytes Sent,Connected Since
    # testdevice,89.14.95.11:32885,5885,4044,2024-10-30 10:21:09
    # ROUTING TABLE
    # Virtual Address,Common Name,Real Address,Last Ref
    # 10.8.0.2,testdevice,89.14.95.11:32885,2024-10-30 10:21:17
    # GLOBAL STATS
    # Max bcast/mcast queue length,0
    # END
    num_lines = 0
    with open(logfile, "r") as f:
        num_lines = sum(1 for _ in f)

    returnvalue = 'connected_devices{name="' + os.environ['OVPN_NAME'] + '"} ' + str((num_lines - 8) / 2)
    response = make_response(returnvalue, 200)
    response.mimetype = "text/plain"
    return response


@app.route('/')
def content():
    content = open(logfile, 'r').read()
    filemodified = os.path.getmtime(logfile)
    returnvalue = logfile + ': ' + str(time.ctime(filemodified)) + '\n\n' + content
    response = make_response(returnvalue, 200)
    response.mimetype = "text/plain"
    return response


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
