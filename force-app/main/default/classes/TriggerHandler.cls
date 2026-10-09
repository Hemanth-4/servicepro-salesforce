public virtual class TriggerHandler {       //Class name
    private static Set<String> bypassedHandler = new Set<String>();  // creates set for handler names
    
    public void run () {
        String handlerName = getHandlerName (); //handlerName

        if (bypassedHandler.contains(handlerName)) { //checks handlername is present before or not.
            return;
        }
    
    if (Trigger.isBefore){
        if (Trigger.isInsert) beforeInsert();
        if (Trigger.isUpdate) beforeUpdate();
        if (Trigger.isDelete) beforeDelete();
    } else if (Trigger.isAfter){
        if (Trigger.isInsert) afterInsert();
        if (Trigger.isUpdate) afterUpdate();
        if (Trigger.isDelete) afterDelete();
        if (Trigger.isUndelete) afterUndelete();//Salesforce automatically gives every trigger these built-in boolean flags
    }
}

    protected virtual  void beforeInsert() {}
    protected virtual void beforeUpdate() {}
    protected virtual void beforeDelete() {}
    protected virtual void afterInsert() {}
    protected virtual void afterUpdate() {}
    protected virtual void afterDelete() {}
    protected virtual void afterUndelete() {}

    private String getHandlerName() {
        return String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
    }
    
    public static void bypass(String handlerName){
        bypassedHandler.add(handlerName);
    }
     public static void clearBypass (String handlerName) {
        bypassedHandler.remove(handlerName);
    }

}