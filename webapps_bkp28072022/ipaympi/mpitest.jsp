<%@page language="java" session="true" import="org.apache.log4j.Logger, com.a2zss.mpi.*, com.a2zss.util.web.HTMLHelp" 
%><% request.setCharacterEncoding("UTF-8"); response.setCharacterEncoding("UTF-8");	
%><%! 
	// minimal code here
	static Logger log = org.apache.log4j.Logger.getLogger("com.a2zss.mpi.extint.mpitest.jsp");
	static String[] reqParams={"schema","merchantId","transactionId","pan","expiration","purchaseDate","purchaseAmount","currencyCodeNum",
			"currencyCodeChr","currencyExponent","returnUrl"};
	static String[] respParams={"merchantId","transactionId","enrollmentStatus","authenticationStatus","details","xid","eci",
			"cavv","cavvAlg"};


	public String getReqMAC(HttpServletRequest req, boolean resp)
	{
		StringBuilder sb=new StringBuilder();
		for(String pn : resp ? respParams : reqParams)
		{
			String v=req.getParameter(pn);
			sb.append(v).append(';');
		}
		sb.append(this.getServletContext().getInitParameter("secret"));
		if (log.isDebugEnabled())
		{
			String d=sb.toString();
			String pan=req.getParameter("pan");
			if (!com.a2zss.util.Misc.isne(pan))
			{
				StringBuilder maskpan=new StringBuilder(pan);
				for (int i=4; i<maskpan.length()-3; i++)
				{
					maskpan.setCharAt(i, '#');
				}
				d= com.a2zss.util.Misc.replace(d, pan, maskpan.toString());
			}

			log.debug("Mac base="+d);
		}	
		
		try {
		return com.a2zss.mpi.MPIExtIntService.calulateMacSHA256(sb);
		} catch (Exception e)
		{
			throw new RuntimeException(e);
		}
	}
	
	public String getValue(String param, HttpServletRequest req)
	{
		String v=req.getParameter(param);
		if (v==null && req.getSession(false)!=null)
		{
			v=(String)req.getSession().getAttribute(param);
		}	
		if (v==null)
		{
			if ("schema".equals(param))
			{	
				v="VISA3DS";
			}
			if ("merchantId".equals(param))
			{	
				v="1";
			}
			if ("expiration".equals(param))
			{	
				v="2512";
			}
			if ("purchaseAmount".equals(param))
			{	
				v="127";
			}
			if ("currencyCodeNum".equals(param))
			{	
				v="978";
			}
			if ("currencyCodeChr".equals(param))
			{	
				v="EUR";
			}
			if ("currencyCodeChr".equals(param))
			{	
				v="EUR";
			}
			if ("currencyExponent".equals(param))
			{	
				v="2";
			}
			if ("pan".equals(param))
			{	
				v="4016000000002";
			}			
			if ("purchaseDate".equals(param))
			{	
				java.text.SimpleDateFormat df=new java.text.SimpleDateFormat("yyyyMMdd HH:mm:ss");
				df.setTimeZone(java.util.TimeZone.getTimeZone("GMT"));
				v=df.format(new java.util.Date());
			}
			if ("serviceUrl".equals(param))
			{	
				v="mpi.jsp";
			}
			
			
		}	
		
		return v;
	}

%><!DOCTYPE html>
<html>
<head><title>TEST: IPAY3DSMPI</title></head>
<body>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="styles.css"></head>
<body bgcolor="#FFFFFF">

