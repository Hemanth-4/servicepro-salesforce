public class ServiceRequestTriggerHandler extends TriggerHandler {
    private List<Service_Request__c> newRequests;

    public ServiceRequestTriggerHandler(){
        newRequests = (List<Service_Request__c>)Trigger.new;
    }
protected override void beforeInsert() {
       assignTechnicians(newRequests);
    }   
private void assignTechnicians(List<Service_Request__c> requests){

Set<String> regions = new Set<String>();
for (Service_Request__c req : newRequests) {
    if (req.Region__c != null) {
        regions.add(req.Region__c);
    }
}

if(regions.isEmpty()) {
    return;
}

List<Technician__c> MatchingTechnicians=[
    select Id,region__c,Skill_Level__c from Technician__c where region__c in :regions];

Map<String, List<Technician__c>> TechsByRegion = new Map<String, List<Technician__c>>();
for(Technician__c tech : MatchingTechnicians){
    if(!TechsByRegion.containsKey(tech.region__c)){
        techsByRegion.put(tech.region__c, new List<Technician__c>());
    }
    techsByRegion.get(tech.region__c).add(tech);
}

for (Service_Request__c req: newRequests){

    if(req.Technician__c == null && req.Region__c != null) {
        List<Technician__c> availableTechs = TechsByRegion.get(req.Region__c);
        if(availableTechs != null && !availableTechs.isEmpty()){
            req.Technician__c = availableTechs[0].Id;
        }
    } 
}
}
}