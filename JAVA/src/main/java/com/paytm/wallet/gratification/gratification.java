package com.paytm.wallet.gratification;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
//import com.paytm.merchant.CheckSumServiceHelper;
import com.paytm.pg.merchant.CheckSumServiceHelper;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class gratification {
	public static String paytmGratificationTestUrl = "https://trust-uat.paytm.in/wallet-web/salesToUserCredit";
	public String paytmGratificationProdUrl = "https://trust.paytm.in/wallet-web/salesToUserCredit";
	public static String paytmMerchantGuid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
	public static String paytmSalesWalletGuid = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
	public static String paytmMerchantKey = "xxxxxxxxxxxxxxxx";
	
    public static String getJsonRequest(){
    	JsonObject mainBody = new JsonObject();
        JsonObject requestBody = new JsonObject();
    	
        requestBody.add("requestType",null);
        requestBody.add("merchantGuid", new JsonPrimitive(paytmMerchantGuid));
        requestBody.add("merchantOrderId",new JsonPrimitive("Order0000000001"));
        requestBody.add("salesWalletName",null);
        requestBody.add("salesWalletGuid",new JsonPrimitive(paytmSalesWalletGuid));
        requestBody.add("payeeEmailId",null);
        requestBody.add("payeePhoneNumber",new JsonPrimitive("9999999999"));
        requestBody.add("payeeSsoId",new JsonPrimitive(""));
        requestBody.add("appliedToNewUsers",new JsonPrimitive("Y"));
        requestBody.add("amount",new JsonPrimitive("1"));
        requestBody.add("currencyCode",new JsonPrimitive("INR"));
        
        
        mainBody.add("request", requestBody);
        mainBody.add("metadata", new JsonPrimitive("Testing Data"));
        mainBody.add("ipAddress", new JsonPrimitive("192.168.0.1"));
        mainBody.add("platformName", new JsonPrimitive(""));
        mainBody.add("operationType", new JsonPrimitive("SALES_TO_USER_CREDIT"));
        String jsonRes = new Gson().toJson(mainBody).toString();
    	return jsonRes;
    }
    
    
    public static String gratificationRequest(String targetURL) throws Exception {
    	HttpURLConnection connection = null;
		URL url = new URL(targetURL);
		String requestBody = getJsonRequest();

		connection = (HttpURLConnection)url.openConnection();
		connection.setRequestMethod("POST");

		String CHECKSUMHASH =  CheckSumServiceHelper.getCheckSumServiceHelper().genrateCheckSum(paytmMerchantKey, requestBody.toString());
		System.out.println(CHECKSUMHASH);
                   
		try {	
			connection = (HttpURLConnection) url.openConnection();
			connection.setRequestProperty("Content-Type","application/json");
			connection.setRequestProperty("mid", paytmMerchantGuid);
            connection.setRequestProperty("checksumhash",CHECKSUMHASH);
	        connection.setRequestProperty("Content-Length", Integer.toString(requestBody.getBytes().length));
            connection.setUseCaches(false);
			connection.setDoOutput(true);
			
            DataOutputStream wr = new DataOutputStream (connection.getOutputStream());
			wr.writeBytes(requestBody);
			wr.close();
		
			InputStream is;
			try{
				is = connection.getInputStream();
			}catch(Exception e){
				is = connection.getErrorStream();
			}
			
			BufferedReader rd = new BufferedReader(new InputStreamReader(is));
			int statusCode = connection.getResponseCode();
			System.out.println("The http header code is = " +statusCode);         
			StringBuilder response = new StringBuilder();
			String line="";
			while((line = rd.readLine()) != null) {
				response.append(line);
				response.append('\r');
			}
			rd.close();
            System.out.println("This is response string= " +response);
            return response.toString();
		} catch (Exception e) {
			System.out.println("This is response string= " +e.getMessage());
		}  finally {
			if(connection != null) {
				connection.disconnect(); 
			}
		}
		return "";
	}


    public static void main( String[] args ) throws Exception
    {
    	gratificationRequest(paytmGratificationTestUrl);
    }

}
