<%@ page language="java" import="java.util.*,java.net.InetAddress,java.net.* " %>
<html>
<body>
<h1>JVM Status:</h1>
<%
response.setDateHeader("Expires", 0);
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-cache");

java.text.DecimalFormat def=new java.text.DecimalFormat();
%>
Current time: <%= new java.util.Date() %><br/><%=System.getProperty("user.name") %>
Processors: <%= Runtime.getRuntime().availableProcessors() %><br/>	
Max memory: <%=def.format( Runtime.getRuntime().maxMemory()) %> (allowed max heap size)<br/>
Total memory: <%=def.format( Runtime.getRuntime().totalMemory()) %> (current heap size)<br/>
Free memory: <%=def.format(Runtime.getRuntime().freeMemory() ) %><br/>
<% long using=Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory(); %>
<b>Using memory: <%=def.format( using ) %></b><br/>

<% if ("y".equals(request.getParameter("gc")))
	{	
		//System.gc();
		Runtime.getRuntime().gc();
%>After GC:<br/>		
Max memory: <%=def.format( Runtime.getRuntime().maxMemory()) %> (allowed max heap size)<br/>
Total memory: <%=def.format( Runtime.getRuntime().totalMemory()) %> (current heap size)<br/>
Free memory: <%=def.format(Runtime.getRuntime().freeMemory() ) %><br/>
<% long using2=Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory(); %>
<b>Using memory: <%=def.format( using2) %></b><br/>
<b>GC released: <%=def.format( using-using2) %></b><br/>
<%		
}
%>
<a href="jvm.jsp?gc=y">Do GC</a>
<a href="jvm.jsp?gc=n">Reload WO GC</a>

<br/>
<% if ("y".equals("y")) //request.getParameter("si")))
{
%>
Server name: <%= request.getServerName() %><br/>
Temp: <%=System.getProperty("java.io.tmpdir") %><br/>
Java <%=System.getProperty("java.vm.name") %> <%=System.getProperty("java.vm.vendor") %> <%=System.getProperty("java.runtime.version") %><br/>
Container:  <%=pageContext.getServletContext().getServerInfo() %>
    <%="servlet-" + pageContext.getServletContext().getMajorVersion() + "." + pageContext.getServletContext().getMinorVersion() %><br/>
<br/>
DNS tests:<br/>
<%
String host="dsec.visa3dsecure.com";
for (int i=0; i<3; i++)
{	
	long dst=System.currentTimeMillis();
	java.net.InetAddress[] ipadresses = java.net.InetAddress.getAllByName(host);
	long den=System.currentTimeMillis();
	Thread.currentThread().sleep(500);
	StringBuilder results=new StringBuilder();
	for(int j=0; ipadresses!=null && j<ipadresses.length; j++)
	{
		results.append(ipadresses[j].toString()+", ");
	}
	%>DNS test getAllByName '<%=host %>' <%=i %>: <%=(den-dst) %>ms -> <%=results %><br/><%
}

for (int i=0; i<3; i++)
{	
	long dst=System.currentTimeMillis();
	java.net.InetAddress ipadresse = java.net.InetAddress.getByName(host);
	long den=System.currentTimeMillis();
	Thread.currentThread().sleep(500);
	%>DNS test getByName '<%=host %>' <%=i %>: <%=(den-dst) %>ms -> <%=ipadresse.toString() %><br/><%
}
%>
<br/>
JVM Info:<br/>
<%
for (java.util.Map.Entry<Object, Object> e : System.getProperties().entrySet())
{
	%><%=(e.getKey()+"='"+e.getValue()+"'<br/>") %><%
}	

%>
<br/>
<!-- 
Security providers and algorithms<br/>
<%
	for (java.security.Provider provider : java.security.Security.getProviders())
	{
 	%><%=( "Provider: " + provider.getName()+"<br/>") %>
 	<%
 	StringBuffer algs=new StringBuffer();
 	java.util.Set<java.security.Provider.Service> services=provider.getServices();
 	for (java.security.Provider.Service service : services)
 	{
	   	algs.append(service.getAlgorithm()+",");
 	}
 	%><%=(" Algorithms: " + algs.toString()) %><%
	}

    java.lang.management.ThreadInfo[] til = java.lang.management.ManagementFactory.getThreadMXBean().dumpAllThreads(false, false);
    StringBuilder tisb = new StringBuilder();
    for (java.lang.management.ThreadInfo ti : til)
    {
	tisb.append(ti.toString() + "\n");
    }
    %><br/><pre><%=(" Threads: " + tisb.toString()) %></pre><%

}	 
%>
<br>
Your ip: <%=request.getRemoteAddr() %>
<%
Enumeration<NetworkInterface> net = null;
	try
	{
	    net = NetworkInterface.getNetworkInterfaces();

	String ipAddr ="";
	while (net.hasMoreElements())
	{
	    NetworkInterface element = net.nextElement();
	    try
	    {
		if (element.isLoopback())
		{
		    continue;
		}
	    }
	    catch (SocketException e)
	    {
		throw new RuntimeException(e);
	    }

	    Enumeration<InetAddress> addresses = element.getInetAddresses();

	    while (addresses.hasMoreElements())
	    {
		InetAddress ip = addresses.nextElement();
		if (!ip.isLoopbackAddress())
		{

//		    ipAddr = ipAddr+" "+ip.getHostAddress();
		    if (ip instanceof Inet4Address)
		    {
			//break;
		    ipAddr = ipAddr+" "+ip.getHostAddress()+"<br/>";

		    }
		}
	    }
	}
%>
 -->
<br>
Server ip: <%=ipAddr %>
<%
	}
	catch (SocketException e)
	{
	    
	}
%>
</body>
</html>