package oracle.apps.xwrl.beans.upload;

import oracle.adf.share.logging.ADFLogger;
import oracle.adf.view.rich.activedata.ActiveDataEventUtil;
import oracle.adf.view.rich.event.ActiveDataEntry;
import oracle.adf.view.rich.event.ActiveDataUpdateEvent;

public class UploadChange {
    
    // Properties
    private static ADFLogger LOGGER = ADFLogger.createADFLogger(UploadChange.class);
    
    public UploadChange() {
        super();
    }
    
    // Public
    public void triggerDataChange(UploadActiveDataModel model) throws Exception {
        LOGGER.fine("triggerDataChange");
        
        model.bumpChangeCount();
        //model.bumpChangeCount(10);
        
        String state = null;

        switch (model.getCurrentChangeCount()) {
        case 0:
            state = "Job Started - 0%";
            break;
        case 100:
            state = "Job Completed - 100% Press the Refresh button";
            break;
        default:
            state = "Job Processing - " + model.getCurrentChangeCount() + "%";
        }
        LOGGER.fine("state: " + state);
        
        model.setState(state);        
        
        ActiveDataUpdateEvent event =
            ActiveDataEventUtil.buildActiveDataUpdateEvent(ActiveDataEntry.ChangeType.UPDATE, model.getCurrentChangeCount(),
                                                           new String[0], null, new String[] { "state" }, new Object[] {
                                                           state });
        
        model.dataChanged(event);   
        
    }
    
    
    public void triggerDataChange(UploadActiveDataModel model, String outputNum) throws Exception {
        LOGGER.fine("triggerDataChange");
        
        model.bumpChangeCount();
        //model.bumpChangeCount(10);
        
        String state = null;
        
        Integer processCount = Integer.valueOf(outputNum);

        switch (processCount) {
        case 0:
            state = "Job Started - 0%";
            break;
        case 100:
            state = "Job Completed - 100% Press the Refresh button";
            break;
        default:
            state = "Job Processing - " + processCount + "%";
        }
        LOGGER.fine("state: " + state);
        
        model.setState(state);        
        
        ActiveDataUpdateEvent event =
            ActiveDataEventUtil.buildActiveDataUpdateEvent(ActiveDataEntry.ChangeType.UPDATE, model.getCurrentChangeCount(),
                                                           new String[0], null, new String[] { "state" }, new Object[] {
                                                           state });
        
        model.dataChanged(event);   
        
    }
}
