import commands
import json
import os
import sys
import string


user = "xxxxxx"
password = "xxxxxxxx"

def get_user_token():
    cmd_user_token = 'curl -i -k -s -X POST https://iam.cn-north-1.myhuaweicloud.com/v3/auth/tokens \
                      -H "Content-Type:application/json;charset=UTF-8" -d \'{"auth":{"identity":{ \
                      "methods":["password"],"password":{"user":{"name":"'+user+'","password":"'+password+'",\
                      "domain":{"name":"'+user+'"}}}},"scope":{"project":{"name":"cn-north-1"}}}}\'\
                      |grep X-Subject-Token|awk {\'print $2\'}'

    user_token = commands.getoutput(cmd_user_token)
    if len(user_token) == 0:
        print "get token fail"
    else:
        return user_token
a = get_user_token()
