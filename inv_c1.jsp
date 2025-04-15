<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.Random" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page contentType="application/json; charset=UTF-8" %>

<%
// 1. 接收大平台傳來的參數
String token = request.getParameter("token");
String ban = request.getParameter("ban");

// 2. 產生隨機的 16 位英數字 nonce
String nonce = generateNonce(16);

// 3. 建立 JSON 物件
JSONObject jsonRequest = new JSONObject();
jsonRequest.put("token", token); // 回傳原本的 token
jsonRequest.put("nonce", nonce);

// 4. 設定 HTTP 內容類型為 application/json
response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");

// 5. 將 JSON 資料 POST 到指定的 API 網址，並接收回傳的 JSON 資料
//String apiUrl = "https://wwwtest-bindapi.einvoice.nat.gov.tw/btc/cloud/bind/btc101i/carrierJsonPost";
String apiUrl = "https://boss71.cht.com.tw/AMPS/carrie/inv_r1.jsp";
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

    // 6. 將回傳的 JSON 資料寫入 response
    out.print(jsonResponse.toString());
} else {
    out.print("{\"err_msg\":\"Failed to connect to API\"}");
}
%>
<%!
// 產生隨機英數字字串
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