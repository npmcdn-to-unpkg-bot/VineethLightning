public with sharing class MM_Audiences {

    public static List<Contact> retrieveContacts(List<Id> audiences) {
        List<contact> retVal = new List<contact>();
        List<AudienceRule__c> rules = [SELECT Audience__c, ConditionString__c, OverrideConditionString__c, Value__c, UserField__c, Operator__c FROM AudienceRule__c WHERE Audience__c = :audiences];
     
        // create the Audience string condition
       
        String lCondition = '';
        Map<Id,List<AudienceRule__c>> audienceRuleMap = new Map<Id,List<AudienceRule__c>>(); 
        
        for (Audiencerule__c rule : rules) {
            if (!audienceRuleMap.containskey(rule.Audience__c)) {
                List<AudienceRule__c> rulesList = new List<AudienceRule__c>();
                rulesList.add(rule);
                audienceRuleMap.put(rule.Audience__c, rulesList);
            } else {
                audienceRuleMap.get(rule.Audience__c).add(rule);
            }           
        }

        for (Id i : audienceRuleMap.keyset()) {
            Boolean first = true;
            lCondition += '(';
            
            for (Audiencerule__c a : audienceRuleMap.get(i)) {  
                if (a.Value__c == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please Enter Value'));
                } else {
                    if (!first) {
                        lCondition += ' AND ';
                    } else {
                        first = false;
                    }
                    if (!String.isBlank(a.OverrideConditionString__c)) {
                        lCondition += a.OverrideConditionString__c;
                    } else {                    
                        lCondition += MM_AudienceRulesController.getConditionString(a);
                    }
                }
            }
            
            if (lCondition.length() != 0 && lCondition.length() > 1) {
                lCondition += ') OR';
            }
        }
         
        if (rules.size() > 0 && lCondition.endsWith('OR')) {
            lCondition = lCondition.Substring(0, lCondition.length() - 2);
        }

        try {
            if (lCondition != null && lCondition.length() > 1) {
                retVal = Database.query('SELECT id, FirstName, LastName, Account.Name, Broker_Ref__c FROM Contact WHERE ' + lCondition);
            }
        } catch (exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        
        return retVal;        
    }
}