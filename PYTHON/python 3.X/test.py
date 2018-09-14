#!/usr/bin/python

import time
import Checksum
import base64
import requests
import json
from collections import OrderedDict
import pycurl


applicationType="application/json"
currentTime= int(round(time.time() * 1000))
MERCHANT_KEY = 'xxxxxxxxxxxxxxxxxx';
nonce=currentTime

requestData1=OrderedDict([("request",OrderedDict([("requestType","VERIFY"),("merchantGuid","XXXXXXXXXXXXXXXXXXXXXXXXXXX"),("merchantOrderId","12121236666"),("salesWalletName", None),("salesWalletGuid","XXXXXXXXXXXXXXXXXXXXXXXXXXX"),("payeeEmailId", None),("payeePhoneNumber","9711139557"),("payeeSsoId",""),("appliedToNewUsers","Y"),("amount","1"),("currencyCode","INR")])),("metadata","Testing Data"),("ipAddress","127.0.0.1"),("platformName","PayTM"),("operationType","SALES_TO_USER_CREDIT")])
requestData = json.dumps(requestData1, separators=(',', ':'))

checksum = Checksum.generate_checksum_by_str(requestData1, MERCHANT_KEY)
hmacHeaders = {
        'Content-Type':'application/json',
        'mid':'XXXXXXXXXXXXXXXXXXXXXXXXXXX',
        'checksumhash' : checksum
   	 }

i = 0
headerValue = []  
for (key, value) in hmacHeaders.items():
    val = str(key)+':'+str(value)
    headerValue.insert(i,val)
    i += 1

print(headerValue)

c = pycurl.Curl() 
c.setopt(c.URL, 'http://trust-uat.paytm.in/wallet-web/salesToUserCredit')
c.setopt(c.POST, 1)
c.setopt(c.POSTFIELDS,requestData)
c.setopt(c.HTTPHEADER,headerValue)
c.perform()


print(c.getinfo(c.HTTP_CODE))
c.close()
