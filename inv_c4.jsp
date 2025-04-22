<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Base64, java.util.TreeMap, java.util.Map, javax.crypto.Mac, javax.crypto.spec.SecretKeySpec" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>會員載具歸戶</title>
</head>
<body>
    <%
        // Step 4: 傳送參數到大平台
        String token = (String) session.getAttribute("token"); // 必填，從 session 中取得
        String cardBan = "97162640"; // 必填，會員載具申請之統一編號
        String cardNo1 = Base64.getEncoder().encodeToString("1234".getBytes("UTF-8")); // 必填，載具明碼 (Base64 編碼)
        String cardNo2 = Base64.getEncoder().encodeToString("987654321".getBytes("UTF-8")); // 必填，載具隱碼 (Base64 編碼)
        String cardType = Base64.getEncoder().encodeToString("BG0001".getBytes("UTF-8")); // 必填，載具類別編號 (Base64 編碼)

        // APIKEY (大平台提供)
        String apiKey = "XQcpGwtz5esvvdqTTsQ0bA==";

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
        <button type="submit">提交</button>
    </form>
</body>
</html>