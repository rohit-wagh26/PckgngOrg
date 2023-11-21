trigger FunnelCertificationRatingMetadata on Certification_Rating__c (after insert, after update) {
	if (Trigger.isAfter && Trigger.isInsert) {
		FunnelCertificationRatingTriggerHandler.afterInsert(Trigger.new);
	}

	if (Trigger.isAfter && Trigger.isUpdate) {
		FunnelCertificationRatingTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
	}
}