import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;

public class tt2 {
    public static void main(String[] args) throws Exception {
//        String apiKey = "Xh8gAEbiBm2Sym3hCDFl3g==";
//		String apiKey = "3xIkuMC2jK8g0pHMZlNwGg==";
        String apiKey = "XQcpGwtz5esvvdqTTsQ0bA==";
        String dataToSign = "card_ban=97162640&card_no1=1234&card_no2=987654321&card_type=BG0001&token=eyJhb
 GciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIiwiY3R5IjoiSldUIiwia2lkIjoiMDEifQ..wNSlKWvyuPo
 20rYz.9AH2ig6DWLTn1CEGDiSx72SNQVpsYKeNQ4SmI4xqcAcHuriic_2XokWfDBqJNi1uN
 1pO1iJk3WlANXVRG6W4MYFp_bKiuYRo1wITDo_xCy26WrkjSOQhtZfbltrzdFHPnKvMzBoi
 qu6njirr9uBPJFSlI7Qu8Er56NWnzWJNRtOUrkEcB4JQYdWZ2pfFvqKMDtmI_4iFWwNgCjHX
 3P1WWTxcnDKq5R_oX8xx_u9a3NhsKgEwOwCl3hyPawJmq9vWswbmCM5BSTYSVk5PHeW
 RKik9LTBd1KZuw3005RXlVRAYqJKrkvdOUMpmdmFFbfopZK4t4UjtfhXpvSXhAJbipgDL_E
 JSlbB09xrly3DCK5B2WMmUZ6TJ07ryOuhQ9ZhtxfFIzin6VeKu_YNT0D8nugegMVqWjXHJrw
 4BMBxchy5MCUZB_CMLyBGZvemCHDZrPOjckFEiORLt6D7TXJOOBQN5kCXE43zYxcv__
 bAqHtcOjR3q6Yy7i51caI2zmlgkS_G.oIjs4WBcUsTJkXmuw4_Z9g";

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