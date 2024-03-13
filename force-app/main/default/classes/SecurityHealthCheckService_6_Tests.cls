
@isTest
private class SecurityHealthCheckService_6_Tests {

    // Test method for retrieving the configuration in a non-test context
    @isTest
    static void testGetSecurityHealthCheckConfigNonTestContext() {
        // No need to bypass triggers for a metadata operation

        Test.startTest();
        Security_Health_Check_Config__mdt config = SecurityHealthCheckService.getSecurityHealthCheckConfig();
        Test.stopTest();

        // Replace 'ExpectedCentralOrgURL' with the actual URL that is set in your org's Security_Health_Check_Config__mdt
        String expectedCentralOrgURL = '/services/apexrest/multioss/SecurityHealthCheckReporting'; // Use the actual expected URL from your org
        System.assertNotEquals(null, config, 'Config should be retrieved successfully');
        System.assertEquals(expectedCentralOrgURL, config.Central_Org_URL__c, 'Config URL must match expected value.');
    }

    // Test method for retrieving the configuration in a test context
    @isTest
    static void testGetSecurityHealthCheckConfigTestContext() {
        // No need to bypass triggers for a metadata operation

        // Set the context to test
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        Security_Health_Check_Config__mdt config = SecurityHealthCheckService.getSecurityHealthCheckConfig();
        Test.stopTest();

        // Replace 'ExpectedCentralOrgURLForTest' with the actual URL that you expect to retrieve in a test context
        String expectedCentralOrgURLForTest = '/services/apexrest/multioss/SecurityHealthCheckReporting'; // Use the actual expected URL from your org for the test context
        System.assertNotEquals(null, config, 'Config should be retrieved successfully');
        System.assertEquals(expectedCentralOrgURLForTest, config.Central_Org_URL__c, 'Config URL must match expected value for test.');
    }

    // Mock class for HTTP callout in test context
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"mockResponse": true}');
            res.setStatusCode(200);
            return res;
        }
    }
}
