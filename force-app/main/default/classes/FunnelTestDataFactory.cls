public class FunnelTestDataFactory {
    
     public static User createUser(Id profileId){
         
         User u = new User(
                ProfileId = profileId,
                LastName ='last',
                Email = 'TestUser@test.com',
                Username = 'TestUsername@fmtest.com',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'GMT',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
                
            );
         
        
        return u;
    }
    
    

}