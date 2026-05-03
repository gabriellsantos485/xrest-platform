package com.gestao_restaurante.service;

import com.gestao_restaurante.dto.ClienteRequestDTO;
import com.gestao_restaurante.mapper.CardapioMapper;
import com.gestao_restaurante.mapper.ClienteMapper;
import com.gestao_restaurante.model.Cardapio;
import com.gestao_restaurante.model.Cliente;
import com.gestao_restaurante.repository.ClienteRepository;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class ClienteService {

    private final ClienteRepository clienteRepository;
    private final AuthenticationManager authManager;
    private final PasswordEncoder passwordEncoder;

    public ClienteService(ClienteRepository clienteRepository,
                          AuthenticationManager authManager,
                          PasswordEncoder passwordEncoder){
        this.clienteRepository = clienteRepository;
        this.authManager = authManager;
        this.passwordEncoder = passwordEncoder;

    }
    // Colocar chave secreta no application.properties
    @Value("${jwt.secret}")
    private String secretKey;

    /*
        Algoritmo para gerar a chave:

        KeyGenerator keyGen = KeyGenerator.getInstance("HmacSHA256");
        keyGen.init(256);
        SecretKey key = keyGen.generateKey();
        System.out.println(Base64.getEncoder().encodeToString(key.getEncoded()));
    */

    public Cliente registrar(ClienteRequestDTO dto){
        Cliente cliente = ClienteMapper.toEntity(dto);
        cliente.setPassword(passwordEncoder.encode(cliente.getPassword()));
        return clienteRepository.save(cliente);

    }

    public Key getKey(){
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    public String generateToken(String username){

        return Jwts.builder()
                .setSubject(username)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 30))
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
        throw new RuntimeException("Credenciais inválidas");
    }
}
