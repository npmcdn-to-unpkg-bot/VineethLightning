public class CC_CommunityApplicationController {

    public List<String> steps{get;set;}
    public Integer activeStageIndex{get;set;}
    public ApexPages.Standardcontroller controller;
    
    public CC_CommunityApplicationController(ApexPages.Standardcontroller controller) {
        steps = new List<String> {'New','DIP','Valuation','Pre-Offer','Offer'};
        this.controller = controller;
        Opportunity opp = (Opportunity)controller.getRecord();
            if (opp.Stagename == Label.Gone_Off) {
                steps.add(Label.Gone_Off);
            } else if (opp.Stagename == Label.Won) {
                steps.add(Label.Won);
            } else {
                steps.add(Label.Approved_Declined);
            }
        activeStageIndex = 1;
        for (String step: steps) {
            if (opp.Stagename == step) {
                break;
            }
            activeStageIndex++;
        }
    }
}