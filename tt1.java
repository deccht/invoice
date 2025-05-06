import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;

public class SignatureGenerator {
    public static void main(String[] args) throws Exception {
        // API Key
        String apiKey = "Xh8gAEbiBm2Sym3hCDFl3g==";

        // 拼接好的參數字串
        String dataToSign = "card_ban=96979933&card_no1=MTE0MDRCQkoxNDI1NDAwMTIxMDQxMDM1NTM3Mg==&card_no2=MTE0MDRCQkoxNDI1NDAwMTIxMDQxMDM1NTM3Mg==&card_type=RUowMTg1&token=JXRUIiLCJjYXJyaWVyX2lkMiI6Ikx5c3hRVTFTV1ZBPSIsImV4cCI6MTc0NTk5ODcyNX0eyJjYXJkX2NvZGUiOiJFSjAxODUiLCJ1c2VfYmFuIjoiOTY5Nzk5MzMiLCJzb3VyY2UiOi.4RE1Rx0bX2purKlpkww93Wb4eIYx52K4HR0dkLeBzJ0";

        // 初始化 HMAC-SHA256
        Mac mac = Mac.getInstance("HmacSHA256");
        SecretKeySpec secretKeySpec = new SecretKeySpec(apiKey.getBytes("UTF-8"), "HmacSHA256");
        mac.init(secretKeySpec);

        // 執行加密
        byte[] hmacBytes = mac.doFinal(dataToSign.getBytes("UTF-8"));

        // 將加密結果進行 Base64 編碼
        String signature = Base64.getEncoder().encodeToString(hmacBytes);

        // 輸出簽名
        System.out.println("Signature: " + signature);
    }
}