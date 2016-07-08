public class homePageExt {

public boolean isAccept{get;set;}

    public homePageExt(ApexPages.StandardController controller) {
       
    }
    
    
    
    public PageReference accept(){
    
    if(isAccept){
        PageReference leadCreation = new PageReference('/apex/leadCreationPage');
        return leadCreation;
    }
    
    return null;
    
    }
    
    

}