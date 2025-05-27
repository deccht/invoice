<jsp:useBean id="mbrTool" class="inv_beans.CHTMember2"/>
<%@page import="java.net.URLEncoder,java.security.SecureRandom" %>
<%@page import="java.net.URLEncoder" %>
<%@page import="org.owasp.esapi.ESAPI"%>
<%@page import="org.owasp.esapi.Encoder"%>
<%@page import="org.owasp.esapi.Validator"%>
<%@ include file ="../newip1.jsp" %>
<%@ page language="java" contentType="text/html;charset=big5" %>
<html>
	<head>
  	 
  </head>
	<body>
  <%
	Validator v = ESAPI.validator();  
  String domainName = (String)request.getServletContext().getAttribute("domainName");  
   // reset session to prevent session  fixnation attack
//  response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
//  response.setHeader("Pragma", "no-cache");
//  response.setHeader("Expires", "0");
//  if(session.getAttribute("testing")== null)
//	session.invalidate();
//  session = request.getSession(); 
  String option=""+(String)request.getParameter("option");
  
  /* CHT �|���t�ΰѼ�  */
  //��g�|���t�εn�J���󪩥�
  String version="1.0";
  //��g�z��siteid
  String siteid="183";
  //��gauthorize.php��URL
  String curl="https://"+domainName+"/invoice/chtmbr/auth_Crmbr.jsp";
  //��g""�Y�i(�ثe�Ȥ��ϥ�)
  String sessionid="";
  //��g�n�J��n�ɦܪ�����
  // String channelurl=hturl+"/invoice/login.jsp";
  String channelurl="";
  //��g�Q�B�~�a���Ѽ�(a random number)
  //String others=String.valueOf(Math.round(Math.random()*10000));
  // 1090114: use secureRandom
  SecureRandom sr = SecureRandom.getInstance("SHA1PRNG");
  String others = String.valueOf(Math.round(sr.nextDouble()*10000));
  
  session.setAttribute("others", others);
  //��g�|���t�Ϊ����}(������https)
  String mbrServer = (String)request.getServletContext().getAttribute("MBRServer");
  mbrServer = "https://"+ v.getValidInput("mbrServer", mbrServer, "domain_chtmember", 50, false);
  
  String checkSum=mbrTool.getChecksum(version + curl+siteid+sessionid+channelurl+others);
  String loginURL = mbrServer+"/HiReg/checkcookieservlet?version="+version
        +"&curl="+curl+"&siteid="+siteid+"&sessionid="+sessionid+"&channelurl="+channelurl
        +"&others="+others+"&checksum="+checkSum;   
  URLEncoder.encode (loginURL, "UTF-8"); 
  //System.out.print("session id login mbr :"+ session.getId()+"\n");
  String redirectURL="";
  
  /* �੹�|�����߳]�w�������� */
  switch(option){
    case "setIDno":
       redirectURL = mbrServer+"/chtdevice/index-dssn.jsp";
       break;
    case "joinMember":
       redirectURL = mbrServer+"/CHTRegi/register.jsp";
       break;
    default:
      redirectURL = loginURL;
      break;
  }
   
  response.sendRedirect(redirectURL);
  %>

  </body>
  <script type="text/javascript">
   top.location.href="<%=loginURL%>";
  </script>
  
</html>
