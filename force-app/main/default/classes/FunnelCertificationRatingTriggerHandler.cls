public inherited sharing class FunnelCertificationRatingTriggerHandler {
	public static void afterInsert(List<Certification_Rating__c> certificationRatings) {
		updateCertificationRatings(certificationRatings);
	}

	public static void afterUpdate(List<Certification_Rating__c> certificationRatings, Map<Id, Certification_Rating__c> oldMap) {
		updateCertificationRatings(certificationRatings, oldMap);
	}

	private static void updateCertificationRatings(List<Certification_Rating__c> certificationRatings) {
		updateCertificationRatings(certificationRatings, new Map<Id, Certification_Rating__c>());
	}

	private static void updateCertificationRatings(List<Certification_Rating__c> certificationRatings, Map<Id, Certification_Rating__c> oldMap) {
		Set<String> ratingNames = new Set<String>();
		Set<String> oldRatingNames = new Set<String>();
		
		// seed the rating names from the existing picklist
		for (Schema.Picklistentry picklistEntry : Certification_Answer__c.Rating_name_picklist__c.getDescribe().getPicklistValues()){ 
			ratingNames.add(pickListEntry.getLabel());
			oldRatingNames.add(pickListEntry.getLabel());
		}

		// remove the old values (do this first in case name didn't change, something else did that invoked the update)
		for (Certification_Rating__c cr : oldMap.values()) {
			ratingNames.remove(cr.Name);
		}

		// add the existing values (could be new, could be updated, could be unchanged)
		for (Certification_Rating__c cr : certificationRatings) { 
			ratingNames.add(cr.Name);
		}
        
		// if there is a difference, call the metadata service to update
		if (!ratingNames.equals(oldRatingNames)) {
			updateRatingsMetadata(ratingNames);
		}
	}

	private static void updateRatingsMetadata(Set<String> ratingNames) {      
		MetadataService.GlobalValueSet globalValueSet = new MetadataService.GlobalValueSet();
		globalValueSet.masterLabel = 'Rating Names';
		globalValueSet.fullName = 'FunnelMetrics__Rating_Names';

		globalValueSet.customValue = new List<MetadataService.CustomValue>();

		for (String ratingName : ratingNames) {
			MetadataService.customValue cv = new MetadataService.CustomValue();
			cv.default_x = false;
			cv.isActive = true;
			cv.fullName = ratingName;
			globalValueSet.customValue.add(cv);
		}

		System.enqueueJob(new FunnelMetadataServiceQueueable(globalValueSet));
	}
}