package org.api.wadada.auth;

import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.api.wadada.app.member.entity.Member;
import org.api.wadada.app.member.repository.MemberRepository;
import org.api.wadada.auth.repository.JwtRedisRepository;
import org.api.wadada.error.errorcode.CustomErrorCode;
import org.api.wadada.error.exception.RestApiException;
import org.api.wadada.util.AES128Util;
import org.api.wadada.util.KeyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.security.Key;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.stream.Collectors;

@Slf4j
@Component
public class JwtTokenProvider {
    private final MemberRepository memberRepository;
    private JwtRedisRepository jwtRedisRepository;
    private Key key;
    private long accessTokenValidityInSeconds;
    private long refreshTokenValidityInSeconds;
    private final AES128Util aes128Util;

    @Autowired
    public JwtTokenProvider(@Value("${spring.jwt.secret}") String secretKey, MemberRepository memberRepository,
                            @Value("${spring.jwt.access-token-validity-in-seconds}") long accessTokenValidityInSeconds,
                            @Value("${spring.jwt.refresh-token-validity-in-seconds}") long refreshTokenValidityInSeconds,
                            JwtRedisRepository jwtRedisRepository,
                            AES128Util aes128Util) {
        this.memberRepository = memberRepository;
        byte[] keyBytes = Decoders.BASE64.decode(secretKey); // base64로 디코딩 -> 바이트 배열로 변환
        this.key = Keys.hmacShaKeyFor(keyBytes); // hmacsha256으로 다시 암호화?
        this.accessTokenValidityInSeconds = accessTokenValidityInSeconds;
        this.refreshTokenValidityInSeconds = refreshTokenValidityInSeconds;
        this.jwtRedisRepository = jwtRedisRepository;
        this.aes128Util = aes128Util;
    }

    // Member 정보를 가지고 AccessToken, RefreshToken을 생성하는 메서드
    public JwtToken generateToken(Authentication authentication) {
        // 권한 가져오기
        String authorities = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.joining(","));

        long now = (new Date()).getTime();

        // Access Token 생성
        String accessToken = Jwts.builder()
                .setSubject(authentication.getName())
                .claim("auth", authorities)
                .setExpiration(new Date(now + accessTokenValidityInSeconds * 1000))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();

        // Refresh Token 생성
        String refreshToken = Jwts.builder()
                .setSubject(authentication.getName())
                .claim("auth", authorities)
                .setExpiration(new Date(now + refreshTokenValidityInSeconds * 1000))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();

        String encryptedRefreshToken = aes128Util.encryptAes(refreshToken);

        // refreshToken redis에 저장
       jwtRedisRepository.save(
               KeyUtil.getRefreshTokenKey(authentication.getName()),
               refreshToken, refreshTokenValidityInSeconds);

        return JwtToken.builder()
                .grantType("Bearer")
                .accessToken(accessToken)
                .refreshToken(encryptedRefreshToken)
                .build();
    }


    // Jwt 토큰을 복호화하여 토큰에 들어있는 정보를 꺼내는 메서드
    public Authentication getAuthentication(String accessToken) {
        // Jwt 토큰 복호화 (Claim이 권한 정보)
        Claims claims = parseClaims(accessToken);

        if (claims.get("auth") == null) {
            throw new RuntimeException("권한 정보가 없는 토큰입니다.");
        }

        // 클레임에서 권한 정보 가져오기
        Collection<? extends GrantedAuthority> authorities = Arrays.stream(claims.get("auth").toString().split(","))
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toList());

        // UserDetails 객체를 만들어서 Authentication return
        // UserDetails: interface, User: UserDetails를 구현한 class
        // User : username, password,authorities
        // -> UserDetails은 사용자 식별과 권한만 확인, 보안을 위해 SS에서 password 비워두는 것이 관행
        // UsernamePasswordAuthenticationToken : Authentication 구현체
        // credentials : 패스워드나 토큰과 같은 비밀번호 인증 정보 ( 보안을 위해 비워둠 )
        // credentials이 없어도 principal, authorities정보에 중점을 두고 처리

            Member member = memberRepository.findByMemberId(claims.getSubject()).orElseThrow(() -> new RestApiException(CustomErrorCode.NO_MEMBER));
//            Authentication authentication = new UsernamePasswordAuthenticationToken(member, "", authorities);
//            SecurityContextHolder.getContext().setAuthentication(authentication);
//
//       // UserDetails principal = new User(claims.getSubject(), "", authorities);
//
//
//        UserDetails principal = new User(claims.getSubject(), "", authorities);
        return new UsernamePasswordAuthenticationToken(member, "", authorities);
    }

    // 토큰 정보를 검증하는 메서드
    public boolean validateToken(String accessToken) {
        try {
            log.debug("accessToken : {}", accessToken);
            Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(accessToken);
            return true;
        } catch (SecurityException | MalformedJwtException e) {
            log.info("Invalid JWT Token", e);
            throw new JwtException("Invalid JWT Token");
        } catch (ExpiredJwtException e) {
            // access token이 expire될 시에 바로 reissue로 redirect
            log.info("Expired JWT Token", e);
            throw new ExpiredJwtException(null, null,"Expired JWT Token");
        } catch (UnsupportedJwtException e) {
            log.info("Unsupported JWT Token", e);
            throw new JwtException("Unsupported JWT Token");
        } catch (IllegalArgumentException e) {
            log.info("JWT claims string is empty.", e);
            throw new JwtException("JWT claims string is empty.");
        }
    }

    // accessToken claim parsing (만료된 토큰도 복호화)
    public Claims parseClaims(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(token) // JWT 토큰 검증과 파싱 모두 수행
                    .getBody();
        } catch (ExpiredJwtException e) {
            return e.getClaims();
        }
    }

    // Request Header에서 토큰 정보 추출
    public String resolveToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer")) {
            return bearerToken.substring(7);
        }
        return null;
    }

    public String generateAccessToken(String memberId, String authorities){
        Date accessTokenExpiresIn = new Date((new Date()).getTime() + accessTokenValidityInSeconds * 1000);
        return Jwts.builder()
                .setSubject(memberId)
                .claim("auth", authorities)
                .setExpiration(accessTokenExpiresIn)
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }

}
