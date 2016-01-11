@isTest
private class ContactSubStatusSchedulerTest {

	@isTest
	private static void myUnitTest() {
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

        Test.startTest();
        	System.schedule('Contact Subscription Update Scheduler Test', '0 0 23 * * ?', new ContactSubStatusScheduler());
        Test.stopTest();

        System.equals('Inactive', [SELECT Subscription_Status__c FROM Contact WHERE Id = :testInactiveContact.Id].Subscription_Status__c);
    } 
    
}