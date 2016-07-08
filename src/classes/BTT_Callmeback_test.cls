@isTest
private class BTT_Callmeback_test {
  enum PortalType { CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess }
 
	private static testMethod void test() {
	    
	    
	     User pu = getPortalUser(PortalType.PowerPartner, null, true);
       
        System.assert([select isPortalEnabled 
                         from user 
                        where id =:pu.id].isPortalEnabled,
                      'User was not flagged as portal enabled.');       
        
        System.RunAs(pu) {
            System.assert([select isPortalEnabled 
                             from user 
                            where id =:UserInfo.getUserId()].isPortalEnabled, 
                          'User wasnt portal enabled within the runas block. ');
    
      BTT_Callmeback bt = new BTT_Callmeback();
      BTT_Callmeback.Response res = new BTT_Callmeback.Response();
      res = BTT_Callmeback.updateCase('07845552599','123456');
      res = BTT_Callmeback.doGetText();
    
         }          
        
	    

	}
	
	
  public static User getPortalUser(PortalType portalType, User userWithRole, Boolean doInsert ) {
      
       if(userWithRole == null) {   
            
            if(UserInfo.getUserRoleId() == null) {

                UserRole r = new UserRole(name = 'TEST ROLE');
                Database.insert(r);
                
                userWithRole = new User(alias = 'hasrole', email='userwithrole@roletest1.com', userroleid = r.id,
                                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = UserInfo.getProfileId(), 
                                    timezonesidkey='America/Los_Angeles', username='userwithrole@testorg.com');
            } else {
                userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
            }
            
            System.assert(userWithRole.userRoleId!= null, 'This test requires the target org to have at least one UserRole created. Please create a user role in this organization and try again.');
        }
        
        Account a;
        Contact c;
        System.runAs(userWithRole) {

            a = new Account(name = 'TEST ACCOUNT');
            
            Database.insert(a);
            
            c = new Contact();
            c.MailingPostalCode = 'Gu227pe';
       		c.MailingCountry = 'India';
       		c.Birthdate = System.today();
       		c.showpopup__c = true;
       		c.AccountId = a.id;
       		c.lastname = 'lastname';
            Database.insert(c);

        }
        
        Profile p = [select id 
                      from profile 
                     where usertype =:portalType.name() 
                     limit 1];   
        
        String testemail = 'puser000@amamama.com';
        User pu = new User(profileId = p.id, username = testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
                           alias='cspu', lastname='lastname', contactId = c.id);
        
        if(doInsert) {
            Database.insert(pu);
        }
      
      return pu;
  }



}