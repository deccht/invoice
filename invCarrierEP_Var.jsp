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

out.println(nonce);
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