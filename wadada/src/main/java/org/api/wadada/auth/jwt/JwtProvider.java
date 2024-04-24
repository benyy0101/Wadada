//package org.api.wadada.auth.jwt;
//
//
//import jakarta.servlet.http.Cookie;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import io.jsonwebtoken.Jwts;
//import io.jsonwebtoken.SignatureAlgorithm;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.context.annotation.PropertySource;
//import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
//import org.springframework.security.core.Authentication;
//import org.springframework.security.core.GrantedAuthority;
//import org.springframework.stereotype.Component;
//import java.util.Collection;
//import java.util.Date;
//
//import static org.springframework.security.core.authority.AuthorityUtils.createAuthorityList;
//
//
//@PropertySource("security.properties")
//@Component
//public class JwtProvider {
//
//    private final String SECRET_KEY;
//    private final long EXPIRE_TIME;
//
//    // 생성자 메소드
//    public JwtProvider(@Value("${jwt.token.secret-key}") String secretKey, @Value("${jwt.token.expire-time}") long expireTime) {
//        this.SECRET_KEY = secretKey;
//        this.EXPIRE_TIME = expireTime;
//    }
//
//    /**
//     * Authentication 기반 토큰 생성 메소드.
//     * {@link #generateToken(String, Collection)}
//     * @param authentication
//     * @return JWT(String)
//     */
//    public String generateToken(Authentication authentication) {
//        return generateToken(authentication.getName(), authentication.getAuthorities());
//    }
//
//    /**
//     * Username 및 Authorities 기반 토큰 생성 메소드.
//     * @param username
//     * @param authorities
//     * @return JWT(String)
//     */
//    public String generateToken(String username, Collection<? extends GrantedAuthority> authorities) {
//        return Jwts.builder()
//                .setSubject(username)
//                .claim("role", authorities.stream().findFirst().get().toString())
//                .setExpiration(getExpireDate())
//                .signWith(SignatureAlgorithm.HS256, SECRET_KEY)
//                .compact();
//    }
//
//    /**
//     * 토큰으로부터 받은 정보를 기반으로 Authentication 객체를 반환하는 메소드.
//     * @param accessToken
//     * @return Authentication
//     */
//    public Authentication getAuthentication(String accessToken) {
//        return new UsernamePasswordAuthenticationToken(getUsername(accessToken), "", createAuthorityList(getRole(accessToken)));
//    }
//
//    /**
//     * 사용자가 보낸 요청 헤더의 'Authorization' 필드에서 토큰을 추출하는 메소드.
//     * @param request
//     * @return token(String)
//     */
//    public String resolveToken(HttpServletRequest request) {
//        return request.getHeader("Authorization");
//    }
//
//    public boolean validateToken(String accessToken) {
//        if (accessToken == null) {
//            return false;
//        }
//
//        try {
//            return Jwts.parser()
//                    .setSigningKey(SECRET_KEY)
//                    .parseClaimsJws(accessToken)
//                    .getBody()
//                    .getExpiration()
//                    .after(new Date());
//        }
//        catch (Exception e) {
//            return false;
//        }
//    }
//
//    private String getUsername(String accessToken) {
//        return Jwts.parser()
//                .setSigningKey(SECRET_KEY)
//                .parseClaimsJws(accessToken)
//                .getBody()
//                .getSubject();
//    }
//
//    private String getRole(String accessToken) {
//        return (String) Jwts.parser()
//                .setSigningKey(SECRET_KEY)
//                .parseClaimsJws(accessToken)
//                .getBody()
//                .get("role", String.class);
//
//    }
//
//    private Date getExpireDate() {
//        Date now = new Date();
//        return new Date(now.getTime() + EXPIRE_TIME);
//    }
//}