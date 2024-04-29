package com.rmi.manualtradecompliance.adfbc.utils;

import java.sql.CallableStatement;
import java.sql.SQLException;

import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;

import oracle.jbo.server.ApplicationModuleImpl;

public class AdfUtils {
    public AdfUtils() {
        super();
    }

    /**
     * Method to show simple facesMessage with header,detail, in html format.
     * @param header  Header of the FacesMesssage.
     * @param detail  Detail of the FacesMesssage.
     * @param severity  Severity of FacesMessage.
     */
    public static void addFormattedFacesErrorMessage(String header, String detail,
                                                 javax.faces.application.FacesMessage.Severity severity) {
        StringBuilder saveMsg = new StringBuilder("<html><body><b><span style='color:");
        
        if(severity != null)
        {
            if(severity.toString().equalsIgnoreCase("INFO 0"))
                saveMsg.append("#000000'>");
            else if(severity.toString().equalsIgnoreCase("WARN 1"))
                saveMsg.append("#000000'>");
            else if(severity.toString().equalsIgnoreCase("ERROR 2"))
                saveMsg.append("#000000'>");
            else
                saveMsg.append("#000000'>");
        }
        else
            saveMsg.append("#000000'>");
        
        saveMsg.append(header);
        saveMsg.append("</span></b>");
        saveMsg.append("</br><b>");
    //        saveMsg.append(detail);
        saveMsg.append("</b></body></html>");
        FacesMessage msg = new FacesMessage(saveMsg.toString());
        msg.setSeverity(severity);
        FacesContext.getCurrentInstance().addMessage(null, msg);
    }
    
    /**
     * Method calls/executes DB function passed as paramater.
     * @param sqlReturnType pass return type of the passed function.
     * @param stmt pass DB function name with no. of arguments.
     * @param bindVars pass array of Object type which contains required parameters.
     * @return Object returns function output returned by database.
     **/
    public static Object callDbFunction(ApplicationModuleImpl am, int sqlReturnType, String stmt, Object[] bindVars, String errorMsg) {
        CallableStatement st = null;
        try {
            st = am.getDBTransaction().createCallableStatement("begin ?:=" + stmt + ";end;", 0);

            st.registerOutParameter(1, sqlReturnType);

            if (bindVars != null) {
                for (int z = 0; z < bindVars.length; z++) {
                    //System.out.println("bindVars["+z+"] :: "+bindVars[z]);
                    st.setObject(z + 2, bindVars[z]);
                }
            }
            st.execute();

            return st.getObject(1);
        } catch (SQLException e) {
            e.printStackTrace();
                AdfUtils.addFormattedFacesErrorMessage(errorMsg +
                                                       "Please contact your System Administrator.", "",
                                                       FacesMessage.SEVERITY_ERROR);
        } finally {
            if (st != null) {
                try {
                    st.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                    AdfUtils.addFormattedFacesErrorMessage("System encountered an exception while fetching data." +
                                                           "Please contact your System Administrator.", "",
                                                           FacesMessage.SEVERITY_ERROR);
                }
            }
        }
        return null;
      }
}
