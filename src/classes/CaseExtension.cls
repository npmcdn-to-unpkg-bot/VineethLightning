public class CaseExtension{
    
    public Case caseINstance{get;set;}
    
    public Attachment myfile{get;set;}
    
    public CAseExtension(ApexPages.StandardController controller){
        caseInstance = (Case)controller.getRecord();
        myfile = new Attachment();
    }
    
    
    public void save(){
        try{
        insert caseInstance;
        if(myFile.Body != null){
            myFile.parentId = caseInstance.Id;
            insert myFile;
        }
        caseInstance = [Select Id, Type, CaseNUmber, Description from Case where Id =: caseInstance.id];
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info, 'Case Created Successfully. Case Number: '+caseInstance.CaseNUmber));
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
        }
    }
}