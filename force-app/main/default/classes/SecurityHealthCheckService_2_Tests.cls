
@isTest
private class SecurityHealthCheckService_2_Tests {

  @testSetup
  static void setup() {
    // No specific setup required since Organization data exists by default and cannot be created in a test environment
    // We might need to setup other related records if the organization data relations are required
  }
  
  @isTest
  static void testCreateNewSecurityHealthCheckOrgHappyPath() {
    Decimal latestScore = 85.0;
    Organization orgRecord = [SELECT Id, Name FROM Organization LIMIT 1];
    
    Test.startTest();
    SObject result = SecurityHealthCheckService.createNewSecurityHealthCheckOrg(orgRecord, latestScore);
    Test.stopTest();
    
    Security_Health_Check_Org__c createdRecord = (Security_Health_Check_Org__c)result;

    System.assertNotEquals(null, createdRecord, 'The result should not be null');
    System.assertEquals(orgRecord.Name, createdRecord.Name, 'The Name field should match the Organization Name');
    System.assertEquals(latestScore, createdRecord.Latest_Score__c, 'The Latest_Score__c should match the provided score');
  }
  
  @isTest
  static void testCreateNewSecurityHealthCheckOrgWithNullOrganization() {
    Decimal latestScore = 90.0;
    
    Boolean exceptionThrown = false;
    Test.startTest();
    try {
      SObject result = SecurityHealthCheckService.createNewSecurityHealthCheckOrg(null, latestScore);
    } catch(Exception e) {
      exceptionThrown = true;
    }
    Test.stopTest();
    
    System.assert(exceptionThrown, 'An exception should have been thrown due to null Organization');
  }
}
