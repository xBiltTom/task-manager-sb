package com.xdevelopers.spring_todo.security;

import java.util.Date;

import javax.crypto.SecretKey;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class JwtService {

    private SecretKey signingKey;
    private final long expiration;


    public JwtService(@Value("${jwt.secret}") String secret, 
                    @Value("jwt.expiration") long expiration){
        byte[] keyBytes = secret.getBytes();
        if(keyBytes.length<32){
            throw new IllegalArgumentException("JWT secret debe tener almenos 32 caracteres");
        }
        this.signingKey = Keys.hmacShaKeyFor(keyBytes);
        this.expiration = expiration;
    }

    public String generateToken(String email){
        Date now = new Date();
        return Jwts.builder()
                .subject(email)
                .issuedAt(now)
                .expiration(new Date(now.getTime() + expiration))
                .signWith(signingKey)
                .compact();
    }

    public String extractEmail(String token){
        return extractClaims(token).getSubject();
    }

    public boolean isTokenValid(String token){
        try{
            Claims claims = extractClaims(token);
            return claims.getExpiration().after(new Date());
        } catch(JwtException e){
            log.warn("Token JWT inválido: {}", e.getMessage());
            return false;
        } catch(Exception e){
            log.error("Error inesperado al validar token",e);
            return false;
        }
    }

    public Claims extractClaims(String token){
        return Jwts.parser()
                .verifyWith(signingKey)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }


}
