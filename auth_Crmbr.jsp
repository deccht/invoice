<%/*
106.04.25	調整idno == null，跳轉至設定證號頁面
*/%>
<%@ page language="java" contentType="text/html;charset=UTF-8" errorPage="../invoErrorPage.jsp"%>
<%@ page import="java.net.*" %>
<%@ page import="com.google.gson.JsonObject"%>
<%@ page import="java.io.*, java.util.*" %>
<%@ page import="java.util.Base64, java.util.TreeMap, java.util.Map, javax.crypto.Mac, javax.crypto.spec.SecretKeySpec" %>
<%@ page import="models.chtmbr.*" %>
<%@ page import="org.slf4j.LoggerFactory" %>
<%@ page import="org.slf4j.Logger" %>
<%@ page import="org.owasp.esapi.ESAPI, org.owasp.esapi.Validator" %>
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
	<head>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            box-sizing: border-box;
        }

        .result {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .success {
            color: green;
            font-weight: bold;
        }

        .error {
            color: red;
            font-weight: bold;
        }
    </style>
  </head>
	<body>
  <%
  Validator validator = ESAPI.validator();
  String logFileName = "auth_Crmbr.jsp";
  Logger log= LoggerFactory.getLogger(logFileName);
  System.setProperty("logFileName", logFileName);
  JsonObject logparam = new JsonObject();
  logparam.addProperty("sessionid", session.getId());
  logparam.addProperty("clientip", iputils.getIp());

  String ip = iputils.getIp();
  //session.setAttribute("logPage","6" );
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
		  log.error(String.valueOf(logparam));
		  throw new Exception("[auth_Crmbr] ip:"+ip+" ,otpw = null/ others incorrect otpw:"+
		  otpw + "  others:"+others +" others_s:"+others_s);
    } else if(!otpw_c.equals(otpw)){
		  session.setAttribute("errorReason","dataNotCorrect" );
		  logparam.addProperty("message", "otpw/others not correct");
		  log.error(String.valueOf(logparam));
		  throw new Exception("[auth_Crmbr] ip:"+ip+" ,otpw not equals it in cookies "+
		  otpw + "cookies: "+otpw_c);
    } else {
      log.info("login correct get data");
      log.info("serverURL"+serverURL);
      log.info("otpw"+otpw);
   		HashMap<String, String> data = mbrTool.getUserDataMap(serverURL, otpw);
   		log.info("login correct get data 2");
   		MemberLoginAuth auth = mbrTool.getAuth();
   		String usrid = validator.getValidInput("usrid", "mr"+auth.getSn(), "usrid", 14, false);
		  String idno = data.get("dssn");
		  /* 無身分證字號轉到會員設定頁面 */
//		  out.println("<BR>usrid=" + usrid);
//		  out.println("<BR>idno=" + idno);
		  if(idno == null || idno.equals("")){
			  logparam.addProperty("message", " user not set idno, redirect to tutorial");
			  log.error(String.valueOf(logparam));
//			response.sendRedirect("redirect_mbr.jsp?option=idno");
			  out.println("<BR>無法取得會員相關証號");
        out.println("<BR>請查明後由整合平台重新操作");
		  }else{
			  idno = validator.getValidInput("idno", data.get("dssn"), "nosign", 12, false);
			  /* 進去index.jsp 需要的參數 */
//			session.setAttribute("usrid", usrid );
//			session.setAttribute("logid", usrid );      
//			session.setAttribute("PId",idno );
			  /* 移除管理者登入權限選項 */
//			session.removeAttribute("ldapid");
//			session.removeAttribute("qry_option");
//			invDBTool.insertLog(usrid,"", idno, dat1, dtime,"C001", ip,"", "", "", "");
			  logparam.addProperty("idno", idno);
			  logparam.addProperty("message", "login success");
			  log.info(String.valueOf(logparam));
//			response.sendRedirect("../index.jsp"); 
//			  out.println("<BR>身分證字號idno=" + idno);
//------------------------
			  String token = (String) session.getAttribute("ctoken"); // 必填，從 session 中取得
//        out.println("<BR>idno=" + idno);
//        out.println("<BR>token=" + token);
        if (idno == null || token == null) {
  				out.println("<p>查無會員資料，無法構建歸戶所需資料。</p>");
	  			return;
		  	}
			  String cardBan = "96979933"; // 必填，會員載具申請之統一編號
        String cardNo1Raw = idno; // 使用原始值
        String cardNo2Raw = idno; // 使用原始值
        String cardTypeRaw = "EJ0030"; // 使用原始值
			  // APIKEY (大平台提供) EJ0030
        String apiKey = "Xh8gAEbiBm2Sym3hCDFl3g==";

        // 構建參數（簽名用，使用原始值）
        Map<String, String> params = new TreeMap<>(); // 使用 TreeMap 自動按鍵名排序
        params.put("card_ban", cardBan);
        params.put("card_no1", cardNo1Raw); // 使用原始值
        params.put("card_no2", cardNo2Raw); // 使用原始值
        params.put("card_type", cardTypeRaw); // 使用原始值
        params.put("token", token);

        // 生成簽名 (signature)
        String signature = "";
        try {
          // 1. 拼接參數字串
          StringBuilder dataToSign = new StringBuilder();
          for (Map.Entry<String, String> entry : params.entrySet()) {
            if (dataToSign.length() > 0) {
              dataToSign.append("&");
            }
            dataToSign.append(entry.getKey()).append("=").append(entry.getValue());
          }

          // 2. 使用 HMAC-SHA256 加密
          Mac mac = Mac.getInstance("HmacSHA256");
          SecretKeySpec secretKeySpec = new SecretKeySpec(apiKey.getBytes("UTF-8"), "HmacSHA256");
          mac.init(secretKeySpec);
          byte[] hmacBytes = mac.doFinal(dataToSign.toString().getBytes("UTF-8"));

          // 3. 將加密結果進行 Base64 編碼
          signature = Base64.getEncoder().encodeToString(hmacBytes);
        } catch (Exception e) {
          out.println("<p>生成簽名時發生錯誤：" + e.getMessage() + "</p>");
        }

        // 構建 POST 資料（使用 Base64 編碼後的值）
        String cardNo1 = Base64.getEncoder().encodeToString(cardNo1Raw.getBytes("UTF-8"));
        String cardNo2 = Base64.getEncoder().encodeToString(cardNo2Raw.getBytes("UTF-8"));
        String cardType = Base64.getEncoder().encodeToString(cardTypeRaw.getBytes("UTF-8"));

        params.put("signature", signature); // 將簽名加入參數
        params.put("card_no1", cardNo1); // 更新為 Base64 編碼後的值
        params.put("card_no2", cardNo2); // 更新為 Base64 編碼後的值
        params.put("card_type", cardType); // 更新為 Base64 編碼後的值

        // 構建 POST 資料
        StringBuilder postData = new StringBuilder();
        for (Map.Entry<String, String> entry : params.entrySet()) {
          if (postData.length() > 0) {
            postData.append("&");
          }
          postData.append(entry.getKey()).append("=").append(entry.getValue());
        }

        // 回傳給大平台(測試環境)
        String postUrl = "https://wwwtest-bindapi.einvoice.nat.gov.tw/btc/cloud/bind/btc101i/carrierFormPost"; // 測試環境 URL
        %>
        <div class="result">
          <img src="../images/chtLogo.png" class="img-fluid hidden-lg-up" style="max-width: 200px" alt="中華電信電子發票系統">

          <h1>會員載具歸戶</h1>
          <p>以下是將回傳至整合平台之載具資訊： </p>
          <p>載具類別：</p><%= cardTypeRaw %>
          <p>載具明碼：</p><%= cardNo1Raw %>

          <!-- 模擬自動提交表單 -->
          <form id="carrierForm" action="<%= postUrl %>" method="post">
          <%
            for (Map.Entry<String, String> entry : params.entrySet()) {
            %>
            <input type="hidden" name="<%= entry.getKey() %>" value="<%= entry.getValue() %>">
            <%
            }
          %>
            <button type="submit">確認歸戶</button>
          </form>
        </div>
        <%
		  }
    }
  %>
  </body>
</html>
