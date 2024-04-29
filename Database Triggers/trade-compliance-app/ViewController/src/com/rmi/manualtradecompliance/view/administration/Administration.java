package com.rmi.manualtradecompliance.view.administration;

import javax.faces.event.ActionEvent;

import oracle.adf.view.rich.component.rich.data.RichTable;

import oracle.jbo.uicli.binding.JUCtrlHierNodeBinding;

import org.apache.myfaces.trinidad.model.CollectionModel;
import org.apache.myfaces.trinidad.model.RowKeySet;

public class Administration {
    private RichTable logsTableObj;

    public Administration() {
    }

    public void deleteLogsActionListener(ActionEvent actionEvent) {
        // Add event code here...
        RowKeySet rowKeySet = logsTableObj.getSelectedRowKeys(); 
        CollectionModel cm = (CollectionModel)logsTableObj.getValue(); 
        for (Object facesTreeRowKey : rowKeySet) { 
            cm.setRowKey(facesTreeRowKey); 
            JUCtrlHierNodeBinding rowData = (JUCtrlHierNodeBinding)cm.getRowData();
            rowData.getRow().remove();
        } 
    }

    public void setLogsTableObj(RichTable logsTableObj) {
        this.logsTableObj = logsTableObj;
    }

    public RichTable getLogsTableObj() {
        return logsTableObj;
    }
}
