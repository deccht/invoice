<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Base64, java.util.TreeMap, java.util.Map, javax.crypto.Mac, javax.crypto.spec.SecretKeySpec" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>�|�������k��</title>
</head>
<body>
    <%
        // Step 4: �ǰe�Ѽƨ�j���x
        String token = (String) session.getAttribute("token"); // ����A�q session �����o
        String idno = (String) session.getAttribute("idno"); // ����A�|���{������Ҧ^�Ǫ��νs
        String cardBan = "96979933"; // ����A�|������ӽФ��Τ@�s��
        String cardNo1 = Base64.getEncoder().encodeToString(idno.getBytes("UTF-8")); // ����A������X (Base64 �s�X)
        String cardNo2 = Base64.getEncoder().encodeToString(idno.getBytes("UTF-8")); // ����A�������X (Base64 �s�X)
        String cardType = Base64.getEncoder().encodeToString("EJ0030".getBytes("UTF-8")); // ����A�������O�s�� (Base64 �s�X)

        // APIKEY (�j���x����) EJ0030
        //String apiKey = "Xh8gAEbiBm2Sym3hCDFl3g==";
        String apiKey = "Xh8gAEbiBm2Sym3hCDXXXXXX"; // TEST

        // �c�ذѼ�
        Map<String, String> params = new TreeMap<>(); // �ϥ� TreeMap �۰ʫ���W�Ƨ�
        params.put("card_ban", cardBan);
        params.put("card_no1", cardNo1);
        params.put("card_no2", cardNo2);
        params.put("card_type", cardType);
        params.put("token", token);

        // �ͦ�ñ�W (signature)
        String signature = "";
        try {
            // 1. �����ѼƦr��
            StringBuilder dataToSign = new StringBuilder();
            for (Map.Entry<String, String> entry : params.entrySet()) {
                if (dataToSign.length() > 0) {
                    dataToSign.append("&");
                }
                dataToSign.append(entry.getKey()).append("=").append(entry.getValue());
            }

            // 2. �ϥ� HMAC-SHA256 �[�K
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKeySpec = new SecretKeySpec(apiKey.getBytes("UTF-8"), "HmacSHA256");
            mac.init(secretKeySpec);
            byte[] hmacBytes = mac.doFinal(dataToSign.toString().getBytes("UTF-8"));

            // 3. �N�[�K���G�i�� Base64 �s�X
            signature = Base64.getEncoder().encodeToString(hmacBytes);
        } catch (Exception e) {
            out.println("<p>�ͦ�ñ�W�ɵo�Ϳ��~�G" + e.getMessage() + "</p>");
        }

        // �Nñ�W�[�J�Ѽ�
        params.put("signature", signature);

        // �c�� POST ���
        StringBuilder postData = new StringBuilder();
        for (Map.Entry<String, String> entry : params.entrySet()) {
            if (postData.length() > 0) {
                postData.append("&");
            }
            postData.append(entry.getKey()).append("=").append(entry.getValue());
        }

        // �����^�ǵ��j���x
        // String postUrl = "https://www-bindapi.einvoice.nat.gov.tw/btc/cloud/bind/btc101i/carrierFormPost"; // �������� URL
        String postUrl = "https://wwwtest-bindapi.einvoice.nat.gov.tw/btc/cloud/bind/btc101i/carrierFormPost"; // �������� URL
        
    %>

    <h1>�|�������k��</h1>
    <p>�H�U�O�N�^�ǵ��j���x���ѼơG</p>
    <pre>
        <%= postData.toString() %>
    </pre>
    <p>�^�� URL: <%= postUrl %></p>

    <!-- �����۰ʴ����� -->
    <form id="carrierForm" action="<%= postUrl %>" method="post">
        <%
            for (Map.Entry<String, String> entry : params.entrySet()) {
        %>
            <input type="hidden" name="<%= entry.getKey() %>" value="<%= entry.getValue() %>">
        <%
            }
        %>
        <button type="submit">����</button>
    </form>
</body>
</html>