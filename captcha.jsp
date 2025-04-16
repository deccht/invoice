<%@ page import="java.awt.*" %>
<%@ page import="java.awt.image.*" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.util.Random" %>
<%
    // 生成驗證碼
    int width = 120;
    int height = 40;
    int codeLength = 5;
    String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    Random random = new Random();
    StringBuilder captchaCode = new StringBuilder();

    for (int i = 0; i < codeLength; i++) {
        captchaCode.append(characters.charAt(random.nextInt(characters.length())));
    }

    // 將驗證碼存入 session
    session.setAttribute("captcha", captchaCode.toString());

    // 創建圖片
    BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
    Graphics g = image.getGraphics();
    g.setColor(Color.WHITE);
    g.fillRect(0, 0, width, height);

    // 畫驗證碼文字
    g.setFont(new Font("Arial", Font.BOLD, 24));
    g.setColor(Color.BLACK);
    for (int i = 0; i < codeLength; i++) {
        g.drawString(String.valueOf(captchaCode.charAt(i)), 20 * i + 10, 30);
    }

    // 畫干擾線
    g.setColor(Color.GRAY);
    for (int i = 0; i < 10; i++) {
        int x1 = random.nextInt(width);
        int y1 = random.nextInt(height);
        int x2 = random.nextInt(width);
        int y2 = random.nextInt(height);
        g.drawLine(x1, y1, x2, y2);
    }

    g.dispose();

    // 將圖片輸出到 response
    response.setContentType("image/png");
    OutputStream out = response.getOutputStream();
    ImageIO.write(image, "png", out);
    out.close();
%>