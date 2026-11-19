public with sharing class CreditProposalTriggerHandler {
    public static void handleBeforeInsert(List<Credit_Proposal__c> newProposals) {
        CreditProposalService.calculateRiskScores(newProposals);

    }

    public static void handleBeforeUpdate(List<Credit_Proposal__c> updatedProposals) {
        CreditProposalService.calculateRiskScores(updatedProposals);
    }
}