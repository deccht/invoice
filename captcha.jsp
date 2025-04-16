<%@ page import="java.awt.*" %>
<%@ page import="java.awt.image.*" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.util.Random" %>
<%@ page import="java.io.OutputStream" %>

<%
    // 生成驗證碼
    int width = 120;
    int height = 40;
    int codeLength = 5;
    String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"; // 只包含大寫英文和數字
    Random random = new Random();
    StringBuilder captchaCode = new StringBuilder();

    for (int i = 0; i < codeLength; i++) {
        captchaCode.append(characters.charAt(random.nextInt(characters.length())));
    }

    // 將驗證碼存入 session
    session.setAttribute("captcha", captchaCode.toString());

    // 創建圖片
    BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
    Graphics2D g = image.createGraphics();
    g.setColor(Color.WHITE);
    g.fillRect(0, 0, width, height);

    // 畫驗證碼文字
    g.setFont(new Font("Arial", Font.BOLD, 24));
    g.setColor(Color.BLACK);
    for (int i = 0; i < codeLength; i++) {
        g.drawString(String.valueOf(captchaCode.charAt(i)), 20 * i + 10, 30);
    }

    // 畫干擾線（加粗）
    g.setColor(Color.GRAY);
    g.setStroke(new BasicStroke(3)); // 設定線條寬度為 3
    // 控制干擾線的長度
    int maxLineLength = 50; // 最大干擾線長度
    for(i=0;i<=3;i++) {
        int x1 = random.nextInt(width);
        int y1 = random.nextInt(height);
        int x2 = x1 + random.nextInt(maxLineLength);
        int y2 = y1 + random.nextInt(maxLineLength);

        // 確保 x2 和 y2 不超出圖片邊界
        x2 = Math.max(0, Math.min(width, x2));
        y2 = Math.max(0, Math.min(height, y2));
        g.drawLine(x1, y1, x2, y2);
    }

    g.dispose();

    // 將圖片輸出到 response
    response.setContentType("image/png");
    OutputStream outputStream = response.getOutputStream();
    ImageIO.write(image, "png", outputStream);
    outputStream.close();
%>