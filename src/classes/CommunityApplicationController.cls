public class CommunityApplicationController{

    public LIst<String> steps{get;set;}
    public Integer activeStageIndex{get;set;}
    public ApexPages.Standardcontroller controller;
    
    public CommunityApplicationController(ApexPages.Standardcontroller controller){
        steps = new LIst<String>{'New','DIP','Valuation','Pre-Offer','Offer'};
        this.controller = controller;
        Opportunity opp = (Opportunity)controller.getRecord();
            if(opp.Stagename == 'Gone-Off'){
                steps.add('Gone-Off');
            }
            else if(opp.Stagename == 'Won'){
                steps.add('Won');
            }
            else{
                steps.add('Won/Lost');
            }
        activeStageIndex = 1;
        for(String step: steps){
            if(opp.Stagename == step){
                break;
            }
            activeStageIndex++;
        }
    }
    
    public pageReference saveApplication(){
        try{
             Opportunity opp = (Opportunity)controller.getRecord();
             opp.Need_Additional_Information__c = 'Submitted';
            controller.save();
            //Pagereference ref = Page.HSBCApplicationDetailPage;
            //ref.getPArameters().put('id',controller.getId());
            return null;
            
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
        }
        return null;
    }


}