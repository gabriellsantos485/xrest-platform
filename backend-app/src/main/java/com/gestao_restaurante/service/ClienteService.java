package com.gestao_restaurante.service;

import com.gestao_restaurante.model.Cliente;
import com.gestao_restaurante.repository.ClienteRepository;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.apache.tomcat.util.net.openssl.ciphers.Authentication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class ClienteService {

    @Autowired
    public ClienteRepository clienteRepository;

    @Autowired
    private AuthenticationManager authManager;

    private String secretKey;

    private BCryptPasswordEncoder criptografar = new BCryptPasswordEncoder(12);

    public Cliente registrar(Cliente cliente){
        cliente.setPassword(criptografar.encode(cliente.getPassword()));
        return clienteRepository.save(cliente);

    }
    public Key getKey(){
        try {
            KeyGenerator keyGen = KeyGenerator.getInstance("HmacSHA256");
            keyGen.init(256);
            SecretKey sk = keyGen.generateKey();
            secretKey = Base64.getEncoder().encodeToString(sk.getEncoded());

        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        return Keys.hmacShaKeyFor(keyBytes);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }

    }

    public String generateToken(String username){
        Map<String, Object> claims = new HashMap<>();
        return Jwts.builder()
                .claims()
                .add(claims)
                .subject(username)
                .issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() + 60 * 60 * 30))
                .and()
                .signWith(getKey())
                .compact();
    }

    public String verify(Cliente cliente){

        Authentication authentication = authManager.authenticate(new UsernamePasswordAuthenticationToken(
                cliente.getNome(),
                cliente.getPassword())
        );

        if(authentication.isAuthenticated()){
            return generateToken(cliente.getNome());
        }
        return "Fail";
    }
}
