import requests
httpurl = "http://tongs.ca//ReceiveData.php//"
httpRequestData = {'api_key':'tPmAT5Ab3j7F9','sensor':'BME280','location':'Office','value1':'24.75','value2':'49.54','value3':'1005.14'}
r = requests.post(url=httpurl, data=httpRequestData)
print(r)
