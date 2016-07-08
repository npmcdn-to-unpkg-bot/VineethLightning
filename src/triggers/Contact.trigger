trigger Contact on Contact (before insert) {
	if (Trigger.isBefore && Trigger.isInsert) {
		ContactTriggerHandler.checkDuplicates(Trigger.new);
	} 
}