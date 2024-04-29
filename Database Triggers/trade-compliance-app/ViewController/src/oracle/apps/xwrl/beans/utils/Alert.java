package oracle.apps.xwrl.beans.utils;

import java.sql.SQLData;
import java.sql.SQLException;
import java.sql.SQLInput;
import java.sql.SQLOutput;

import oracle.adf.share.logging.ADFLogger;


public class Alert implements SQLData {
    @SuppressWarnings("compatibility:-5535997497583120177")
    private static final long serialVersionUID = -1234234351L;

    private static ADFLogger LOGGER = ADFLogger.createADFLogger(Alert.class);

    private String sqlType;
    private String pAlert;
    private String pToState;
    private String pComment;

    public Alert() {
        this("XWRL.XWRL_ALERT_IN_REC");
        LOGGER.fine("Alert1");
    }

    public Alert(final String sqlType) {
        this.sqlType = sqlType;
        LOGGER.fine("Alert2");
    }
    
    public Alert(final String pAlert, final String pToState, final String pComment) {
        this("XWRL.XWRL_ALERT_IN_REC");
        this.pAlert = pAlert;
        this.pToState = pToState;
        this.pComment = pComment;
        LOGGER.fine("Alert3");
    }    
    
    public Alert(final String sqlType, final String pAlert, final String pToState, final String pComment) {
        this.sqlType = sqlType;
        this.pAlert = pAlert;
        this.pToState = pToState;
        this.pComment = pComment;
        LOGGER.fine("Alert4");
    }  

    @Override
    public String toString() {
        return "Alert [" + pAlert + ", " + pToState + ", " + pComment + "]";
    }
    
    public void setSqlType(String sqlType) {
        this.sqlType = sqlType;
    }

    public String getSqlType() {
        LOGGER.fine("getSqlType");
        LOGGER.fine("sqlType: "+sqlType);
        return sqlType;
    }

    public void setPAlert(String pAlert) {
        this.pAlert = pAlert;
    }

    public String getPAlert() {
        return pAlert;
    }

    public void setPToState(String pToState) {
        this.pToState = pToState;
    }

    public String getPToState() {
        return pToState;
    }

    public void setPComment(String pComment) {
        this.pComment = pComment;
    }

    public String getPComment() {
        return pComment;
    }

    @Override
    public String getSQLTypeName() throws SQLException {
        // TODO Implement this method
        LOGGER.fine("getSQLTypeName");
        return getSqlType();
    }

    @Override
    public void readSQL(SQLInput sQLInput, String string) throws SQLException {
        // TODO Implement this method
        LOGGER.fine("readSQL");
        this.sqlType = sqlType;
        this.pAlert = sQLInput.readString();
        this.pToState = sQLInput.readString();
        this.pComment = sQLInput.readString();
    }

    @Override
    public void writeSQL(SQLOutput sQLOutput) throws SQLException {
        // TODO Implement this method
        LOGGER.fine("writeSQL");
        LOGGER.fine("sQLOutput: "+sQLOutput);
        LOGGER.fine("pAlert: "+pAlert);
        LOGGER.fine("pToState: "+pToState);
        LOGGER.fine("pComment: "+pComment);
        
        //sQLOutput.writeString(this.pAlert);
        sQLOutput.writeString(this.pAlert);
        sQLOutput.writeString(this.pToState);
        sQLOutput.writeString(this.pComment);
    }

}
