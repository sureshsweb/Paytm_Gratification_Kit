package Paytm::PaytmConstants;
use constant ENVIRONMENT    => 'T';
use constant MERCHANT_KEY    => 'kbzk1DSbJiV_O3p5';
use constant MERCHANTGUID    => '813FA430-038A-11E5-AADC-3CD92BEE4FB0';
use constant WALLETGUID    => '5E22F85F-AC39-47A5-9EBA-585B54B66623';



if (ENVIRONMENT eq "P"){
  $paytm_pg_url = 'https://trust.paytm.in/wallet-web/salesToUserCredit';
}else{
	$paytm_pg_url = 'http://trust-uat.paytm.in/wallet-web/salesToUserCredit';
}


1;
