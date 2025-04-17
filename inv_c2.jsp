<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>驗證碼輸入頁面</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        .container {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .form-group {
            margin-bottom: 15px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        input[type="text"] {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .captcha {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .captcha img {
            margin-left: 10px;
            cursor: pointer;
        }

        button {
            padding: 10px 20px;
            font-size: 16px;
            color: #fff;
            background-color: #4CAF50;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background-color: #45a049;
        }
    </style>
    <script>
        function reloadCaptcha() {
            document.getElementById("captchaImage").src = "captcha.jsp?" + new Date().getTime();
        }
    </script>
</head>
<body>
    <div class="container">
        <h1>驗證碼輸入頁面</h1>
        <form action="validateCaptcha.jsp" method="post">
            <div class="form-group">
                <label for="year">年期別 (5位數字)</label>
                <input type="text" id="year" name="year" pattern="\\d{5}" required>
            </div>
            <div class="form-group">
                <label for="serial">流水號 (10位數字)</label>
                <input type="text" id="serial" name="serial" pattern="\\d{10}" required>
            </div>
            <div class="form-group">
                <label for="checkCode">檢核碼 (13位數字)</label>
                <input type="text" id="checkCode" name="checkCode" pattern="\\d{13}" required>
            </div>
            <div class="form-group">
                <label for="id">身份字號或統一編號 (10位英數字)</label>
                <input type="text" id="id" name="id" pattern="[A-Za-z0-9]{10}" required>
            </div>
            <div class="captcha">
                <label for="captcha">驗證碼</label>
                <input type="text" id="captcha" name="captcha" required>
                <img id="captchaImage" src="captcha.jsp" alt="驗證碼" onclick="reloadCaptcha()">
            </div>
            <button type="submit">提交</button>
        </form>
    </div>
</body>
</html>