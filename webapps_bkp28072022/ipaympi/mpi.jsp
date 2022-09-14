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

  <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Credit Card Payment</title>

    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/fontawesome.min.css">
    <link href="css/loading.min.css" rel="stylesheet">
    <link href="css/ldbtn.min.css" rel="stylesheet">
    <!-- Custom styles for this template -->
    <link href="css/app.css" rel="stylesheet">
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
	 <div class="container-fluid auth-bg">
      <div class="min-vh-100 py-5 d-flex align-items-center">
        <div class="w-100">
          <div class="row justify-content-center">
            <div class="col-sm-8 col-lg-6">
              <div class="card shadow zindex-100 mb-0 border-0">
                <div class="card-header">
                  <div class="media align-items-center">
                    <img class="mr-2" src="images/ezswype_logo.png" height="30">
                    <div class="media-body">
                      <h6 class="m-0 text-dark">Action Info Title</h6>
                    </div>
                  </div>
                </div>
                <div class="card-body text-center p-5">
                  <div class="mb-4">
                    <div class="fa-4x">
                      <i class="fas fa-spinner fa-spin"></i>
                    </div>
                  </div>
                  <h4>Please Wait</h4>
                  <p>Processing Transaction...Please wait</p>
                </div>
                <div class="card-footer d-flex align-items-center">
                  <div>
                    <a href="#" class="small font-weight-bold">Action Link</a>
                  </div>
                  <div class="ml-auto">
                    <img src="images/credopay_logo.png" width=100>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
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