cmd_user_token = 'curl -i -k -s -X POST '\
                  'https://iam.cn-north-1.myhuaweicloud.com/v3/auth/tokens' \
                  '-H "Content-Type:application/json;charset=UTF-8"' \
                  '-d \'{"auth":{"identity":{"methods":["password"],'\
                  '"password":{"user":{"name":"user","password":"password",'\
                  '"domain":{"name":"user"}}}},"scope":{"project":{"name":"cn-north-1"}}}}\''\
                  '|grep X-Subject-Token|awk {\'print $2\'}'




reschedule_url = "https://xxxxxxx"
INSTANCE_UUID = "12413513636366"
tenant_name = "xxxxxxxxxxxxxxxxx"
TOKEN_ID = "xxxxxxxxxxxxxxxxxxxxxx"


reschedule_cmd = 'curl -i --insecure \"%s/servers/%s/action\" ' \
                    '-X POST -H \"X-Auth-Project-Id: %s\" -H ' \
                    '\"X-Auth-Token: %s\" -H \"Content-Type: application/json\"' \
                    ' -H \"Accept: application/json\" ' \
                    '-H \"User-Agent: python-novaclient\" ' \
                    '-d \'{\"reschedule\": null}\'' \
                    % (reschedule_url, INSTANCE_UUID, tenant_name, TOKEN_ID)



print cmd_user_token
print "########################################"
print reschedule_cmd
