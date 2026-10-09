trigger ServiceRequestTrigger on Service_Request__c (before insert, before update, after insert, after update) {
    new ServiceRequestTriggerHandler().run();

}