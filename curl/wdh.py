#coding=utf-8
import commands
import json
import os
import sys
import string

name = "xxxxxxxxxxxxxx"
user = "xxxxxxxxxxxxxxx"
password = "xxxxxxxxxxxxxxx"
project_id = "xxxxxxxxxxxxxx"
vm_id = "xxxxxxxxxxxxxx"


url_iam = "https://iam.cn-north-1.myhuaweicloud.com/v3/auth/tokens"
url_vm_start = "https://ecs.cn-north-3.myhuaweicloud.com/v1/"+project_id+"/cloudservers/action"
def get_user_token():
    cmd_user_token = 'curl -i -k -s -X POST '+url_iam+ \
                     ' -H "Content-Type:application/json;charset=UTF-8"'\
                     ' -d \'{"auth":{"identity":{ '\
                     '"methods":["password"],'\
                     '"password":{"user":{"name":"'+user+'",'\
                     '"password":"'+password+'",'\
                     '"domain":{"name":"'+name+'"}}}},'\
                     '"scope":{"project":{"name":"cn-north-3"}}}}\''\
                     '|grep X-Subject-Token|awk {\'print $2\'}'

    user_token = commands.getoutput(cmd_user_token)
    if len(user_token) == 0:
        print ("get token fail")
    else:
        return user_token

def vm_start(user_token):
    cmd_vm_start = 'curl -i -k -s -X POST '+url_vm_start+ \
            ' -H "Content-Type:application/json;charset=UTF-8"'\
            ' -H "X-Auth-Token:'+user_token+\
            '" -d \'{"os-start":{"servers": [{"id":"'+vm_id+'"}]}}\'|grep job_id'
    vm_start_job = commands.getoutput(cmd_vm_start)
    if len(vm_start_job) == 0:
        print ("get start fail")
    else:
        return vm_start_job

def vm_stop(user_token):
    cmd_vm_stop = 'curl -i -k -s -X POST '+url_vm_start+ \
                    ' -H "Content-Type:application/json;charset=UTF-8"'\
                    ' -H "X-Auth-Token:'+user_token+\
                    '" -d \'{"os-stop":{"type":"HARD","servers":[{"id":"'+vm_id+'"}]}}\'|grep job_id'
    vm_stop_job = commands.getoutput(cmd_vm_stop)
    if len(vm_stop_job) == 0:
        print ("get stop fail")
    else:
        return vm_stop_job

def vm_start_ing():
    user_token = get_user_token()
    vm_start_job = vm_start(user_token)
    print (vm_start_job)
def vm_stop_ing():
    user_token = get_user_token()
    vm_stop_job = vm_stop(user_token)
    print (vm_stop_job)

def main():
    print ("""
        功能菜单
        1.虚拟机开机
        2.虚拟机关机
        0.退出
        """
        )
    youinput = int(raw_input("Input num is:"))
    if youinput == 1:
        vm_start_ing()
    elif youinput == 2:
        vm_stop_ing()
    elif youinput == 3:
         exit()
if __name__ == '__main__':
    main()
