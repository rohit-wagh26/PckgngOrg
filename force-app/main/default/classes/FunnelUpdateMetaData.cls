public inherited sharing class FunnelUpdateMetaData {    
	public static void updatecr(Set<String> names) {
		createRating(names, UserInfo.getSessionId());
	}
     
	@future(callout=true)
	public static void createRating(Set<String> names, String sessionId) {      
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = sessionId == null ? UserInfo.getSessionId() : sessionId;

		MetadataService.GlobalValueSet globalValueSet = new MetadataService.GlobalValueSet();
		globalValueSet.masterLabel = 'Rating Names';
		globalValueSet.fullName = 'FunnelMetrics__Rating_Names';

		List<MetadataService.customValue> mc = new list<MetadataService.customValue>();

		for(String s : names ) {
			MetadataService.customValue c1 = new MetadataService.CustomValue();
			c1.default_x = false;
			c1.isActive = true;
			c1.fullName = s;
			mc.add(c1);
		}

		globalValueSet.customValue = mc;

		List<MetadataService.SaveResult> results = service.updateMetadata(new MetadataService.Metadata[] { globalValueSet });
	}
}