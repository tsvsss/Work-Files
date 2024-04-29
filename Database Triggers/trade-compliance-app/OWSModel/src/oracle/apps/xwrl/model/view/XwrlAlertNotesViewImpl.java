package oracle.apps.xwrl.model.view;

import java.math.BigDecimal;

import oracle.jbo.server.ViewObjectImpl;
// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    Sun Oct 27 14:09:46 EDT 2019
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------
public class XwrlAlertNotesViewImpl extends ViewObjectImpl {
    /**
     * This is the default constructor (do not remove).
     */
    public XwrlAlertNotesViewImpl() {
    }

    /**
     * Returns the variable value for p_xrefAlertId.
     * @return variable value for p_xrefAlertId
     */
    public String getp_xrefAlertId() {
        return (String) ensureVariableManager().getVariableValue("p_xrefAlertId");
    }

    /**
     * Sets <code>value</code> for variable p_xrefAlertId.
     * @param value value to bind as p_xrefAlertId
     */
    public void setp_xrefAlertId(String value) {
        ensureVariableManager().setVariableValue("p_xrefAlertId", value);
    }

    /**
     * Returns the variable value for p_id.
     * @return variable value for p_id
     */
    public BigDecimal getp_id() {
        return (BigDecimal) ensureVariableManager().getVariableValue("p_id");
    }

    /**
     * Sets <code>value</code> for variable p_id.
     * @param value value to bind as p_id
     */
    public void setp_id(BigDecimal value) {
        ensureVariableManager().setVariableValue("p_id", value);
    }
}

