public class myLeadExt {

public list<lead> leadLst{get;set;}

    public myLeadExt() {
        User demoIntroUser=[select id from user where id = '00524000000uypB'];
        leadLst = new list<lead>();
        leadLst =[select id,name,Company,phone,Email,Address,Status,street,city,state,postalcode,Company_Number__c,createddate from lead where Introducer__c = : demoIntroUser.id];
                
    }




    

}