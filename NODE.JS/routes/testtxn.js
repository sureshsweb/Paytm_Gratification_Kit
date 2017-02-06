var checksum = require('../model/checksum');
var http = require('http');
var request = require('request');

module.exports = function (app) {

 app.get('/', function(req,res){
console.log("--------vidi----");
var samarray = new Array();

samarray = 
{"request":
{"requestType":"VERIFY",
"merchantGuid":"XXXXXXXXXXXXXXXXXXXXXXXXXXX",
"merchantOrderId":"ORDS33954359",
"salesWalletName":null,
"salesWalletGuid":"XXXXXXXXXXXXXXXXXXXXXXXXXXX",
"payeeEmailId":null,
"payeePhoneNumber":"9711139557",
"payeeSsoId":"",
"appliedToNewUsers":"Y",
"amount":"1",
"currencyCode":"INR"},
"metadata":"Testing Data",
"ipAddress":"127.0.0.1",
"platformName":"PayTM",
"operationType":"SALES_TO_USER_CREDIT"};


var finalstring = JSON.stringify(samarray);
 checksum.genchecksumbystring(finalstring, "XXXXXXXXXXXX", function (err, result) 
        {
            request({
            url: 'http://trust-uat.paytm.in/wallet-web/salesToUserCredit', //URL to hit
          //  qs: finalstring, //Query string data
            method: 'POST',
            headers: {
                    'Content-Type': 'application/json',
                    'mid': 'XXXXXXXXXXXXXXXXXXXXXXXXXXX',
                    'checksumhash': result
                     },
            body: finalstring//Set the body as a string
            }, function(error, response, body){
            if(error) {
                console.log(error);
            } else {
                console.log(response.statusCode, body);
                   res.send(body);
            }
                });
        });
  });
// vidisha code finish
};
