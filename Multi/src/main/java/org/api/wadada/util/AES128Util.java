package org.api.wadada.util;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.ArrayUtils;
import org.api.wadada.error.errorcode.CustomErrorCode;
import org.api.wadada.error.exception.RestApiException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.Cipher;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

@Component
@Slf4j
public class AES128Util {
    private static final Charset ENCODING_TYPE = StandardCharsets.UTF_8;
    private static final String INSTANCE_TYPE = "AES/CBC/PKCS5Padding";

    @Value("${aes.secret-key}")
    private String secretKey;
    private IvParameterSpec ivParameterSpec;
    private SecretKeySpec secretKeySpec;
    private Cipher cipher;

    @PostConstruct
    public void init() throws NoSuchAlgorithmException, NoSuchPaddingException {
        SecureRandom secureRandom = new SecureRandom();
        byte[] iv = new byte[16];
        secureRandom.nextBytes(iv);
        ivParameterSpec = new IvParameterSpec(iv);

        byte[] keyBytes = secretKey.getBytes(ENCODING_TYPE);

        // AES 키 길이 검증 및 조정
        if (keyBytes.length != 16 && keyBytes.length != 24 && keyBytes.length != 32) {
            log.warn("제공된 AES 키의 길이가 128, 192, 또는 256비트가 아닙니다. 키 길이를 조정합니다.");

            // 키 길이가 16, 24, 32 바이트 중 하나가 되도록 조정
            byte[] adjustedKeyBytes = new byte[16]; // 기본값으로 128비트(16바이트) 키 사용
            if (keyBytes.length < 16) {
                System.arraycopy(keyBytes, 0, adjustedKeyBytes, 0, keyBytes.length);
            } else if (keyBytes.length > 16 && keyBytes.length <= 24) {
                adjustedKeyBytes = ArrayUtils.subarray(keyBytes, 0, 24); // 192비트
            } else if (keyBytes.length > 24) {
                adjustedKeyBytes = ArrayUtils.subarray(keyBytes, 0, 32); // 256비트
            }
            keyBytes = adjustedKeyBytes;
        }

        secretKeySpec = new SecretKeySpec(keyBytes, "AES");
        cipher = Cipher.getInstance(INSTANCE_TYPE);
    }

    // AES 암호화
    public String encryptAes(String plaintext) {
        try {
            cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivParameterSpec);
            byte[] encryted = cipher.doFinal(plaintext.getBytes(ENCODING_TYPE));
            return new String(Base64.getEncoder().encode(encryted), ENCODING_TYPE);
        } catch (Exception e) {
            log.error(e.getMessage());
            throw new RestApiException(CustomErrorCode.ENCRYPTION_FAILED);
        }
    }

    // AES 복호화
    public String decryptAes(String plaintext) {
        try {
            cipher.init(Cipher.DECRYPT_MODE, secretKeySpec, ivParameterSpec);
            byte[] decoded = Base64.getDecoder().decode(plaintext.getBytes(ENCODING_TYPE));
            return new String(cipher.doFinal(decoded), ENCODING_TYPE);
        } catch (Exception e) {
            log.error(e.getMessage());
            throw new RestApiException(CustomErrorCode.DECRYPTION_FAILED);
        }
    }
}
