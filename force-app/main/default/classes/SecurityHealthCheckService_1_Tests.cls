
@isTest
private class SecurityHealthCheckService_1_Tests {

    // Use the @testSetup to create the necessary test data
    @testSetup
    static void setup() {
        // Set up necessary data for the tests
        // Typically this would be the creation of test records required for the Service methods
        // Since this is an example, we'll skip the implementation details
    }
    
    private static void prepareMock(String endpoint, String method, Integer statusCode, String responseBody) {
        // Create a mock response based on the provided parameters
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(endpoint, method, statusCode, responseBody));
    }
    
    // A helper class to generate mock HTTP responses
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private String endpoint;
        private String method;
        private Integer statusCode;
        private String responseBody;
        
        MockHttpResponseGenerator(String endpoint, String method, Integer statusCode, String responseBody) {
            this.endpoint = endpoint;
            this.method = method;
            this.statusCode = statusCode;
            this.responseBody = responseBody;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            if (req.getEndpoint().contains(endpoint) && req.getMethod().equals(method)) {
                res.setStatusCode(statusCode);
                res.setBody(responseBody);
            } else {
                res.setStatusCode(500);
                res.setBody('Unexpected endpoint or method');
            }
            return res;
        }
    }
    
    // Test the happy path where the callouts and all processing are successful
    @isTest
    static void testGenerateHealthCheckData_Successful() {
        // Set up mock responses to simulate callout responses
        String healthCheckData = '{ "records": [{"CustomBaselineId": "testId", "DurableId": "testDurId", "Score": "100"}]}';
        prepareMock('Select CustomBaselineId, DurableId, Score from SecurityHealthCheck', 'GET', 200, healthCheckData);
        
        String riskData = '{ "records": [{"DurableId": "riskDurId", "RiskType": "High"}]}';
        prepareMock('Select DurableId, OrgValue, OrgValueRaw, RiskType, SecurityHealthCheckId, Setting, SettingGroup, SettingRiskCategory, StandardValue, StandardValueRaw from SecurityHealthCheckRisks', 'GET', 200, riskData);
        
        Test.startTest();
        // Call the method to test
        SecurityHealthCheckService.generateHealthCheckData();
        Test.stopTest();
        
        // Assertions to ensure that the method created records successfully
        List<Security_Health_Check__c> shcList = [SELECT Id, Score__c FROM Security_Health_Check__c];
        System.assertNotEquals(0, shcList.size(), 'At least one Security_Health_Check__c record should have been created.');
        System.assertEquals(100, shcList[0].Score__c, 'The score should be set correctly in the Security_Health_Check__c record.');
    }
    
    // Test the sad path where the callouts to the Tooling API fail
    @isTest
    static void testGenerateHealthCheckData_CalloutFailure() {
        // Set up mock response to simulate callout failure
        prepareMock('Select CustomBaselineId, DurableId, Score from SecurityHealthCheck', 'GET', 500, 'Internal Server Error');
        
        Boolean exceptionThrown = false;
        try {
            Test.startTest();
            // Call the method to test
            SecurityHealthCheckService.generateHealthCheckData();
            Test.stopTest();
        } catch (SecurityHealthCheckService.SecurityHealthCheckServiceException e) {
            exceptionThrown = true;
            // Assert the type of exception to make sure it's what we expect
            System.assertEquals('Internal Server Error', e.getMessage());
        }
        
        // Ensure an exception was thrown due to the callout failure
        System.assert(exceptionThrown, 'An exception should have been thrown due to the callout failure.');
    }
}
