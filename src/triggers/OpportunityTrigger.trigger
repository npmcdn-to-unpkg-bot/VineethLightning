trigger OpportunityTrigger on Opportunity (
    before insert, 
    before update, 
    before delete, 
    after insert, 
    after update, 
    after delete, 
    after undelete) {

        if (Trigger.isBefore) {
            //call your handler.before method
        
        } 
        if (Trigger.isAfter && Trigger.isUpdate) {
            OpportunityTriggerHandler.addStatusFeed(Trigger.newMap, Trigger.oldMap);
        
        }
       
}