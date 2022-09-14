<%@page language="java" session="false"
	import="org.apache.log4j.Logger, com.a2zss.mpi.*, com.a2zss.util.web.HTMLHelp"%>
<% request.setCharacterEncoding("UTF-8"); response.setCharacterEncoding("UTF-8");	
%><%!// minimal code here
	static Logger log = org.apache.log4j.Logger.getLogger("com.a2zss.mpi.extint.mpi.jsp");
	MPIExtIntService mpiints = null;

	// servlet initialization
	public void jspInit() {
		try {
			mpiints = new MPIExtIntService();
			mpiints.init(getServletContext());
			log.info("MPI JSP intialized");
		} catch (Exception e) {
			log.error("Failed to initialize mpi jsp", e);
			throw new RuntimeException(e);

		}
	}%>
<% // request servicing
	java.util.Map<String,String> results=mpiints.processRequest(request, response); 
	// if no results (was redirected to acs)  then return nothing more to display here	
	if (results==null)
	{
		return;
	}	

	%>
<!DOCTYPE html>
<html>
<head>
<title>IPAY3DSMPI</title>
</head>
<body>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link rel="stylesheet" href="styles.css">
</head>
<body bgcolor="#FFFFFF">
	<p align="center">
		<br>
<% 
if (results!=null && results.get("feedBackUrl")!=null && results.get("feedBackUrl").length()>0)
{ 
%>
		<b> <font face="Arial, Helvetica, sans-serif">Please return
				to merchant..</font></b>
	</p>
	<table align="center">
		<tr>
			<td>
				<form name="returnForm" action="<%=results.get("feedBackUrl") %>"
					method="POST">
					<% 
	for(java.util.Map.Entry<String,String> e : results.entrySet())
	{
		if ("feedBackUrl".equals(e.getKey()))
		{
			continue;
		}	
		
		%><input type="hidden" name="<%=e.getKey() %>" value="<%=HTMLHelp.esc(e.getValue()) %>" />
<% } %> 
		<input	class="button" type="submit" name="submitbtn" value="Return to merchant">
		</form>
			</td>
		</tr>
	</table>
	<script type="text/javascript">
		document.forms.returnForm.submit();
	</script>

	<% 
}
else
{ // no return url
%><p align="center">
		<br> <b>MPI Processing error</b>
	</p>
	<% for(java.util.Map.Entry<String,String> e : results.entrySet())
	{
	%><br /><%=HTMLHelp.esc(e.getValue()) %>
	<%
	}
}
%>
	<br />
</body>
</html>