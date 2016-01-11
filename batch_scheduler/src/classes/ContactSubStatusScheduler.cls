global class ContactSubStatusScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
    	Database.executeBatch(new ContactSubStatusUpdateBatch()); 
    }
}