/**
 * Created by Palanikumar.Raju on 23/01/2020.
 * Description: This class is to post Transaction details to external system.
 */
public with sharing class SendTransactionData
{
	// This method to build the payloads for Transactions and Transaction Items and post them to external system
	public static Boolean sendTransactionDetails(List<Id> transactionIdList)
	{
		Boolean isTransactionItemSuccess = false;
		Boolean isTransactionSuccess = false;

		// Get the scope of Transactions and loop to process them
		for (Transaction__c newTransaction : [SELECT Id, Name, Total_Discount_c__c, Total_Cost_c__c, CreatedDate,
				Transaction_Count_c__c, (SELECT Name, Item_Cost_c__c FROM Transaction_Items__r) FROM Transaction__c
				WHERE Id = :transactionIdList])
		{
			List<TransactionItem__c> transactionItemLst = newTransaction.Transaction_Items__r;

			// Check if the transaction count at the Transaction and # of Transaction Items for that transaction
			if (newTransaction.Transaction_Count_c__c == transactionItemLst.size())
			{
				String transactionPayload;
				// Get request payload for Transaction Items
				String transactionItemsPayload = getTransactionItems(transactionItemLst);

				if (transactionItemsPayload != null)
				{
					//Post Transaction Items to external system
					isTransactionItemSuccess = sendTransaction('https://postman-echo.com/post', transactionItemsPayload);
					isTransactionItemSuccess = true;
					if (isTransactionItemSuccess)
					{
						Date transactionDate = Date.valueOf(newTransaction.CreatedDate);

						// Get request payload for Transaction
						transactionPayload = getTransaction(newTransaction, String.valueOf(transactionDate));
						if (transactionPayload != null)
						{
							//Post Transaction to external system
							isTransactionSuccess = sendTransaction('https://postman-echo.com/post', transactionPayload);
							isTransactionSuccess = true;
						}
					}
				}
			}
		}
		return isTransactionSuccess;
	}

	// This method is to post the request to the external system.
	public static Boolean sendTransaction(String endPoint, String transactionItemsPayload)
	{
		// Note: below line of code is commented purposefully not to call the external system. Also, response hardcoded.
		//Integer statusCode = HTTPUtilities.postData(endPoint, transactionItemsPayload);
		Integer statusCode = 200;
		if (statusCode == 200)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	// This method is to build the request payload for Transaction
	public static String getTransaction(Transaction__c transactionObj, String transactionDate)
	{
		try
		{
			String transactionRequestString;

			// Build request payload for Transaction
			JSONGenerator transactionRequestJson = JSON.createGenerator(true);
			transactionRequestJson.writeStartObject();
			transactionRequestJson.writeFieldName('keys');
			transactionRequestJson.writeStartObject();
			transactionRequestJson.writeObjectField('TransactionID', transactionObj.Id);
			transactionRequestJson.writeEndObject();
			transactionRequestJson.writeFieldName('values');
			transactionRequestJson.writeStartObject();
			transactionRequestJson.writeObjectField('TotalCost', String.valueOf(transactionObj.Total_Cost_c__c));
			transactionRequestJson.writeObjectField('TotalDiscount', String.valueOf(transactionObj.Total_Discount_c__c));
			transactionRequestJson.writeObjectField('TransactionDate', transactionDate);
			transactionRequestJson.writeEndObject();
			transactionRequestJson.writeEndObject();

			transactionRequestString = transactionRequestJson.getAsString();
			return transactionRequestString;
		}
		catch(Exception expection)
		{
			throw expection;
		}
	}

	// This method is to build the request payload for Transaction Items
	public static String getTransactionItems(List<TransactionItem__c> transactionItemLst)
	{
		try
		{
			List<String> transactionItemList = new List<String>();
			String transactionItemRequestString;
			String transactionItemString;

			// Build request payload for Transaction Items
			JSONGenerator transactionItemJson = JSON.createGenerator(true);
			transactionItemJson.writeStartObject();
			transactionItemJson.writeFieldName('transactionItems');
			transactionItemJson.writeStartArray();

			for(TransactionItem__c transactionItem :transactionItemLst)
			{
				transactionItemJson.writeStartObject();
				transactionItemJson.writeFieldName('keys');
				transactionItemJson.writeStartObject();
				transactionItemJson.writeObjectField('TransactionItemID', transactionItem.Id);
				transactionItemJson.writeEndObject();
				transactionItemJson.writeFieldName('values');
				transactionItemJson.writeStartObject();
				transactionItemJson.writeObjectField('ItemCost', String.valueOf(transactionItem.Item_Cost_c__c));
				transactionItemJson.writeObjectField('ItemName', transactionItem.Name);
				transactionItemJson.writeEndObject();
				transactionItemJson.writeEndObject();
			}
			transactionItemJson.writeEndArray();
			transactionItemJson.writeEndObject();
			transactionItemRequestString = transactionItemJson.getAsString();

			return transactionItemRequestString;
		}
		catch(Exception expection)
		{
			throw expection;
		}
	}
}