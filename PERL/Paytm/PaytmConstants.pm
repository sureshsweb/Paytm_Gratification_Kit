package Paytm::PaytmConstants;
use constant ENVIRONMENT    => 'T';
use constant MERCHANT_KEY    => 'xxxxxxxxxxxxxxxxx';
use constant MERCHANTGUID    => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxx';
use constant WALLETGUID    => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';



if (ENVIRONMENT eq "P"){
  $paytm_pg_url = 'https://trust.paytm.in/wallet-web/salesToUserCredit';
}else{
	$paytm_pg_url = 'http://trust-uat.paytm.in/wallet-web/salesToUserCredit';
}


1;
