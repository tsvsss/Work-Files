package oracle.apps.xwrl.model.generic;

import java.util.ListResourceBundle;

public class CustomMessageBundle extends ListResourceBundle {
    private static final Object[][] sMessageStrings = new String[][] 
        { 
          {"25014","Another User has already made changes to this record. Please access the record again and make changes",
           "26092","Another User has already made changes to this record. Please access the record again and make changes"} 
        };

    /**Return String Identifiers and corresponding Messages in a two-dimensional array.
     */
    protected Object[][] getContents() {
        return sMessageStrings;
    }
}
