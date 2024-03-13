
@isTest
private class SecurityHealthCheckService_3_Tests {
    @testSetup
    static void setup() {
        // Insert a custom Security_Health_Check_Org__c record
        // Assuming that Actual_Org_Id__c will be populated by the system
        Security_Health_Check_Org__c shcOrg = new Security_Health_Check_Org__c(
            Latest_Score__c = 80
        );
        insert shcOrg;
    }

    @isTest
    static void testUpdateSecurityHealthCheckOrgHappyPath() {
        Decimal newScore = 85;
        List<Organization> organizations = [SELECT Id FROM Organization LIMIT 1];

        Test.startTest();
        SecurityHealthCheckService.updateSecurityHealthCheckOrg(organizations, newScore);
        Test.stopTest();

        List<Security_Health_Check_Org__c> shcOrgs = [
            SELECT Latest_Score__c, Last_Sync__c
            FROM Security_Health_Check_Org__c
            WHERE Actual_Org_Id__c = :UserInfo.getOrganizationId()
        ];

        System.assertEquals(1, shcOrgs.size(), 'There should be one Security Health Check Org record.');
        System.assertEquals(newScore, shcOrgs[0].Latest_Score__c, 'The latest score should be updated.');
    }

    @isTest
    static void testUpdateSecurityHealthCheckOrgSadPath() {
        Decimal newScore = 75;
        List<Organization> organizations = [SELECT Id FROM Organization LIMIT 1];

        // Manipulate the test data to represent the sad path scenario
        delete [SELECT Id FROM Security_Health_Check_Org__c WHERE Actual_Org_Id__c = :UserInfo.getOrganizationId()];

        Test.startTest();
        SecurityHealthCheckService.updateSecurityHealthCheckOrg(organizations, newScore);
        Test.stopTest();

        List<Security_Health_Check_Org__c> shcOrgs = [
            SELECT Latest_Score__c
            FROM Security_Health_Check_Org__c
            WHERE Actual_Org_Id__c = :UserInfo.getOrganizationId()
        ];

        System.assertEquals(0, shcOrgs.size(), 'There should be no Security Health Check Org records.');
    }

    @isTest
    static void testUpdateSecurityHealthCheckOrgExceptionalPathEmptyList() {
        Decimal newScore = 65;
        List<Organization> organizations = new List<Organization>();

        Test.startTest();
        try {
            SecurityHealthCheckService.updateSecurityHealthCheckOrg(organizations, newScore);
            System.assert(false, 'Method did not throw an exception when it should have.');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('List index out of bounds'), 'Unexpected exception message: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testUpdateSecurityHealthCheckOrgExceptionalPathNullList() {
        Decimal newScore = 65;
        List<Organization> organizations = null;

        Test.startTest();
        try {
            SecurityHealthCheckService.updateSecurityHealthCheckOrg(organizations, newScore);
            System.assert(false, 'Method did not throw an exception when it should have.');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Argument cannot be null'), 'Unexpected exception message: ' + e.getMessage());
        }
        Test.stopTest();
    }
}
