/**
 * Created by Palanikumar.Raju on 23/01/2020.
 * Description: This is the test class for SendTransactionData class
 */

@IsTest
private class SendTransactionDataTest {

	// Test getTransactionItems method
	@IsTest
	private static void testGetTransactionItems()
	{
		// Create test Transaction
		Transaction__c newTransaction = new Transaction__c();
		newTransaction.Name = 'Test Transaction';
		newTransaction.Total_Cost_c__c = 100.00;
		newTransaction.Total_Discount_c__c = 10.00;
		newTransaction.Transaction_Count_c__c = 2;
		insert newTransaction;

		List<Id> transactionIdList = new List<Id>();
		transactionIdList.add(newTransaction.Id);

		// Create test Transaction Items and relate to the Transaction created
		TransactionItem__c newTransactionItem1 = new TransactionItem__c(
				Name = 'Test Name1',
				Item_Cost_c__c = 20.00,
				Transaction__c = newTransaction.Id);

		TransactionItem__c newTransactionItem2 = new TransactionItem__c(
				Name = 'Test Name2',
				Item_Cost_c__c = 20.00,
				Transaction__c = newTransaction.Id);

		List<TransactionItem__c> transactionItemsList = new List <TransactionItem__c>();
		transactionItemsList.add(newTransactionItem1);
		transactionItemsList.add(newTransactionItem2);
		insert transactionItemsList;

		Id transactionId = newTransaction.Id;

		// Get Transaction Items payload
		String requestString = SendTransactionData.getTransactionItems(transactionItemsList);
		String expectedRequest = '{  "transactionItems" : [ {    "keys" : {      "TransactionItemID" : "' +  newTransactionItem1.Id +  '"    },    "values" : {      "ItemCost" : "' +  newTransactionItem1.Item_Cost_c__c +  '",      "ItemName" : "' +  newTransactionItem1.Name +  '"    }  }, {    "keys" : {      "TransactionItemID" : "' +  newTransactionItem2.Id +  '"    },    "values" : {      "ItemCost" : "' +  newTransactionItem2.Item_Cost_c__c +  '",      "ItemName" : "' +  newTransactionItem2.Name +  '"    }  } ]}';

		// Assert if the payload is as expected based on the test data
		System.assertequals(expectedRequest,requestString.replaceAll('\n', '').replaceAll('\r',''));
	}

	// Test getTransaction method
	@IsTest
	private static void testGetTransaction()
	{
		// Create test Transaction
		Transaction__c newTransaction = new Transaction__c();
		newTransaction.Name = 'Test Transaction';
		newTransaction.Total_Cost_c__c = 100.00;
		newTransaction.Total_Discount_c__c = 10.00;
		newTransaction.Transaction_Count_c__c = 1;
		insert newTransaction;
		String todayDateString = Datetime.now().format('yyyy-MM-dd', 'America/Los_Angeles');
		Date transactionDate = Date.valueOf(newTransaction.CreatedDate);

		// Get Transaction payload
		String requestString = SendTransactionData.getTransaction(newTransaction, todayDateString);
		String expectedRequest = '{  "keys" : {    "TransactionID" : "' +  newTransaction.Id +  '"  },  "values" : {    "TotalCost" : "' +  newTransaction.Total_Cost_c__c +  '",    "TotalDiscount" : "' +  newTransaction.Total_Discount_c__c +  '",    "TransactionDate" : "' +  todayDateString +  '"  }}';

		// Assert if the payload is as expected based on the test data
		System.assertequals(expectedRequest,requestString.replaceAll('\n', '').replaceAll('\r',''));
	}

	// Test sendTransactionDetails method
	@IsTest
	private static void testSendTransactionDetails()
	{
		// Create test Transaction
		Transaction__c newTransaction = new Transaction__c();
		newTransaction.Name = 'Test Transaction';
		newTransaction.Total_Cost_c__c = 100.00;
		newTransaction.Total_Discount_c__c = 10.00;
		newTransaction.Transaction_Count_c__c = 1;
		insert newTransaction;

		List<Id> transactionIdList = new List<Id>();
		transactionIdList.add(newTransaction.Id);

		// Create test Transaction Item and relate to the Transaction created
		TransactionItem__c newTransactionItem = new TransactionItem__c(
				Name = 'Test Name1',
				Item_Cost_c__c = 20.00,
				Transaction__c = newTransaction.Id);

		List<TransactionItem__c> transactionItemsList = new List <TransactionItem__c>();
		transactionItemsList.add(newTransactionItem);
		insert transactionItemsList;

		// Send Transaction and Transaction Items to external system
		Boolean isSendTransactionSuccess = SendTransactionData.sendTransactionDetails(transactionIdList);

		// Asset if Transaction details posted successfully
		System.assertEquals(true, isSendTransactionSuccess);

	}

	// Test sendTransaction method
	@IsTest
	private static void testSendTransaction()
	{
		String endPoint = 'https://postman-echo.com/post';
		String payLoad = '{ "keys": { "TransactionID": "a052v00000oMrXWAA0"}, "values": { "Name": "Test Transaction"}}';
		Boolean httpCallStatus = SendTransactionData.sendTransaction(endPoint, payLoad);
		System.assertEquals(true, httpCallStatus);
	}



}