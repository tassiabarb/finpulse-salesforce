@RestResource(urlMapping='/api/proposals/*')
global with sharing class CreditProposalRestService {

    @HttpPost
    global static String createProposal(String customerName, String customerEmail, Decimal requestedAmount, Integer termMonths) {
        Credit_Proposal__c proposal = new Credit_Proposal__c();
        proposal.Customer_Name__c = customerName;
        proposal.Customer_Email__c = customerEmail;
        proposal.Requested_Amount__c = requestedAmount;
        proposal.Term_Months__c = termMonths;
        proposal.Status__c = 'Submitted';
        insert proposal;
        return proposal.Id;
    }
}