<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>驗證碼範例</title>
    <script>
        function reloadCaptcha() {
            document.getElementById("captchaImage").src = "captcha.jsp?" + new Date().getTime();
        }
    </script>
</head>
<body>
    <h1>驗證碼範例</h1>
    <form action="validateCaptcha.jsp" method="post">
        <p>
            <img id="captchaImage" src="captcha.jsp" alt="驗證碼圖片" onclick="reloadCaptcha()" style="cursor: pointer;">
            <br>
            <small>點擊圖片可重新生成驗證碼</small>
        </p>
        <p>
            請輸入驗證碼：<input type="text" name="captchaInput" required>
        </p>
        <p>
            <button type="submit">提交</button>
        </p>
    </form>
</body>
</html>