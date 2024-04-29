package com.rmi.manualtradecompliance.adfbc.utils;

import com.rmi.manualtradecompliance.adfbc.services.RMIManualTradeComplianceAppModuleImpl;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;

import java.math.BigDecimal;

import java.sql.CallableStatement;

import java.sql.Clob;
import java.sql.Connection;


import java.util.Calendar;
import java.util.Map;


import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;

import oracle.adf.share.ADFContext;

import oracle.jbo.Row;
import oracle.jbo.ViewObject;


public class LogUtils {
    public static String ERROR = "ERROR";
    public static String VALIDATION_ERROR = "VALIDATION ERROR";
    public LogUtils() {
        super();
    }
    
    /**
     *  Method returns the Stack trace of any error occurred.
     *  @param e pass the instance of Exception class.
     *  @return String returns the log of the exception generated.
     **/  
    public static String returnStackTrace(Exception e) 
    {
        if(e == null)
            return null;
        Writer writer = new StringWriter();
        PrintWriter printWriter = new PrintWriter(writer);
        e.printStackTrace(printWriter);
        String stackTrace = nullStrToSpc(writer);
        return stackTrace;
    }
    
    /**
     *  Method converts and returns null String value to blank space.
     *  @param obj pass String value to be checked.
     *  @return String returns either the String value or blank space.
     **/  
    private static String nullStrToSpc(Object obj) 
    {
        String spcStr = "";

        if (obj == null) 
        {
            return spcStr;
        } else 
        {
            return obj.toString();
        }
    }
    
    
}
