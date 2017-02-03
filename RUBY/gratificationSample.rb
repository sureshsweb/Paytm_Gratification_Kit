#!C:\Ruby22-x64\bin\ruby.exe
puts "Content-type: text/html"
puts ""

require './paytm/encryption_new_pg.rb'
require 'openssl'
require 'base64'
require 'digest'
require 'securerandom'
require 'json'
require 'net/http'

include EncryptionNewPG
  
PAYTM_MERCHANT_KEY = "xxxxxxxxxxxxxxxx"
PAYTM_SALES_WALLET_GUID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
PAYTM_MERCHANT_GUID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
PAYTM_GRATIFICATION_URL_TEST = "https://trust-uat.paytm.in/wallet-web/salesToUserCredit"
PAYTM_GRATIFICATION_URL_PROD = "https://trust.paytm.in/wallet-web/salesToUserCredit"

dataArray = {"request" => {	"requestType" => "",
							"merchantGuid" => PAYTM_MERCHANT_GUID,
							"merchantOrderId" => "1212123",
							"salesWalletName" => nil,
							"salesWalletGuid" => PAYTM_SALES_WALLET_GUID,
							"payeeEmailId" => nil,
							"payeePhoneNumber" => "9999999999",
							"payeeSsoId" => "",
							"appliedToNewUsers" => "Y",
							"amount" => "1",
							"currencyCode" => "INR"
						  },
			 "metadata" => "Testing Data",
			 "ipAddress" => "127.0.0.1",
			 "platformName" => "PayTM",
			 "operationType" => "SALES_TO_USER_CREDIT"}
		 
requestData = dataArray.to_json		

checksum_hash = new_pg_checksum_by_str(requestData, PAYTM_MERCHANT_KEY).gsub("\n",'')

gratificationHeaders = {'Content-Type' => 'application/json', 'mid' => PAYTM_MERCHANT_GUID, 'checksumhash' => checksum_hash }

#sample
uri = URI(PAYTM_GRATIFICATION_URL_TEST)
http = Net::HTTP.new(uri.host, uri.port)
resp = http.post(uri.path, requestData, gratificationHeaders)
puts resp.body
