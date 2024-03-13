
@isTest
private class SecurityHealthCheckService_8_Tests {
    @testSetup
    static void setup() {
        // Create test Security Health Check record
        Security_Health_Check__c shc = new Security_Health_Check__c(
            // Replace with actual required fields and values for your custom object
            Score__c = 80
        );
        insert shc;

        // Create related Security Health Check Risk record
        Security_Health_Check_Risk__c risk = new Security_Health_Check_Risk__c(
            Security_Health_Check__c = shc.Id
            // Add any other required fields and their values here
        );
        insert risk;
    }
    
    @isTest
    static void testGetSecurityHealthCheckRisksWithValidId() {
        Security_Health_Check__c shc = [SELECT Id FROM Security_Health_Check__c LIMIT 1];
        Id validId = shc.Id;
        
        Test.startTest();
        List<Security_Health_Check_Risk__c> risks = SecurityHealthCheckService.getSecurityHealthCheckRisks(validId);
        Test.stopTest();
        
        System.assertNotEquals(null, risks, 'The risks list should not be null.');
        System.assert(risks.size() > 0, 'There should be related risk records.');
    }
    
    @isTest
    static void testGetSecurityHealthCheckRisksWithValidIdNoRisks() {
        // Create a Security Health Check record that has no related risks
        Security_Health_Check__c shc = new Security_Health_Check__c(
            // Replace with actual required fields and values for your custom object
            Score__c = 90
        );
        insert shc;
        Id validIdWithNoRisks = shc.Id;
        
        Test.startTest();
        List<Security_Health_Check_Risk__c> risks = SecurityHealthCheckService.getSecurityHealthCheckRisks(validIdWithNoRisks);
        Test.stopTest();
        
        System.assertNotEquals(null, risks, 'The risks list should not be null.');
        System.assert(risks.size() == 0, 'There should be no related risk records.');
    }
    
    @isTest
    static void testGetSecurityHealthCheckRisksWithInvalidId() {
        // Hard-coded ID that is unlikely to exist
        Id invalidId = '000000000000001';
        
        Test.startTest();
        List<Security_Health_Check_Risk__c> risks = SecurityHealthCheckService.getSecurityHealthCheckRisks(invalidId);
        Test.stopTest();
        
        System.assertNotEquals(null, risks, 'The risks list should not be null.');
        System.assert(risks.isEmpty(), 'There should be no risk records returned for an invalid ID.');
    }
}
