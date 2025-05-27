<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Base64, java.util.TreeMap, java.util.Map, javax.crypto.Mac, javax.crypto.spec.SecretKeySpec" %>
<%@ page import="java.util.regex.Pattern" %>
<%@page import="org.owasp.esapi.ESAPI"%>
<%@page import="org.owasp.esapi.Validator"%>

<jsp:useBean id="db" class="tool.DBaccess" scope="request">
	<jsp:setProperty name="db" property="jndina" value="${applicationScope.jdna}" />
</jsp:useBean>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>會員載具歸戶</title>
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
    <div class="result">
        <img src="./images/chtLogo.png" class="img-fluid hidden-lg-up" style="max-width: 200px" alt="中華電信電子發票系統">
        <h1>驗證結果</h1>
        <%
            Validator validator = ESAPI.validator();

            String year = validator.getValidInput("year", request.getParameter("year"), "digits", 5, false);
            String serial = validator.getValidInput("serial", request.getParameter("serial"), "alphanumeric", 10, false);
            String checkCode = validator.getValidInput("checkCode", request.getParameter("checkCode"), "digits", 13, false);
            String id = validator.getValidInput("id", request.getParameter("id"), "alphanumeric", 10, false);
            String captchaInput = request.getParameter("captcha");
            String captchaSession = (String) session.getAttribute("captcha");

            boolean isYearValid = year != null && year.length() == 5;
            boolean isSerialValid = serial != null && serial.length() == 10;
            boolean isCheckCodeValid = checkCode != null && checkCode.length() == 13;
            boolean isIdValid = id != null && id.length() == 10;
            boolean isCaptchaValid = captchaSession != null && captchaSession.equalsIgnoreCase(captchaInput);
            Boolean checkidno = false;

            // 驗證結果
            if (isYearValid && isSerialValid && isCheckCodeValid && isIdValid && isCaptchaValid) {
                // 將 serial 和 id 轉成大寫
                serial = serial.toUpperCase();
                id = id.toUpperCase();

                // Step 4: 傳送參數到大平台
                String idno = year + serial + checkCode;
                String token = (String) session.getAttribute("token"); // 必填，從 session 中取得
                if (idno == null || token == null) {
                    out.println("<p>token OR idno 參數缺失，無法構建 POST 資料。</p>");
                    return;
                }
                String cardBan = "96979933"; // 必填，會員載具申請之統一編號
                String cardNo1Raw = idno; // 使用原始值
                String cardNo2Raw = idno; // 使用原始值
                String cardTypeRaw = "EJ0185"; // 使用原始值

                try {
			        String sql = "select * from prt_invo_v6 where carrier_id1 = ? and idno = ? and carrier_tp ='EJ0185' ";
			        String[] params = new String[]{cardNo1Raw, id};
			        db.openDB();
			        db.execSQL(sql, params);
			        if (db.rs.first()) {
				        checkidno = true;
			        }
		        } catch (Exception e) {
			        out.println("<p>DB ERROR" + e.getMessage() + "</p>");
		        } finally {
			        db.closeDB();
		        }

                if (!checkidno) {
                    %>
                    <p class="error">身份證號或統一編號、載具內容有誤</p>
                    <p class="error">請查明後由整合平台重新操作</p>
                    <%
		        }

                if (checkidno) {
                    // APIKEY (大平台提供) EJ0030
                    // String apiKey = "Xh8gAEbiBm2Sym3hCDFl3g==";
                    // APIKEY (大平台提供) EJ0185
                    String apiKey = "3xIkuMC2jK8g0pHMZlNwGg==";

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
                    <p class="success">所有輸入資料格式正確，驗證碼也正確！</p>

                    <h1>變動載具歸戶</h1>
                    <p>以下是將回傳至整合平台之載具資訊： </p>
                    <p>載具類別：</p><%= cardTypeRaw %>
                    <p>載具內容：</p><%= cardNo1Raw %>

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
        <%
                }
            } else { 
        %>
            <p class="error">輸入資料有誤，請檢查以下項目：</p>
            <ul class="error">
                <% if (!isYearValid) { %>
                    <li>年期別必須是 5 位數字。</li>
                <% } %>
                <% if (!isSerialValid) { %>
                    <li>流水號必須是 10 位數字。</li>
                <% } %>
                <% if (!isCheckCodeValid) { %>
                    <li>檢核碼必須是 13 位數字。</li>
                <% } %>
                <% if (!isIdValid) { %>
                    <li>身份字號或統一編號必須是 10 位英數字。</li>
                <% } %>
                <% if (!isCaptchaValid) { %>
                    <li>驗證碼不正確或已過期。</li>
                <% } %>
            </ul>
            <a href="javascript:history.back();">返回上頁</a>
        <% 
            } 
        %>
    </div>
</body>
</html>