package oracle.apps.xwrl.beans.utils;

import java.io.Serializable;

import java.util.List;

public class UploadedFiles implements Serializable{
    @SuppressWarnings("compatibility:2169046128067521232")
    private static final long serialVersionUID = 1L;
    private List filesList;

    public void setFilesList(List filesList) {
        this.filesList = filesList;
    }

    public List getFilesList() {
        return filesList;
    }

    public UploadedFiles() {
        super();
    }
}
