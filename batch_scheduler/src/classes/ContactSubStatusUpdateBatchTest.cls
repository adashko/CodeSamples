@isTest
private class ContactSubStatusUpdateBatchTest {
    @isTest
	private static void testBatch() {
		// generate test data
		Account testAccount = new Account(
			Name = 'testAccount'
		);
		insert testAccount;

		Contact testInactiveContact = new Contact(
			AccountId = testAccount.Id,
			LastName = 'InactiveContact', 
			Subscription_Status__c = 'ANY_STATUS',
			Subscription_Start__c = Date.today().addDays(1),
			Subscription_End__c = Date.today().addDays(2)
		);
		insert testInactiveContact;

		Contact testActiveContact = new Contact(
			AccountId = testAccount.Id,
			LastName = 'InactiveContact', 
			Subscription_Status__c = 'ANY_STATUS',
			Subscription_Start__c = Date.today().addDays(-1),
			Subscription_End__c = Date.today().addDays(1)
		);
		insert testActiveContact;

		Contact testExpiredContact = new Contact(
			AccountId = testAccount.Id,
			LastName = 'InactiveContact', 
			Subscription_Status__c = 'ANY_STATUS',
			Subscription_Start__c = Date.today().addDays(-2),
			Subscription_End__c = Date.today().addDays(-1)
		);
		insert testExpiredContact;

		// Run batch without parameters
		Test.startTest();
			Database.executeBatch(new ContactSubStatusUpdateBatch());
		Test.stopTest();

		System.equals('Inactive', [SELECT Subscription_Status__c FROM Contact WHERE Id = :testInactiveContact.Id].Subscription_Status__c);
		System.equals('Active', [SELECT Subscription_Status__c FROM Contact WHERE Id = :testActiveContact.Id].Subscription_Status__c);
		System.equals('Expired', [SELECT Subscription_Status__c FROM Contact WHERE Id = :testExpiredContact.Id].Subscription_Status__c);
	} 

	@isTest
	private static void testOnBatch() {

		// generate test data
		Account testAccount = new Account(
			Name = 'testAccount'
		);
		insert testAccount;

		Contact testInactiveContact = new Contact(
			AccountId = testAccount.Id,
			LastName = 'InactiveContact', 
			Subscription_Status__c = 'ANY_STATUS',
			Subscription_Start__c = Date.today().addDays(1),
			Subscription_End__c = Date.today().addDays(2)
		);
		insert testInactiveContact;

		// Run batch with ContactId parameter

		Test.startTest();
			Database.executeBatch(new ContactSubStatusUpdateBatch(testInactiveContact.Id));
		Test.stopTest();

		System.equals('Inactive', [SELECT Subscription_Status__c FROM Contact WHERE Id = :testInactiveContact.Id].Subscription_Status__c);

	}
}