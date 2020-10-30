curl -i -k -s -X POST https://ecs.cn-north-1.myhuaweicloud.com/v1/ae91ef3c6abd4e13a198d19c9e900a16/cloudservers/delete -H "Content-Type:application/json;charset=UTF-8" -H "X-Auth-Token:$user_token" -d '{"servers":[{"id":"e05b0080-2c72-4a52-b9b3-0ede76975070"}],"delete_publicip":"false", "delete_volume":"false"}'

