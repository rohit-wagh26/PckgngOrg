@IsTest
public with sharing class FunnelCertificationRatingTriggerTest {
	private static List<Certification_Rating__c> certificationRatings = new List<Certification_Rating__c>{
		new Certification_Rating__c(
			Id = Schema.Certification_Rating__c.getSObjectType().getDescribe().getKeyPrefix() + '000000000001',
			Name = 'One'
		),
		new Certification_Rating__c(
			Id = Schema.Certification_Rating__c.getSObjectType().getDescribe().getKeyPrefix() + '000000000002',
			Name = 'Two'
		),
		new Certification_Rating__c(
			Id = Schema.Certification_Rating__c.getSObjectType().getDescribe().getKeyPrefix() + '000000000003',
			Name = 'Three'
		)
	};

	private static Map<Id, Certification_Rating__c> oldMap = new Map<Id, Certification_Rating__c>{ 
		Schema.Certification_Rating__c.getSObjectType().getDescribe().getKeyPrefix() + '000000000001' => new Certification_Rating__c(
			Id = Schema.Certification_Rating__c.getSObjectType().getDescribe().getKeyPrefix() + '000000000001',
			Name = 'One1'
		),
		Schema.Certification_Rating__c.getSObjectType().getDescribe().getKeyPrefix() + '000000000002' => new Certification_Rating__c(
			Id = Schema.Certification_Rating__c.getSObjectType().getDescribe().getKeyPrefix() + '000000000002',
			Name = 'Two2'
		),
		Schema.Certification_Rating__c.getSObjectType().getDescribe().getKeyPrefix() + '000000000003' => new Certification_Rating__c(
			Id = Schema.Certification_Rating__c.getSObjectType().getDescribe().getKeyPrefix() + '000000000003',
			Name = 'Three3'
		)
	};

	@IsTest
	private static void afterInsertCertificationRatingsShouldCompleteSuccessfully() {
		Test.setMock(WebServiceMock.class, new FunnelMetadataServiceQueueableTest.MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new FunnelMetadataServiceQueueableTest.MetadataServiceMock());

		Test.startTest();

		FunnelCertificationRatingTriggerHandler.afterInsert(certificationRatings);

		Test.stopTest();
	}

	@IsTest
	private static void afterUpdateCertificationRatingsShouldCompleteSuccessfully() {
		Test.setMock(WebServiceMock.class, new FunnelMetadataServiceQueueableTest.MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new FunnelMetadataServiceQueueableTest.MetadataServiceMock());

		Test.startTest();

		FunnelCertificationRatingTriggerHandler.afterUpdate(certificationRatings, oldMap);

		Test.stopTest();
	}
}