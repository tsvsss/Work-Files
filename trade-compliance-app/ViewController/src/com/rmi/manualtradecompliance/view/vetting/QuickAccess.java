package com.rmi.manualtradecompliance.view.vetting;

import com.rmi.manualtradecompliance.utils.IRIUtils;

import java.sql.ResultSet;

import java.util.ArrayList;
import java.util.List;

import java.util.Map;

import javax.faces.event.ActionEvent;
import javax.faces.event.ValueChangeEvent;
import javax.faces.model.SelectItem;

import oracle.adf.share.ADFContext;

public class QuickAccess {
    public QuickAccess() {
    }
    
    private List<SelectItem> sourceForm = new ArrayList<SelectItem>();

    public void setSourceForm(List<SelectItem> sourceForm) {
        this.sourceForm = sourceForm;
    }

    public List<SelectItem> getSourceForm() {
        try {
            sourceForm.clear();
            List params = new ArrayList();
            ResultSet data =
                new IRIUtils().getPlSqlFunctionData("select option_key,option_value from RMI_GENERIC_PARAMETERS where id='SOURCE_FORM' and enabled='Y'",
                                              params);
            while(data.next()){
                sourceForm.add(new SelectItem(data.getString(1),data.getString(2)));
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return sourceForm;
    }

    private String sourceId;
    private String sourceTable;
    private String sourceType;
    private String sourceTableColumn;

    public void setSourceId(String sourceId) {
        this.sourceId = sourceId;
    }

    public String getSourceId() {
        return sourceId;
    }

    public void setSourceTable(String sourceTable) {
        this.sourceTable = sourceTable;
    }

    public String getSourceTable() {
        return sourceTable;
    }

    public void setSourceType(String sourceType) {
        this.sourceType = sourceType;
    }

    public String getSourceType() {
        return sourceType;
    }

    public void setSourceTableColumn(String sourceTableColumn) {
        this.sourceTableColumn = sourceTableColumn;
    }

    public String getSourceTableColumn() {
        return sourceTableColumn;
    }

    public void sourceFormValueChangeListener(ValueChangeEvent valueChangeEvent) {
        // Add event code here...
        if(valueChangeEvent.getNewValue() != null) {
            String[] data = valueChangeEvent.getNewValue().toString().split("-");
            setSourceTable(data[0]);
            setSourceTableColumn(data[1]);
            setSourceType(data[2]);
        }
    }

    public void submitActionListener(ActionEvent actionEvent) {
        // Add event code here...
        Map pMap =  ADFContext.getCurrent().getPageFlowScope();
        pMap.put("P_SOURCE_ID",sourceId);
        pMap.put("P_SOURCE_TABLE",sourceTable);
        pMap.put("P_SOURCE_TABLE_COLUMN",sourceTableColumn);
        pMap.put("P_SOURCE_TYPE",sourceType);
    }
}
