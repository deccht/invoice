<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.regex.Pattern" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>驗證結果</title>
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
        %>
            <p class="success">所有輸入資料格式正確，驗證碼也正確！</p>
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