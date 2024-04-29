package oracle.apps.xwrl.model.generic;

import oracle.jbo.common.Diagnostic;
import oracle.jbo.server.OracleSQLBuilderImpl;
import oracle.jbo.server.SQLBuilder;

public class OracleSQLBuilderImplEX extends OracleSQLBuilderImpl {
    private static SQLBuilder mSQLBuilderInterface = null;
    private static final String FOR_UPDATE_WAIT = "FOR UPDATE WAIT 30"; // wait up to 30 seconds, to acquire lock

    public OracleSQLBuilderImplEX() {
        super();
    }

    /**
     * Gets the singleton instance of this class.
     * This is required by the framework in order
     * to override the default SQLBuilder
     * @return a <tt>SQLBuilder</tt> object.
     */
    public static SQLBuilder getInterface() {
        if (mSQLBuilderInterface == null) {
            if (Diagnostic.isOn()) {
                Diagnostic.println("OracleSQLBuilder reached getInterface");
            }
            mSQLBuilderInterface = (SQLBuilder)(new OracleSQLBuilderImplEX());
            if (Diagnostic.isOn()) {
                Diagnostic.println(mSQLBuilderInterface.getVersion());
            }
        }
        return mSQLBuilderInterface;
    }


    @Override
    protected String getSqlVariantLockTrailer() {
        // change default FOR UPDATE NOWAIT to FOR UPDATE WAIT 30, to avoid lock error
        return FOR_UPDATE_WAIT;
    }
}

