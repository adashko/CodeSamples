global class ContactSubStatusUpdateBatch implements Database.Batchable<sObject> {

	private final List<String> toAddresses = new List<String> {'yourmail@mail.com'};
	global Id contactId;


	private final static String SUBSCRIPTION_INACTIVE_STATUS = 'Inactive';
	private final static String SUBSCRIPTION_ACTIVE_STATUS = 'Active';
	private final static String SUBSCRIPTION_EXPIRED_STATUS = 'Expired';
	
	global ContactSubStatusUpdateBatch() {
		// empty
	}

	global ContactSubStatusUpdateBatch(Id testContactId) {
		contactId = testContactId;
	}

	
	global Database.QueryLocator start(Database.BatchableContext bc) {
		String queryString = 'SELECT Id, Subscription_Start__c, Subscription_End__c, Subscription_Is2__c FROM Contact WHERE Subscription_Is2__c != null';
		if (contactId != null) { // only for test 
			queryString += ' AND Id = :contactId';
		}
		System.debug('queryString:' + queryString);
		return Database.getQueryLocator(queryString);
	}
	
	global void execute(Database.BatchableContext BC, List<Contact> scope) {
		Date todayDate = Date.today();
		// Update contact Subscription status
		for (Contact cont: scope) {
			if (cont.Subscription_Start__c <= todayDate && cont.Subscription_End__c >= todayDate) {
				cont.Subscription_Is2__c = SUBSCRIPTION_ACTIVE_STATUS;
			} else {
				if (cont.Subscription_Start__c > todayDate) {
					cont.Subscription_Is2__c = SUBSCRIPTION_INACTIVE_STATUS;
				}
				if (cont.Subscription_End__c < todayDate) {
					cont.Subscription_Is2__c = SUBSCRIPTION_EXPIRED_STATUS;
				}
			}
		}

		update scope;
	}

	global void finish(Database.BatchableContext BC) {
		AsyncApexJob a = [
			SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
				TotalJobItems, CreatedBy.Email
			FROM AsyncApexJob WHERE Id = :BC.getJobId()];
   
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses(toAddresses);
		mail.setSubject('Contact Subscription Update Batch ' + a.Status);
		mail.setPlainTextBody(
			'The batch Apex job processed ' + a.TotalJobItems +
			' batches with '+ a.NumberOfErrors + ' failures.');
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
	}
}