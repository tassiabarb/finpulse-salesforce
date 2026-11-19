public with sharing class CreditProposalBatch implements Database.Batchable<sObject> {

       public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Status__c, Notes__c 
            FROM Credit_Proposal__c 
            WHERE Status__c = 'Draft'
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Credit_Proposal__c> scope) {
        for (Credit_Proposal__c proposal : scope) {
            proposal.Status__c = 'Cancelled';
            proposal.Notes__c = 'Proposta cancelada automaticamente por inatividade pelo Batch FinPulse.';
        }
        update scope;
    }

        public void finish(Database.BatchableContext bc) {
        System.debug('>>> [FinPulse] Batch de cancelamento de propostas finalizado com sucesso!');
    }
}