public class attchmentLead {

    public attchmentLead() {

    }

    
    public lead leadRecord{get;set;}
    public attchmentLead(ApexPages.StandardController controller) {
        leadRecord =(lead) controller.getRecord();
        Double doubleCompanyNumber =Math.random();
        String companyNumber= string.valueof(doubleCompanyNumber);
        companyNumber = companyNumber.substring(2, 10);
        leadRecord.FirstName = 'Alan';
        leadRecord.lastName = 'Hatcher';
        leadRecord.Company_Number__c= companyNumber;
        leadRecord.Company = 'Protection and Investment Ltd';
        
    }
    public Attachment myfile;
    public Attachment getmyfile()
    {
        myfile = new Attachment();
        return myfile;
    }
    
    public PageReference save(){
    try{
    insert leadRecord ;
    }
    catch(Exception e) {
        ApexPages.addMessages(e);
    }
    Attachment a = new Attachment(parentId = leadRecord.id, name=myfile.name, body = myfile.body);
    try{
        insert a;
    }
    catch(Exception e) {
        ApexPages.addMessages(e);
    }
   
    system.debug('Insert record with id'+leadRecord.id)         ;
    PageReference leadPage = new PageReference('/apex/leadCreationPageHSBC');
    leadPage.setRedirect(true);
    return leadPage;
    }
}