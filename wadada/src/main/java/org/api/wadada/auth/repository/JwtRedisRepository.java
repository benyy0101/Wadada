package org.api.wadada.auth.repository;


import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

@RequiredArgsConstructor
@Component
public class JwtRedisRepository {

    private final RedisTemplate<String, String> redisTemplate;

    public void save(String refreshTokenKey, String refreshToken, long refreshTokenValidityInSeconds){
        redisTemplate.opsForValue().set(
                refreshTokenKey,
                refreshToken,
                refreshTokenValidityInSeconds,
                TimeUnit.SECONDS
        );
    }

    public void delete(String refreshTokenKey){
        redisTemplate.delete(refreshTokenKey);
    }

    public String find(String refreshTokenKey){
        return redisTemplate.opsForValue().get(refreshTokenKey);
    }
}
