<%@ page language="java" contentType="text/html;charset=big5" errorPage="../invoErrorPage.jsp"%>
<%@page import="java.net.*" %>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="java.io.*, java.util.*" %>
<%@page import="models.chtmbr.*" %>
<%@page import="org.owasp.esapi.ESAPI, org.owasp.esapi.Validator" %>
 <jsp:useBean id="dt7" class="boss.dt_proc_dt" scope="request" /> 
<jsp:useBean id="mbrTool" class="inv_beans.CHTMember2"/>
<jsp:useBean id="iputils"  class="tool.IPutils" >
  <jsp:setProperty name="iputils" property="forwardedIP" value="${header['x-forwarded-for']}" />
  <jsp:setProperty name="iputils" property="remoteIP" value="${pageContext.request.remoteAddr}" />  
  <jsp:setProperty name="iputils" property="adminLoginIP" value="${sessionScope.hp4_cip}"/>  
</jsp:useBean> 
<jsp:useBean id="invDBTool" scope="page" class="inv_beans.invDB">
  <jsp:setProperty name="invDBTool" property="jndina" value="${applicationScope.jdna}"  />
</jsp:useBean>

<html>
	<head></head>
	<body>
  <%
  Validator validator = ESAPI.validator();
  String logFileName = "auth_Crmbr.jsp";
//  Logger log= Logger.getLogger(logFileName);
  System.setProperty("logFileName", logFileName);
  JsonObject logparam = new JsonObject();
  logparam.addProperty("sessionid", session.getId());
  logparam.addProperty("clientip", iputils.getIp());
  
//  org.apache.log4j.xml.DOMConfigurator.configure(request.getServletContext().getInitParameter("log4jxml"));
  String ip = iputils.getIp();
//  log.setLevel(Level.DEBUG);
  session.setAttribute("logPage","6" );
  System.out.print("session id auth mbr :"+ session.getId()+"\n");
  String dat1 = dt7.dt_get_today();
  String dtime = dt7.dt_get_now_time();
  String domainName = (String)request.getServletContext().getAttribute("domainName");
	String siteid="183";
	String serviceID="invoice";
	String cardtype="common";
	String serverURL = "https://"+(String)request.getServletContext().getAttribute("MBRServer");
	String channelurl= "https://"+domainName+"/invoice/login.jsp";
    
  	/*	from request  */
    String otpw=""+request.getParameter("otpw");
  	otpw = validator.getValidInput("otpw", otpw, "nosign", 80, false);
    //String channelurl=""+request.getParameter("channelurl");   
    String others=""+request.getParameter("others");
    /* form session*/
    String others_s = ""+session.getAttribute("others");

    /* form cookies */
    String otpw_c = "";
    Cookie[] cookies=request.getCookies();
    if (cookies!=null){
	    for(int i=0;i<cookies.length;i++){
	      if(cookies[i].getName().equals("otpw")){            	
	        otpw_c=  cookies[i].getValue();
	      }
	    }
	  }

/* 
*  if otpw/others is null or others not as same as others in session,
*  that's incorrect way to login, back to login page to get otpw/others
*/
   
    if (otpw.equals("null") || others.equals("null") || !others.equals(others_s)){
	    session.setAttribute("errorReason","dataNotCorrect" );
	    logparam.addProperty("message", "otpw/others not correct");
//	    log.fatal(logparam);
		  throw new Exception("[auth_Crmbr] ip:"+ip+" ,otpw = null/ others incorrect otpw:"+ otpw + "  others:"+others +" others_s:"+others_s);
    } else if(!otpw_c.equals(otpw)){
		  session.setAttribute("errorReason","dataNotCorrect" );
		  logparam.addProperty("message", "otpw/others not correct");
//		  log.fatal(logparam);
		  throw new Exception("[auth_Crmbr] ip:"+ip+" ,otpw not equals it in cookies "+ otpw + "cookies: "+otpw_c);
    } else {
      HashMap<String, String> data = mbrTool.getUserDataMap(serverURL, otpw);
   		MemberLoginAuth auth = mbrTool.getAuth();
   		String usrid = validator.getValidInput("usrid", "mr"+auth.getSn(), "usrid", 14, false);
		  String idno = data.get("dssn");
      out.println("<BR>" + "usrid:" + usrid);
      out.println("<BR>" + "idno:" + idno);
    }

      out.println("<BR>" + "serverURL:" + serverURL);
      out.println("<BR>" + "channelurl:" + channelurl);
      out.println("<BR>" + "otpw:" + otpw);
      out.println("<BR>" + "others:" + others);
      out.println("<BR>" + "others_s:" + others_s);
      out.println("<BR>" + "otpw_c:" + otpw_c);
  %>
  </body>
  
</html>
