<%@ page isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
<title>Application general error</title>
</head>
<body>
	<div align="center">
		Sorry, application encountered system failure, if this repeats contact
		administrator<br />
		<%
			String errId = "E" + System.currentTimeMillis();
		%>
		Error reference
		<%=errId%>
		<br />
		<br />
		<%
			try
			{
				if (pageContext != null && pageContext.getErrorData() != null)
				{
					org.apache.log4j.Logger log = org.apache.log4j.Logger.getLogger("com.a2zss.mpi.extinterr");
					log.error("MPI error id " + errId + " uri " + pageContext.getErrorData().getRequestURI(), pageContext.getErrorData()
							.getThrowable());
				}

			}
			catch (Exception e)
			{
			}
		%>
	</div>
</body>
</html>
