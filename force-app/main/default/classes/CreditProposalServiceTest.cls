@isTest
private class CreditProposalServiceTest {
    @isTest
    static void testHighScoreWithShortTermAndFullCollateral() {
        Credit_Proposal__c proposal = (Credit_Proposal__c) JSON.deserialize(
            '{"Customer_Name__c":"Test Customer","Customer_Email__c":"test@test.com","Requested_Amount__c":50000,"Term_Months__c":12,"Total_Collateral_Value__c":60000}',
            Credit_Proposal__c.class
        );
        
        List<Credit_Proposal__c> proposals = new List<Credit_Proposal__c>{ proposal };

        Test.startTest();
        CreditProposalService.calculateRiskScores(proposals);
        Test.stopTest();

        Assert.areEqual(850, proposal.Risk_Score__c, 'O score calculado deveria ser 850 para garantia total e prazo curto');
    }
}
