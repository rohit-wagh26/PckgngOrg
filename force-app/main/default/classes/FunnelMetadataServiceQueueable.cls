public with sharing class FunnelMetadataServiceQueueable implements Queueable, Database.AllowsCallouts {
    private MetadataService.MetadataPort service {get; set;}
    private MetadataService.GlobalValueSet globalValueSet {get; set;}
	@TestVisible
	private List<MetadataService.SaveResult> saveResults {get; set;}

	public FunnelMetadataServiceQueueable() { 
		service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
	}

	public FunnelMetadataServiceQueueable(MetadataService.GlobalValueSet globalValueSet) {
		this();
		this.globalValueSet = globalValueSet;
	}

	public void execute(QueueableContext context) {
		keepAlive();
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.endpoint_x = 'callout:FM_API2/services/Soap/m/38.0';
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = '{!$Credential.OAuthToken}';

		if (this.globalValueSet != null) {
			saveResults = service.updateMetadata(new MetadataService.Metadata[] { this.globalValueSet });
		}
	}

	private void keepAlive() {
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint('callout:FM_API2/services/data/v38.0');
		req.setMethod('GET');
		HttpResponse res = h.send(req);
	}
}