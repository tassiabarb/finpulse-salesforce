trigger CreditProposalTrigger on Credit_Proposal__c (before insert,before update) {
    if (Trigger.isBefore && Trigger.isInsert) {
        CreditProposalTriggerHandler.handleBeforeInsert(Trigger.new);
    } else if ( Trigger.isBefore && Trigger.isUpdate) {
        CreditProposalTriggerHandler.handleBeforeUpdate(Trigger.new);
    }
}