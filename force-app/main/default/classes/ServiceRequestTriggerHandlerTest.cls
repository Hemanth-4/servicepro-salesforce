@isTest
private class ServiceRequestTriggerHandlerTest {
    @testSetup
    static void setupTestData() {
        // Test data will go here

        Customer__c customer = new Customer__c(
        Name = 'Test Customer',
        Address__c = '123 Test St',
        Phone__c = '123-456-7890',
        Tier__c = 'Gold'
        );
        insert customer;

        Equipment__c equipment = new Equipment__c(
            Name = 'Test Equipment',
            Customer__c = customer.Id,
            Serial_Number__c = 'SN123456'
        );
        insert equipment;

        Technician__c tech = new Technician__c(
            Name = 'Test Technician',
            Skill_Level__c = 'Senior',
            Region__c = 'North'
        );
        insert tech;
    }
    @isTest
    Static void testTechinicianAssignedWhenAvailable(){
        //Positive case
        Equipment__c equipment = [SELECT Id FROM Equipment__c LIMIT 1];

        Service_Request__c request = new Service_Request__c(
            Name = 'Test Service Request 1',
            Equipment__c = equipment.Id,
            Region__c = 'North',
            status__c = 'New',
            Priority__c = 'Medium'
        );
        Test.startTest();
        insert request;
        Test.stopTest();

        Service_Request__c result = [Select Technician__c FROM Service_Request__c WHERE Id = :request.Id];
    
        System.assertNotEquals(null, result.Technician__c, 'Technician should be assigned when available');
    }

    @isTest
    Static void testTechinicianNotAssignedWhenNoneAvailable(){
        //Negative case
        Equipment__c equipment = [SELECT Id FROM Equipment__c LIMIT 1];

        Service_Request__c request = new Service_Request__c(
            Name = 'Test Service Request 2',
            Equipment__c = equipment.Id,
            Region__c = 'South', // No technician in this region
            status__c = 'New',
            Priority__c = 'Medium'
        );
        Test.startTest();
        insert request;
        Test.stopTest();

        Service_Request__c result = [Select technician__c from Service_Request__c WHERE Id = :request.Id];

        System.assertEquals(null, result.Technician__c, 'Technician should not be assigned when none are available');
    } 

    @isTest
    Static void testBulkInsertAssignsCorrectly(){
        // Bulk case - 200 records
        Equipment__c equipment = [SELECT Id FROM Equipment__c LIMIT 1];

        List<Service_Request__c> BulkRequests = new List<Service_Request__c>();
        for(Integer i = 0; i < 200; i++){
            BulkRequests.add(new Service_Request__c(
                Name = 'Bulk Service Request ' + i,
                Equipment__c = equipment.Id,
                Region__c = 'North',
                Status__c = 'New',
                Priority__c = 'Medium'
            ));
    }      
    Test.startTest();
    insert BulkRequests;
    Test.stopTest();
    Set<Id> requestIds = new Set<Id>();
    for(Service_Request__c req : BulkRequests){
        requestIds.add(req.Id);
    }

    List <Service_Request__c> results = [
        Select Technician__c from Service_Request__c 
        WHERE Id IN :requestIds
    ];

    for(Service_Request__c res : results){
        System.assertNotEquals(null, res.Technician__c, 'Technician should be assigned for all bulk requests');
    }

    System.assertEquals(200, results.size(), 'All 200 requests should be processed');
    }
}        