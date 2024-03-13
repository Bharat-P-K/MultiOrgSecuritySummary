
@isTest
private class SecurityHealthCheckService_7_Tests {

    // Test setup method to create test data
    @testSetup
    static void setup() {
        // Inserting a test Security_Health_Check__c record
        Security_Health_Check__c securityHealthCheck = new Security_Health_Check__c(
            // Set necessary fields as per object model
        );
        insert securityHealthCheck;
    }

    // Test method for the happy path scenario
    @isTest
    static void testGetSecurityHealthCheckByIdHappyPath() {
        Security_Health_Check__c testSecurityHealthCheck = [SELECT Id FROM Security_Health_Check__c LIMIT 1];

        Test.startTest();
        Security_Health_Check__c result = SecurityHealthCheckService.getSecurityHealthCheckById(testSecurityHealthCheck.Id);
        Test.stopTest();

        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertEquals(testSecurityHealthCheck.Id, result.Id, 'The IDs should match.');
    }

    // Test method for the sad path scenario
    @isTest
    static void testGetSecurityHealthCheckByIdSadPath() {
        Id fakeId = '000000000000AAA';

        Security_Health_Check__c result = null;
        Test.startTest();
        try {
            result = SecurityHealthCheckService.getSecurityHealthCheckById(fakeId);
        } catch (Exception e) {
            // Catching the exception and leaving result as null
        }
        Test.stopTest();

        System.assertEquals(null, result, 'The result should be null for a non-existing ID.');
    }

    // Test method for the exceptional scenario
    @isTest
    static void testGetSecurityHealthCheckByIdException() {
        Test.startTest();
        Security_Health_Check__c result = null;
        Boolean exceptionThrown = false;
        try {
            result = SecurityHealthCheckService.getSecurityHealthCheckById(null);
        } catch (System.QueryException e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assert(exceptionThrown, 'A QueryException should be thrown for null ID.');
        System.assertEquals(null, result, 'The result should be null when exception is thrown.');
    }
}
