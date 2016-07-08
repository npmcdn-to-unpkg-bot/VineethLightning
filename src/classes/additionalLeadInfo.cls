public class additionalLeadInfo {
    
    public lead leadRecord{get;set;}
    public additionalLeadInfo(ApexPages.StandardController controller) {
        Id leadId = ApexPages.currentPage().getParameters().get('id');
        system.debug('>>>>Lead Id >>>'+leadId);
        leadRecord =[select id,Amount_of_loan__c,Deposit_amount__c,Industry_sector__c,Existing_Barclays_Customer__c,Business_profile__c 
                    ,Loan_to_Value_LTV__c,Reason_for_the_loan__c,Name,company,status,email,phone from lead where id = :leadId];
        leadRecord.Existing_Barclays_Customer__c = 'Yes';
        leadRecord.Industry_sector__c = 'Infrastructure';
        leadRecord.Loan_to_Value_LTV__c = 70;
        leadRecord.Deposit_amount__c = 200;
        leadRecord.Reason_for_the_loan__c = 'New Industry';
        leadRecord.Business_profile__c = 'BA';
                            
    
    }   
    
        
    public PageReference save(){
    update leadRecord ;   
    system.debug('Insert record with id'+leadRecord.id)         ;
    PageReference leadPage = new PageReference('/apex/leadCreationSucessPage');
    leadPage.setRedirect(true);
    return leadPage;
    }
}