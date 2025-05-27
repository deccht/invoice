<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="zh-TW">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>中華電信變動載具歸戶設定</title>
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

            .captcha {
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

            input[type="text"] {
                padding: 10px;
                font-size: 16px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }

            /* 根據輸入長度調整寬度 */
            input.short {
                width: 80px;
                /* 適合 5 位數字 */
            }

            input.medium {
                width: 150px;
                /* 適合 10 位數字 */
            }

            input.long {
                width: 200px;
                /* 適合 13 位數字 */
            }
        </style>
        <script>
            function reloadCaptcha() {
                document.getElementById("captchaImage").src = "captcha_Var.jsp?" + new Date().getTime();
            }
        </script>
    </head>

    <body>
        <div class="container">
            <img src="./images/chtLogo.png" class="img-fluid hidden-lg-up" style="max-width: 200px" alt="中華電信電子發票系統">
            <h1>中華電信變動載具歸戶設定</h1>
            <form action="invCarrierEP_c3_Var.jsp" method="post">
                <div class="form-group">
                    <label for="year">年期別 (5位數字)</label>
                    <input type="text" id="year" name="year" class="short" pattern="\d{5}" required>
                </div>
                <div class="form-group">
                    <label for="serial">載具流水號 (10位英數字)</label>
                    <input type="text" id="serial" name="serial" class="medium" pattern="[A-Za-z0-9]{10}" required>
                </div>
                <div class="form-group">
                    <label for="checkCode">檢核碼 (13位數字)</label>
                    <input type="text" id="checkCode" name="checkCode" class="long" pattern="\d{13}" required>
                </div>
                <div class="form-group">
                    <label for="id">身份證號或統一編號 (10位英數字)</label>
                    <input type="text" id="id" name="id" class="medium" pattern="[A-Za-z0-9]{10}" required>
                </div>
                <div class="captcha">
                    <label for="captcha">驗證碼 (5位英數字) 如不清楚可點圖片更新</label>
                    <input type="text" id="captcha" name="captcha" class="short" pattern="[A-Za-z0-9]{5}" required>
                    <img id="captchaImage" src="captcha_Var.jsp" alt="驗證碼" onclick="reloadCaptcha()">
                </div>
                <button type="submit">送出</button>
            </form>
        </div>
    </body>

    </html>