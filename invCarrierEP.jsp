<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.Random" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page contentType="application/json; charset=UTF-8" %>

<%
// 1. �����j���x�ǨӪ��Ѽ�
String token = request.getParameter("token");
String ban = request.getParameter("ban");

// 1.1 token存到SESSION, 之後要回傳大平台
session.setAttribute("ctoken", token);

// 2. �����H���� 16 ��^�Ʀr nonce
String nonce = generateNonce(16);

// 3. �إ� JSON ����
JSONObject jsonRequest = new JSONObject();
jsonRequest.put("token", token); // �^�ǭ쥻�� token
jsonRequest.put("nonce", nonce);

// 4. �]�w HTTP ���e������ application/json
response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");

// 5. �N JSON ��� POST ����w�� API ���}�A�ñ����^�Ǫ� JSON ���
//�k���������
String apiUrl = "https://wwwtest-bindapi.einvoice.nat.gov.tw/btc/cloud/bind/btc101i/carrierJsonPost";
//�k�᥿������
//String apiUrl = "https://www-bindapi.einvoice.nat.gov.tw/btc/cloud/bind/btc101i/carrierJsonPost";
//�ۧڴ�������
//String apiUrl = "https://boss71.cht.com.tw/AMPS/carrie/inv_r1.jsp";
URL url = new URL(apiUrl);
HttpURLConnection conn = (HttpURLConnection) url.openConnection();
conn.setRequestMethod("POST");
conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
conn.setDoOutput(true);

try (OutputStream os = conn.getOutputStream()) {
    byte[] input = jsonRequest.toString().getBytes("UTF-8");
    os.write(input, 0, input.length);
}

int responseCode = conn.getResponseCode();
if (responseCode == HttpURLConnection.HTTP_OK) {
    InputStream is = conn.getInputStream();
    StringBuilder responseStrBuilder = new StringBuilder();
    int ch;
    while ((ch = is.read()) != -1) {
        responseStrBuilder.append((char) ch);
    }
    JSONObject jsonResponse = new JSONObject(responseStrBuilder.toString());
    String rNonce = jsonResponse.optString("nonce", "");
    out.println(rNonce + ":1_2:" + nonce);
    if (!rNonce.equals(nonce)) {
        out.print("{\"err_msg\":\"Nonce mismatch\"}");
        return;
    }

    // 6. �N�����ɦV����w�� URL
    String redirectUrl = "https://inv.cht.com.tw/invoice/chtmbr/carrie_mbr.jsp";
    response.sendRedirect(redirectUrl);
} else {
    out.print("{\"err_msg\":\"Failed to connect to API\"}");
}
%>
<%!
// �����H���^�Ʀr�r��
private String generateNonce(int length) {
    String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    Random rng = new Random();
    StringBuilder nonce = new StringBuilder(length);
    for (int i = 0; i < length; i++) {
        nonce.append(characters.charAt(rng.nextInt(characters.length())));
    }
    return nonce.toString();
}
%>