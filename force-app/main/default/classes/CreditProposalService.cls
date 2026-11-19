public with sharing class CreditProposalService {
   
    public static void calculateRiskScores(List<Credit_Proposal__c> proposals) {
        if (proposals == null || proposals.isEmpty()) {
            return;
        }

        for (Credit_proposal__c proposal : proposals) {
            Integer score = 500;

            if (proposal.Term_Months__c != null) {
                if (proposal.Term_Months__c <= 24) {
                    score += 100;
                } else if (proposal.Term_Months__c > 60) {
                    score -= 100;
                }
            }

            Decimal requested = proposal.Requested_Amount__c != null ? proposal.Requested_Amount__c : 0;
            Decimal collateral = proposal.Total_Collateral_Value__c != null ? proposal.Total_Collateral_Value__c : 0;

            if (requested > 0) {
                Decimal coverageRatio = collateral / requested;
                if (coverageRatio >= 1.0) {
                    score += 250;
                } else if (coverageRatio >= 0.5) {
                    score += 100;
                } else {
                    score -= 50;
                }
            }

            if (score > 1000) {
                score = 1000;
            } else if (score < 0) {
                score = 0;
            }

            proposal.Risk_Score__c = score;
        }
    }
}
