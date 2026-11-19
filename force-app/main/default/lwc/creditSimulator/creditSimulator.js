import { LightningElement } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreditSimulator extends LightningElement {
    customerName = '';
    customerEmail = '';
    requestedAmount = 50000;
    termMonths = 24;
    collateralValue = 60000;
    annualInterestRate = 12.5;
    isLoading = false;

    handleInputChange(event) {
        const field = event.target.dataset.field;
        const value = event.target.value;

        if (field === 'requestedAmount' || field === 'termMonths' || field === 'collateralValue') {
            this[field] = Number(value) || 0;
        } else {
            this[field] = value;
        }
    }

    get estimatedMonthlyPayment() {
        if (!this.termMonths || this.termMonths <= 0 || !this.requestedAmount) {
            return '0.00';
        }

        const annualRate = this.annualInterestRate / 100;
        const totalInterest = this.requestedAmount * annualRate * (this.termMonths / 12);
        const totalAmount = this.requestedAmount + totalInterest;

        return (totalAmount / this.termMonths).toFixed(2);
    }

    get calculatedRiskScore() {
        let score = 500;

        if (this.termMonths <= 24) {
            score += 100;
        } else if (this.termMonths > 60) {
            score -= 100;
        }

        if (this.requestedAmount > 0) {
            const ratio = this.collateralValue / this.requestedAmount;
            if (ratio >= 1.0) {
                score += 250;
            } else if (ratio >= 0.5) {
                score += 100;
            } else {
                score -= 50;
            }
        }

        if (score > 1000) score = 1000;
        if (score < 0) score = 0;

        return score;
    }

    get riskBadgeClass() {
        const score = this.calculatedRiskScore;
        if (score >= 750) {
            return 'slds-badge slds-theme_success';
        } else if (score >= 500) {
            return 'slds-badge slds-theme_warning';
        }
        return 'slds-badge slds-theme_error';
    }

    get riskBadgeLabel() {
        const score = this.calculatedRiskScore;
        if (score >= 750) {
            return 'Baixo Risco (Pré-Aprovado)';
        } else if (score >= 500) {
            return 'Médio Risco (Análise Manual)';
        }
        return 'Alto Risco (Crítico)';
    }

    handleCreateProposal() {
        if (!this.customerName || !this.customerEmail) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Atenção',
                    message: 'Por favor, preencha o Nome e o E-mail do cliente antes de gerar a proposta.',
                    variant: 'warning'
                })
            );
            return;
        }

        this.isLoading = true;

        const fields = {
            Customer_Name__c: this.customerName,
            Customer_Email__c: this.customerEmail,
            Requested_Amount__c: this.requestedAmount,
            Term_Months__c: this.termMonths,
            Status__c: 'Draft'
        };

        createRecord({ apiName: 'Credit_Proposal__c', fields: fields })
            .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Sucesso!',
                        message: `Proposta de crédito criada com sucesso no sistema! (ID: ${result.id})`,
                        variant: 'success'
                    })
                );

                this.customerName = '';
                this.customerEmail = '';
            })
            .catch(error => {
                const errorMsg = error.body ? error.body.message : error.message;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Erro ao gerar proposta',
                        message: errorMsg,
                        variant: 'error'
                    })
                );
            })
            .finally(() => {
                this.isLoading = false;
            });
    }
}
