/**
 * Created by Palanikumar.Raju on 21/01/2020.
 * Description: This is the test class for TransactionItemTrigger
 */

@IsTest
private class TransactionItemTriggerTest
{
	@IsTest
	private static void testTransactionItemTrigger ()
	{
		// Create test Transaction
		Transaction__c newTransaction = new Transaction__c();
		newTransaction.Name = 'Test Transaction';
		newTransaction.Total_Cost_c__c = 100.00;
		newTransaction.Total_Discount_c__c = 10.00;
		newTransaction.Transaction_Count_c__c = 1;
		insert newTransaction;

		// Create test Transaction Item and relate to the Transaction created
		TransactionItem__c newTransactionItem = new TransactionItem__c(
				Name = 'Test Name1',
				Item_Cost_c__c = 20.00,
				Transaction__c = newTransaction.Id);

		List<TransactionItem__c> transactionItemsList = new List <TransactionItem__c>();
		transactionItemsList.add(newTransactionItem);

		Test.startTest();
		Database.SaveResult[] newTransactionSaveResults = Database.insert(transactionItemsList, false);
		Test.stopTest();
	}
}