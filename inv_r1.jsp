<%@ page import="org.json.JSONObject" %>
<%@ page import="java.io.InputStream" %>
<%@ page contentType="application/json; charset=UTF-8" %>

<%
    // 1. 接收來自 inv_c1.jsp 的 JSON 資料
    StringBuilder sb = new StringBuilder();
    try (InputStream is = request.getInputStream()) {
        int ch;
        while ((ch = is.read()) != -1) {
            sb.append((char) ch);
        }
    }

    // 2. 解析 JSON 資料
    JSONObject jsonRequest = new JSONObject(sb.toString());
    String nonce = jsonRequest.getString("nonce");

    // 3. 建立回應的 JSON 物件
    JSONObject jsonResponse = new JSONObject();
    jsonResponse.put("token_flag", "Y");
    jsonResponse.put("nonce", nonce);
    jsonResponse.put("err_msg", "NONE");

    // 4. 將回應的 JSON 資料寫入 response
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    out.print(jsonResponse.toString());
%>