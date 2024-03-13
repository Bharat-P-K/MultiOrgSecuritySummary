
@isTest
private class SecurityHealthCheckService_4_Tests {

    @testSetup
    static void setupTestData() {
        // Create the necessary test data for SecurityHealthCheck
        
        // Insert a dummy Security_Health_Check_Org__c record
        Security_Health_Check_Org__c shco = new Security_Health_Check_Org__c(
            Name = 'Test Org',
            Organization_Id__c = UserInfo.getOrganizationId(), // Use the current org's ID
            Active__c = true,
            Refresh_Token__c = true,
            Sync_Status__c = 'Active',
            Last_Sync__c = System.now(),
            Latest_Score__c = 90
        );
        insert shco;

        // Insert a dummy Security_Health_Check__c record related to the org
        Security_Health_Check__c shc = new Security_Health_Check__c(
            Check_Date__c = Date.today(),
            CustomBaselineId__c = 'TestBaselineId',
            DurableId__c = 'TestDurableId',
            Score__c = 90,
            Org_Name__c = 'Test Org',
            Org_Identifier__c = UserInfo.getOrganizationId(), // Use the current org's ID
            Security_Health_Check_Org__c = shco.Id
        );
        insert shc;
    }

    @isTest
    static void testSendHealthCheckToCentralOrg() {
        List<Security_Health_Check__c> shcs = [SELECT Id FROM Security_Health_Check__c LIMIT 1];

        // If no test data found, we need to create it here (not a recommended approach)
        if (shcs.isEmpty()) {
            setupTestData(); // Call the setup method to ensure data is present
            shcs = [SELECT Id FROM Security_Health_Check__c LIMIT 1]; // Re-query after setup
        }
        
        String validSecurityHealthCheckId = shcs[0].Id;
        
        Boolean exceptionThrown = false;
        try {
            Test.startTest();
            SecurityHealthCheckService.sendHealthCheckToCentralOrg(new List<String>{validSecurityHealthCheckId});
            Test.stopTest();
        } catch (Exception e) {
            exceptionThrown = true;
        }
        
        System.assert(!exceptionThrown, 'No exceptions should be thrown during the process');
    }

    // ... Other test methods remain unchanged ...
}
