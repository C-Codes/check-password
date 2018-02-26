#!/usr/bin/env python

import requests
import hashlib

# read password from commandline
def read_pswd():
    from getpass import getpass
    return getpass()

# return upper case sha1 hex digest of 'v'
def sha1(v):
    return hashlib.sha1(v).hexdigest().upper()

def query_hibp(v_sha1):
    query_s = v_sha1[:5]
    request_s = str("https://api.pwnedpasswords.com/range/"+query_s)
    print("Sending request: {}".format(request_s))
    r = requests.get(request_s)
    print("Looking for: ({0}) + {1}".format(query_s, v_sha1[5:]))
    if (v_sha1[5:] in r.text):
        # remove the first value: `\ufeff`
        map_v = {h.split(':')[0]:h.split(':')[1] for h in r.text[1:].split('\r\n')}
        return map_v[v_sha1[5:]]
    return 0

if __name__ == "__main__":
    p = read_pswd()
    s = sha1(p.encode())
    p = ""
    count = query_hibp(s)
    print("Your Password was found {} times.".format(count))
    exit(count)
