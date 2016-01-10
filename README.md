# CodeSamples 

Run batch for all contacts (Subscription_Is2__c is not null):
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
