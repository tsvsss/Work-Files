package oracle.apps.xwrl.beans.backing;

import java.util.HashMap;
import java.util.Map;

import javax.faces.event.ActionEvent;

import oracle.adf.share.ADFContext;
import oracle.adf.share.logging.ADFLogger;

import org.apache.myfaces.trinidad.event.LaunchEvent;

public class UploadBacking {

    private static ADFLogger LOGGER = ADFLogger.createADFLogger(UploadBacking.class);

    public UploadBacking() {
        super();
    }

    private Map<String, Object> ScopeMap;

    public void setScopeMap(Map<String, Object> SCOPE_MAP) {
        this.ScopeMap = SCOPE_MAP;
    }

    public Map<String, Object> getScopeMap() {
        if (ScopeMap != null) {
            for (String key : ScopeMap.keySet()) {
                LOGGER.finest("key: " + key);
                LOGGER.finest("value: " + ScopeMap.get(key));
            }
        } else {
            LOGGER.finest("UPLOADBACKING SCOPE_MAP is null");
        }
        return ScopeMap;
    }
    

    public void uploadLaunchListener(LaunchEvent launchEvent) {
        // Add event code here...
        LOGGER.finest("UPLOADBACKING - uploadLaunchListener");
        //showPageScopeMap();
        //showMap();
        //Map<String, Object> map = this.getScopeMap();
        //Map<String, Object> scopeMap = (Map<String, Object>) JSFUtils.getManagedBeanValue("backingBeanScope.UploadBacking.scopeMap");
        //JSFUtils.setManagedBeanValue("backingBeanScope.UploadRequest.scopeMap",map);
        //showPageFlowMap();
    }

    public void uploadReturnActionListener(ActionEvent actionEvent) {
        // Add event code here...
        LOGGER.finest("UPLOADBACKING - uploadReturnActionListener");
        //showPageScopeMap();
        //showMap();
        //Map<String, Object> map = this.getScopeMap();
        //Map<String, Object> scopeMap = (Map<String, Object>) JSFUtils.getManagedBeanValue("backingBeanScope.UploadBacking.scopeMap");
        //String iterBinding = getiterBinding();
        //LOGGER.finest("UploadBacking - ITERBINDING: "+iterBinding);
        //showPageFlowMap();
    }


    // PRIVATE
    private void showSessionScopeMap() {
        LOGGER.finest("UPLOADREQUEST - showSessionScopeMap");
        ADFContext adfCtx = ADFContext.getCurrent();
        Map<String, Object> map = adfCtx.getSessionScope();
        for (String key : map.keySet()) {
            LOGGER.finest("key: " + key);
            LOGGER.finest("value: " + map.get(key));
            break;
        }
    }

    private void showPageScopeMap() {
        LOGGER.finest("showPageScopeMap");
        ADFContext adfCtx = ADFContext.getCurrent();
        Map<String, Object> map = adfCtx.getPageFlowScope();
        for (String key : map.keySet()) {
            LOGGER.finest("key: " + key);
            LOGGER.finest("value: " + map.get(key));
        }
    }

    private void showRequestScopeMap() {
        LOGGER.finest("showRequestScopeMap");
        ADFContext adfCtx = ADFContext.getCurrent();
        Map<String, Object> map = adfCtx.getRequestScope();
        for (String key : map.keySet()) {
            LOGGER.finest("key: " + key);
            LOGGER.finest("value: " + map.get(key));
            break;
        }
    }

    private void createMap() {
        LOGGER.finest("UPLOADBACKING - createMap");
        ADFContext adfCtx = ADFContext.getCurrent();
        Map<String, Object> pageFlowScopeMap = adfCtx.getPageFlowScope();
        Map<String, Object> requestScopeMap = adfCtx.getRequestScope();
        String iterBinding = (String) pageFlowScopeMap.get("iterBinding");
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("iterBinding", iterBinding);
        //requestScopeMap.put("pageFlowMap",map);
        this.setScopeMap(map);
        //JSFUtils.setManagedBeanValue("backingBeanScope.UploadBacking.scopeMap",map);
    }

    private void showMap() {
        LOGGER.finest("UPLOADBACKING- showPageScopeMap");
        ADFContext adfCtx = ADFContext.getCurrent();
        Map<String, Object> scopeMap = adfCtx.getRequestScope();
        Map<String, Object> map = (Map<String, Object>) scopeMap.get("pageFlowMap");
        if (map != null) {
            for (String key : map.keySet()) {
                LOGGER.finest("key: " + key);
                LOGGER.finest("value: " + map.get(key));
            }
        } else {
            LOGGER.finest("SHOW BACKING pageFlowMap is null");
        }
    }

    private String getIterBinding() {
        LOGGER.finest("UPLOADBACKING- getiterBinding");
        ADFContext adfCtx = ADFContext.getCurrent();
        Map<String, Object> pageFlowScopeMap = adfCtx.getPageFlowScope();
        String iterBinding = (String) pageFlowScopeMap.get("iterBinding");
        return iterBinding;
    }

}
