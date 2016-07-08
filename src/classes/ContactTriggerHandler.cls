public without sharing class ContactTriggerHandler {
	public static void checkDuplicates(List<Contact> newContacts) {
		Map<String, Contact> emailContactMap = new Map<String, Contact>();
		for (Contact c : newContacts) {
			emailContactMap.put(c.Email, c);
		}

		List<Contact> existContacts = new List<Contact>();

		if (! emailContactMap.isEmpty()) {
			existContacts = [
				SELECT Id, Email
				FROM Contact
				WHERE Email IN: emailContactMap.keySet()
			];
		}
		for (Contact c : existContacts) {
			if (emailContactMap.containsKey(c.email)) {
				emailContactMap.get(c.email).addError(Label.Contact_with_this_email_has_been_created_already);
			}
		}
	}
}