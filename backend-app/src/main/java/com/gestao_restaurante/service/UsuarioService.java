package com.gestao_restaurante.service;

import com.gestao_restaurante.model.Usuario;
import com.gestao_restaurante.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UsuarioService {

    private UsuarioRepository repository;
    private PasswordEncoder encoder;
    public UsuarioService(UsuarioRepository repository, PasswordEncoder encoder) {
        this.repository = repository;
        this.encoder = encoder;
    }

    public Usuario authenticate(String login, String password) {

        Optional<Usuario> userOpt;

        if (login.contains("@")) {
            userOpt = repository.findByEmail(login);
        } else {
            userOpt = repository.findByCpf(login);
        }

        Usuario user = userOpt.orElseThrow(() ->
                new RuntimeException("Usuário não encontrado")
        );

        if (!passwordMatches(password, user.getSenha())) {
            throw new RuntimeException("Senha inválida");
        }

        return user;
    }

    @Autowired
    private PasswordEncoder passwordEncoder;

    private boolean passwordMatches(String raw, String encoded) {
        return passwordEncoder.matches(raw, encoded);
    }

    public Usuario register(Usuario user) {
        user.setSenha(encoder.encode(user.getSenha()));
        return repository.save(user);
    }


}