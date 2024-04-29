package oracle.apps.xwrl.beans.converter;

import javax.faces.application.FacesMessage;

import javax.faces.component.UIComponent;

import javax.faces.context.FacesContext;

import javax.faces.convert.Converter;

import javax.faces.convert.ConverterException;

import oracle.jbo.domain.ClobDomain;

import oracle.jbo.domain.DataCreationException;

public class ClobConverter implements Converter {

    public ClobConverter() {

    }

   
    public Object getAsObject(FacesContext facesContext, UIComponent uIComponent, String string) {
        if (string == null) 
        {
            return null;
        }

        try {
            return new ClobDomain(string);
        } catch (Exception ex) {
            final String message =
                String.format("Unable to convert String value \"%s\" into a oracle.jbo.domain.ClobDomain", string);
            throw new ConverterException(message, ex);
        }
    }

    
    public String getAsString(FacesContext facesContext, UIComponent uIComponent, Object object) 
    {
        return object.toString();
    }
}
