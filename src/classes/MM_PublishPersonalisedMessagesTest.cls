@isTest
private class MM_PublishPersonalisedMessagesTest {
    @isTest
    static void publishBrokerTest() {
        String RT_PERSONALIZED_MESSAGE = 'Personalised Message';
        
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND UserRoleId != null AND IsActive = true limit 1];
        system.runAs(adminUser) {
          PageReference pageRef = Page.MM_PublishPersonalisedMessages;
          Test.setCurrentPage(pageRef);
          
          Account account = TestDataUtility.createAccount('Broker Firm', true);
          
          List<Contact> contactList = new List<Contact>();
          for (integer i = 0; i < 30; i++) {
              Contact Contact1 = new Contact();
              Contact1 = TestDataUtility.createContact(account.Id, 'Broker', false);
              Contact1.RM__c = Userinfo.getUserId();
              Contact1.FirstName = 'TestContact' + i;
              Contact1.LastName = 'TestContact' + i;
              contactList.add(Contact1);
          }
          insert contactList;
          
          Manage_Content__c manageContent = TestDataUtility.createManageContent(false);
          manageContent.Approved__c = true;
          manageContent.RecordTypeId = Schema.SObjectType.Manage_Content__c.getRecordTypeInfosByName().get(RT_PERSONALIZED_MESSAGE).getRecordTypeId();
          manageContent.Title__c = ' UAT TEST 1';
          manageContent.Summary__c = 'UAT TEST 1 Summary';
          insert manageContent;
          
          ApexPages.StandardController standardController = new ApexPages.StandardController(manageContent);
          
          Test.startTest();
              MM_PublishPersonalisedMessagesController controller = new MM_PublishPersonalisedMessagesController(standardController);
              controller.getContacts();
              
              controller.getPageNumber();
              controller.getTotalPages();
              
              controller.selectedBrokerContactId = contactList[1].Id;
              controller.doSelectItem();
              
              controller.doNext();
              controller.getHasNext();
              
              controller.getHasPrevious();
              controller.doPrevious();
              
              controller.selectedBrokerContactId = contactList[1].Id;
              controller.doDeselectItem();
              
              controller.selectedBrokerContactId = contactList[1].Id;
              controller.doSelectItem();
              
              controller.publishBrokerContact();
              
              Manage_Content__c manageContent1 = [SELECT Id, Published__c, (SELECT Id FROM Content_Brokers__r) FROM Manage_Content__c];
              List<Content_Broker__c> contentBrokersList = manageContent1.Content_Brokers__r;
              
              system.assertEquals(true, manageContent1.Published__c);
              system.assertEquals(1, contentBrokersList.size());
          Test.stopTest();
        }
    }
    
    @isTest
    static void searchBrokerTest() {
        String RT_PERSONALIZED_MESSAGE = 'Personalised Message';
        
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND UserRoleId != null AND IsActive = true limit 1];
        system.runAs(adminUser) {
          PageReference pageRef = Page.MM_PublishPersonalisedMessages;
          Test.setCurrentPage(pageRef);
          
          TestDataUtility.createIntermediarySearchSetting(true);
          Account account = TestDataUtility.createAccount('Broker Firm', true);
          
          List<Contact> contactList = new List<Contact>();
          for(integer i = 0; i < 30; i++) {
              Contact Contact1 = new Contact();
              Contact1 = TestDataUtility.createContact(account.Id, 'Broker', false);
              Contact1.RM__c = Userinfo.getUserId();
              Contact1.FirstName = 'TestContact' + i;
              Contact1.LastName = 'TestContact' + i;
              contactList.add(Contact1);
          }
          insert contactList;
          
          Manage_Content__c manageContent = TestDataUtility.createManageContent(false);
          manageContent.Approved__c = true;
          manageContent.RecordTypeId = Schema.SObjectType.Manage_Content__c.getRecordTypeInfosByName().get(RT_PERSONALIZED_MESSAGE).getRecordTypeId();
          manageContent.Title__c = ' UAT TEST 1';
          manageContent.Summary__c = 'UAT TEST 1 Summary';
          insert manageContent;
          
          ApexPages.StandardController standardController = new ApexPages.StandardController(manageContent);
          
          Test.startTest();
              MM_PublishPersonalisedMessagesController controller = new MM_PublishPersonalisedMessagesController(standardController);
              controller.selectedBrokerContactId = contactList[1].Id;
              controller.getContacts();
              controller.getPageNumber();
              controller.getTotalPages();
              controller.doNext();
              controller.doPrevious();
              
              controller.firstNamesearchtext = 'TestContact2';
              controller.searchBroker();
              
              controller.firstNamesearchtext = null;
              controller.lastNamesearchtext = 'TestContact2';
              controller.searchBroker();
              
              controller.firstNamesearchtext = 'TestContact2';
              controller.lastNamesearchtext = 'TestContact2';
              PageReference pref = controller.searchBroker();
              
              controller.publishBrokerContact();
            system.assertEquals(pref,null);
          Test.stopTest();
          
        }
    }
    
    @isTest
    static void closeBrokerPageTest(){
        String RT_PERSONALIZED_MESSAGE = 'Personalised Message';
        
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND UserRoleId != null AND IsActive = true LIMIT 1];
        system.runAs(adminUser) {
          PageReference pageRef = Page.MM_PublishPersonalisedMessages;
          Test.setCurrentPage(pageRef);
          
          TestDataUtility.createIntermediarySearchSetting(true);
          Account account = TestDataUtility.createAccount('Broker Firm', true);
          
          List<Contact> contactList = new List<Contact>();
          for(integer i = 0; i < 30; i++) {
              Contact Contact1 = new Contact();
              Contact1 = TestDataUtility.createContact(account.Id, 'Broker', false);
              Contact1.RM__c = Userinfo.getUserId();
              Contact1.FirstName = 'TestContact' + i;
              Contact1.LastName = 'TestContact' + i;
              contactList.add(Contact1);
          }
          insert contactList;
          
          Manage_Content__c manageContent = TestDataUtility.createManageContent(false);
          manageContent.Approved__c = true;
          manageContent.RecordTypeId = Schema.SObjectType.Manage_Content__c.getRecordTypeInfosByName().get(RT_PERSONALIZED_MESSAGE).getRecordTypeId();
          manageContent.Title__c = ' UAT TEST 1';
          manageContent.Summary__c = 'UAT TEST 1 Summary';
          insert manageContent;
          
          Content_Broker__c contentBroker = new Content_Broker__c();
          contentBroker.Manage_Content__c = manageContent.Id;
          contentBroker.Contact__c = contactList[2].Id;
          insert contentBroker;
          
          ApexPages.StandardController standardController = new ApexPages.StandardController(manageContent);
          
          Test.startTest();
              MM_PublishPersonalisedMessagesController controller = new MM_PublishPersonalisedMessagesController(standardController);
              controller.selectedBrokerContactId = contactList[1].Id;
              controller.getContacts();
              controller.getPageNumber();
              controller.getTotalPages();
              
              controller.firstNamesearchtext = 'TestContact2';
              controller.searchBroker();
              PageReference pref = controller.Close();
              PageReference result = standardController.view();
              system.assertEquals(result.getUrl(), pref.getUrl());
          Test.stopTest();
        }
    }
    
    @isTest
    static void unpublishBrokerPageTest(){
        String RT_PERSONALIZED_MESSAGE = 'Personalised Message';
        
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND UserRoleId != null AND IsActive = true LIMIT 1];
        system.runAs(adminUser) {
          PageReference pageRef = Page.MM_PublishPersonalisedMessages;
          Test.setCurrentPage(pageRef);
          
          TestDataUtility.createIntermediarySearchSetting(true);
          Account account = TestDataUtility.createAccount('Broker Firm', true);
          
          List<Contact> contactList = new List<Contact>();
          for(integer i = 0; i < 30; i++) {
              Contact Contact1 = new Contact();
              Contact1 = TestDataUtility.createContact(account.Id, 'Broker', false);
              Contact1.RM__c = Userinfo.getUserId();
              Contact1.FirstName = 'TestContact' + i;
              Contact1.LastName = 'TestContact' + i;
              contactList.add(Contact1);
          }
          insert contactList;
          
          Manage_Content__c manageContent = TestDataUtility.createManageContent(false);
          manageContent.Approved__c = true;
          manageContent.RecordTypeId = Schema.SObjectType.Manage_Content__c.getRecordTypeInfosByName().get(RT_PERSONALIZED_MESSAGE).getRecordTypeId();
          manageContent.Title__c = ' UAT TEST 1';
          manageContent.Summary__c = 'UAT TEST 1 Summary';
          insert manageContent;
          
          Content_Broker__c contentBroker = new Content_Broker__c();
          contentBroker.Manage_Content__c = manageContent.Id;
          contentBroker.Contact__c = contactList[2].Id;
          insert contentBroker;
          
          ApexPages.StandardController standardController = new ApexPages.StandardController(manageContent);
          
          Test.startTest();
              MM_PublishPersonalisedMessagesController controller = new MM_PublishPersonalisedMessagesController(standardController);
              controller.selectedBrokerContactId = contactList[1].Id;
              controller.getContacts();
              controller.getPageNumber();
              controller.getTotalPages();
              
              controller.publishBrokerContact();
              controller.unPublish();
              
              Manage_Content__c manageContent1 = [SELECT Id, Published__c, (SELECT Id FROM Content_Brokers__r) FROM Manage_Content__c];
              system.assertEquals(false, manageContent1.Published__c);
          Test.stopTest();
        }
    }
}