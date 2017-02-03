#!/usr/bin/perl
use JSON;
use Paytm::PaytmConstants;
use Paytm::PaytmEncDec;
my %requestData1;
tie %requestData1, 'Tie::IxHash';
my %request;
tie %request, 'Tie::IxHash';
use HTTP::Request::Common;
use Time::HiRes qw(gettimeofday);

my $timestamp = int (gettimeofday * 1000);
$userKey ="fadkavor570bjhgv9rzbznqqtnke8g6h";
$macKey="izj8tztu7onqy90fym8amcdfgloh216e";
$applicationType="application/json";
$currentTime = $timestamp;
$nonce=$currentTime;
my $key =Paytm::PaytmConstants::MERCHANT_KEY; 


$request{"requestType"}="VERIFY";
$request{"merchantGuid"}= Paytm::PaytmConstants::MERCHANTGUID;
$request{"merchantOrderId"}= "vidisha1234";
$request{"salesWalletName"}=undef;
$request{"salesWalletGuid"}=Paytm::PaytmConstants::WALLETGUID;
$request{"payeeEmailId"}=undef;
$request{"payeePhoneNumber"}="9999999999";
$request{"payeeSsoId"}="";
$request{"appliedToNewUsers"}="Y";
$request{"amount"}="1";
$request{"currencyCode"}="INR";
$requestData1{"request"} = \%request;
        $requestData1{"metadata"} ="Testing Data";
        $requestData1{"ipAddress"}="127.0.0.1";
        $requestData1{"platformName"}="PayTM";
        $requestData1{"operationType"}="SALES_TO_USER_CREDIT";


$requestData = encode_json \%requestData1;
print "$requestData\n";
my $checksum=Paytm::PaytmEncDec::getChecksumFromArray($key,$$requestData);
my %hmacHeaders = (
	             'Content-Type' => 'application/json',
		     'mid' => Paytm::PaytmConstants::MERCHANTGUID,
		     'checksumhash' => $checksum
	          );

my  %headerValue;
$i = 0;


foreach my $key ( keys %hmacHeaders )
{
  $val = $key.':'.$hmacHeaders{$key};
  $headerValue{$i} = $val;
  $i +=1;
};
 
use LWP::UserAgent;
 
my $ua = LWP::UserAgent->new;
my $req = POST 'http://trust-uat.paytm.in/wallet-web/salesToUserCredit';
foreach my $key ( keys %hmacHeaders )
{
  $ua->default_header($key  => $hmacHeaders{$key});
}


$req->content_type("application/json");
$req->content($requestData);
 
my $resp = $ua->request($req);
if ($resp->is_success) {
  my $message = $resp->decoded_content;
  print "Received reply: $message\n";
}
else {
  print "HTTP POST error code: ", $resp->code, "\n";
  print "HTTP POST error message: ", $resp->message, "\n";
}
