trigger UserTrigger on User (before insert, after insert, before update, after update) {
	/*if (Trigger.isAfter && Trigger.isInsert) {
		UserTriggerHandler.addWelcomeFeed(Trigger.new);
	}*/ 
/*	if (Trigger.isAfter && Trigger.isUpdate) {
		UserTriggerHandler.addWelcomeFeedUpdate(Trigger.newMap, Trigger.oldMap);
	}*/
}