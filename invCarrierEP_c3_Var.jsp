<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Base64, java.util.TreeMap, java.util.Map, javax.crypto.Mac, javax.crypto.spec.SecretKeySpec" %>
<%@ page import="java.util.regex.Pattern" %>
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
        <h1>驗證結果</h1>
        <%
            // 取得表單輸入的資料
            String year = request.getParameter("year");
            String serial = request.getParameter("serial");
            String checkCode = request.getParameter("checkCode");
            String id = request.getParameter("id");
            String captchaInput = request.getParameter("captcha");

            // 從 session 中取得正確的驗證碼
            String captchaSession = (String) session.getAttribute("captcha");

            // 驗證格式的正則表達式
            boolean isYearValid = Pattern.matches("\\d{5}", year);
            boolean isSerialValid = Pattern.matches("\\d{10}", serial);
            boolean isCheckCodeValid = Pattern.matches("\\d{13}", checkCode);
            boolean isIdValid = Pattern.matches("[A-Za-z0-9]{10}", id);
            boolean isCaptchaValid = captchaSession != null && captchaSession.equalsIgnoreCase(captchaInput);

            // 驗證結果
            if (isYearValid && isSerialValid && isCheckCodeValid && isIdValid && isCaptchaValid) {
                // Step 4: 傳送參數到大平台
                String idno = year + serial + checkCode;
                String token = (String) session.getAttribute("token"); // 必填，從 session 中取得

                token = "d1f2d1f5sfd1sf12sfs1s1f5s"; //TEST
                
                String idno = (String) session.getAttribute("idno"); // 必填，會員認証之後所回傳的統編
                String cardBan = "96979933"; // 必填，會員載具申請之統一編號
                String cardNo1 = Base64.getEncoder().encodeToString(idno.getBytes("UTF-8")); // 必填，載具明碼 (Base64 編碼)
                String cardNo2 = Base64.getEncoder().encodeToString(idno.getBytes("UTF-8")); // 必填，載具隱碼 (Base64 編碼)
                String cardType = Base64.getEncoder().encodeToString("EJ0185".getBytes("UTF-8")); // 必填，載具類別編號 (Base64 編碼)
        
                // APIKEY (大平台提供) EJ0185
                String apiKey = "3xIkuMC2jK8g0pHMZlNwGg==";
        
                // 構建參數
                Map<String, String> params = new TreeMap<>(); // 使用 TreeMap 自動按鍵名排序
                params.put("card_ban", cardBan);
                params.put("card_no1", cardNo1);
                params.put("card_no2", cardNo2);
                params.put("card_type", cardType);
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
        
                // 將簽名加入參數
                params.put("signature", signature);
        
                // 構建 POST 資料
                StringBuilder postData = new StringBuilder();
                for (Map.Entry<String, String> entry : params.entrySet()) {
                    if (postData.length() > 0) {
                        postData.append("&");
                    }
                    postData.append(entry.getKey()).append("=").append(entry.getValue());
                }
        
                // 模擬回傳給大平台
                // String postUrl = "https://www-bindapi.einvoice.nat.gov.tw/btc/cloud/bind/btc101i/carrierFormPost"; // 正式環境 URL
                String postUrl = "https://wwwtest-bindapi.einvoice.nat.gov.tw/btc/cloud/bind/btc101i/carrierFormPost"; // 測試環境 URL
            %>
            <p class="success">所有輸入資料格式正確，驗證碼也正確！</p>
        
            <h1>會員載具歸戶</h1>
            <p>以下是將回傳給大平台的參數：</p>
            <pre>
                <%= postData.toString() %>
            </pre>
            <p>回傳 URL: <%= postUrl %></p>
        
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
            <a href="inv_c2.jsp">返回輸入頁面</a>
        <% 
            } 
        %>
    </div>
</body>
</html>