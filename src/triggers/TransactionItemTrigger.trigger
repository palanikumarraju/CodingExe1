/**
 * Created by Palanikumar.Raju on 21/01/2020.
 * Description: This trigger is to post the Transaction and Transaction Item details
 */

trigger TransactionItemTrigger on TransactionItem__c (after insert)
{
	// Get list of Transaction Items created
	List<Id> listOfTransactionIds = new List<Id>();
	for (TransactionItem__c transactionItem : [SELECT Transaction__r.Id FROM TransactionItem__c WHERE Id IN :Trigger.new])
	{
		listOfTransactionIds.add(transactionItem.Transaction__r.Id);
	}

	Set<Id> transactionIdSet = new Set<Id>();
	List<Id> transactionIdList = new List<Id>();

	// Remove duplicate Transaction Ids
	transactionIdSet.addAll(listOfTransactionIds);
	transactionIdList.addAll(transactionIdSet);

	// Post Transaction and Transaction Item details
	Boolean isTransactionSent = SendTransactionData.sendTransactionDetails(transactionIdList);
}