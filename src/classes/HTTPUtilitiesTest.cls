/**
 * Created by Palanikumar.Raju on 23/01/2020.
 */

@IsTest
private class HTTPUtilitiesTest
{
	@IsTest
	private static void postData()
	{
		String requestJSON = '[{ "transactionItems": [ { "keys": {"TransactionItemID": "a042v00002MbKiZAAV"},"values": {"Name": "9"}}]';
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('TransactionMockup');
		mock.setStatusCode(201);
		mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);
		Test.startTest();
		Integer httpStatus = HTTPUtilities.postData('https://abc.com/Post', requestJSON);
		//Integer statusCode = HTTPUtilities.postData('https://postman-echo.com/post', requestJSON);
		Test.stopTest();
		System.assertEquals(httpStatus, 201);
	}
}