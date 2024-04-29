
<%@ page language="java" import="java.io.*"%>

<%
  String contentType = request.getContentType();
  String uploadPath= request.getParameter("path");
  
  out.println("FileUploadService.jsp called !!");
  out.println("path :: "+uploadPath);
  
  if ((contentType != null) && (contentType.indexOf("multipart/form-data") >= 0))
  {
	out.println("inside if :: "+contentType+" -- "+contentType.indexOf("multipart/form-data"));
    DataInputStream in = new DataInputStream(request.getInputStream());
    int formDataLength = request.getContentLength();
    byte dataBytes[] = new byte[formDataLength];
    int byteRead = 0;
    int totalBytesRead = 0;
    
    while (totalBytesRead < formDataLength)
    {
      byteRead = in.read(dataBytes, totalBytesRead, formDataLength);
      totalBytesRead += byteRead;
    }
    in.close();
    
    File fileToRecv = new File(uploadPath);
    fileToRecv.createNewFile();
    
    FileOutputStream fileOut = new FileOutputStream(fileToRecv);
    
    fileOut.write(dataBytes);
    
    fileOut.flush();
    fileOut.close();
	
	out.println("exitting FileUploadService.jsp !!");
  }
%>