<% 
if (request.getParameter("testBtn")!=null || request.getParameter("start")!=null)
	{

		if (request.getSession(false)!=null)
		{
			request.getSession(false).setAttribute("serviceUrl", getValue("serviceUrl", request));
			request.getSession(false).setAttribute("schema", getValue("schema", request));
			request.getSession(false).setAttribute("merchantId", getValue("merchantId", request));
			request.getSession(false).setAttribute("pan", getValue("pan", request));
			request.getSession(false).setAttribute("expiration", getValue("expiration", request));
			request.getSession(false).setAttribute("purchaseAmount", getValue("purchaseAmount", request));
			request.getSession(false).setAttribute("currencyCodeNum", getValue("currencyCodeNum", request));
			request.getSession(false).setAttribute("currencyCodeChr", getValue("currencyCodeChr", request));
			request.getSession(false).setAttribute("currencyExponent", getValue("currencyExponent", request));
			
		}			
		
%>
<h2>Proceed to MPI</h2>
<form name="proceeed" action="<%=getValue("serviceUrl", request) %>" method="POST">
<input type="hidden" size="20" name="schema" value="<%=getValue("schema", request) %>"/>
<input type="hidden" size="20" name="merchantId" value="<%=getValue("merchantId", request) %>"/>
<input type="hidden" size="20" name="transactionId" value="<%=getValue("transactionId", request) %>"/>
<input type="hidden" size="20" name="pan" value="<%=getValue("pan", request) %>"/>
<input type="hidden" size="10" name="expiration" value="<%=getValue("expiration", request) %>"/>
<input type="hidden" size="20" name="purchaseDate" value="<%=getValue("purchaseDate", request) %>"/>
<input type="hidden" size="12" name="purchaseAmount" value="<%=getValue("purchaseAmount", request) %>"/>
<input type="hidden" size="5" name="currencyCodeNum" value="<%=getValue("currencyCodeNum", request) %>"/>
<input type="hidden" size="5" name="currencyCodeChr" value="<%=getValue("currencyCodeChr", request) %>"/>
<input type="hidden" size="5" name="currencyExponent" value="<%=getValue("currencyExponent", request) %>"/>
<input type="hidden" size="5" name="returnUrl" value="<%=getValue("returnUrl", request) %>"/><br/>
<input type="hidden" size="5" name="mac" value="<%=getReqMAC(request, false) %>"/><br/>

	Please wait 3D Secure processing...<br/>

<input id="proceedBtn" type="submit" name="proceed" value="Proceed "/>
</form>
	<script type="text/javascript">
		document.forms.proceeed.submit();
		document.getElementById("proceedBtn").style.display="none";
	</script>

<% 
	}
	else if (request.getParameter("enrollmentStatus")!=null)
	{
		%><h2>Return FROM MPI</h2>
		<a href="mpitest.jsp">Start over</a><br/>
		<%
			String cmac=getReqMAC(request, true);
			%>Calc MAC='<%=cmac %>' Matches=<%=cmac.equals(request.getParameter("mac")) %><%
		%>
		<br/>
		<%
	}
	else
	{	
%>
<h2>Create test case</h2>
<form name="params" action="mpitest.jsp" method="POST">
<table>
<tr><td>Service URL:</td><td><input type="text" size="100" name="serviceUrl" value="<%=getValue("serviceUrl", request) %>"/></td></tr>
<tr><td>Schema:</td><td><input type="text" size="20" name="schema" value="<%=getValue("schema", request) %>"/></td></tr>
<tr><td>Merchant Id:</td><td><input type="text" size="20" name="merchantId" value="<%=getValue("merchantId", request) %>"/></td></tr>
<tr><td>Tx Id:</td><td><input type="text" size="20" name="transactionId" value="<%=System.currentTimeMillis() %>"/></td></tr>
<tr><td>Pan:</td><td><input type="text" size="20" name="pan" value="<%=getValue("pan", request) %>"/></td></tr>
<tr><td>Exp YYMM:</td><td><input type="text" size="10" name="expiration" value="<%=getValue("expiration", request) %>"/></td></tr>
<tr><td>Purchase date GMT:</td><td><input type="text" size="20" name="purchaseDate" value="<%=getValue("purchaseDate", request) %>"/></td></tr>
<tr><td>Purchase amt:</td><td><input type="text" size="12" name="purchaseAmount" value="<%=getValue("purchaseAmount", request) %>"/></td></tr>
<tr><td>Curr code num:</td><td><input type="text" size="5" name="currencyCodeNum" value="<%=getValue("currencyCodeNum", request) %>"/></td></tr>
<tr><td>Curr code chr:</td><td><input type="text" size="5" name="currencyCodeChr" value="<%=getValue("currencyCodeChr", request) %>"/></td></tr>
<tr><td>Curr exp:</td><td><input type="text" size="5" name="currencyExponent" value="<%=getValue("currencyExponent", request) %>"/></td></tr>
<tr><td>returnUrl:</td><td><input type="text" size="100" name="returnUrl" value="<%=request.getRequestURL() %>"/></td></tr>
</table>

<input type="hidden" name="start" value="true"/>
<input type="submit" name="testBtn" value="Start test"/>
</form>
Req params:
<% }


java.util.Enumeration en=request.getParameterNames();

while(en.hasMoreElements())
{	String pn=""+en.nextElement();
	%><%=pn+"='"+request.getParameter(pn)+"'" %><br/><%
}

%>
</body>
</html>