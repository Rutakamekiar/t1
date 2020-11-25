package app.agentmsg;

import com.fasterxml.jackson.core.JsonProcessingException;


import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;
import java.util.UUID;
import org.apache.commons.codec.binary.Hex;

/**
 * Class to work with agent messages
 * @author Kotelevsky Kirill
 * @version 1.0
 */
public class Agentmsg {

    /**
     * Transform String message into Map and send it to DB
     * @param message String message from agent
     * @throws JsonProcessingException
     * @throws ParseException
     * @throws SQLException
     */
    public static void  saveAgentmsg( Map<String,Object> message ) throws JsonProcessingException, ParseException, SQLException {
        AgentmsgDao.addAgentmsgToDB( Agentmsg.getUniqueID() , message );
    }

    /**
     * Generate String id of message
     * @return String id
     */
    private static String getUniqueID(){
       return UUID.randomUUID().toString();
    }

    public static boolean checkIsMessageTrusted(String sign, String publicKey, byte[] bodyAsBytes) throws SQLException, NoSuchAlgorithmException, InvalidKeyException, UnsupportedEncodingException {
        String priviteKey;
        try {
            priviteKey = AgentmsgDao.getPrivateKey(publicKey);
        } catch (NoSuchFieldException e) {
            return false;
        }

        if( sign.equals(getEncryptedJson( priviteKey , bodyAsBytes)))
            return true;

        return false;
    }

    private static String getEncryptedJson(String priviteKey, byte[] bodyAsBytes) throws NoSuchAlgorithmException, InvalidKeyException, UnsupportedEncodingException {
        Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
        SecretKeySpec secret_key = new SecretKeySpec(priviteKey.getBytes("UTF-8"), "HmacSHA256");
        sha256_HMAC.init(secret_key);
        return Hex.encodeHexString(sha256_HMAC.doFinal(bodyAsBytes));
    }

}
