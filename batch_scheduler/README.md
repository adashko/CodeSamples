# CodeSamples 
Schedulable batch APEX process.

Object:  Contact
<br />
Fields:  <br />
Subscription_Start__c (date)<br />
Subscription_End__c (date)<br />
Subscription_Status__c (Text)<br />
<br />
<br />
Logic to update Subscription_Status__c field:<br />
<br />
IF( Current Date < Subscription_Start__c, Subscription_Status__c = 'Inactive' )<br />
IF( (Current Date >= Subscription_Start__c and Current Date <= Subscription_End__c), Current Date < Subscription_Status__c = 'Active')<br />
IF ( Current Date > Subscription_End__c, Subscription_Status__c = 'Expired' )<br />
<br />
Deliverables:<br />
<br />
- Apex Class implementing the schedulable interface running on all Contacts where Subscription_Status__c != null<br />
- Schedulable context to run the APEX process every day at midnight for UTC+4 timezone (same as organization timezone)<br />
- Test class and test methods to achieve 90%+ code coverage<br />

Result:<br />
<br />
Run batch for all contacts (Subscription_Status__c is not null):
```
  Database.executeBatch(new ContactSubStatusUpdateBatch());
```  
Run batch for one contact (only for test):
```
  Database.executeBatch(new ContactSubStatusUpdateBatch('CONTACT_ID'), 1);
```
Schedulable context to run the APEX process every day at midnight - execute the next code using Developer Console (Anonymous): 
```
    System.schedule('Contact Subscription Update Scheduler', '0 0 0 * * ?', new ContactSubStatusScheduler());
```
