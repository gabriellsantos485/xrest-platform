package com.gestao_restaurante.config.security;

import org.springframework.security.core.GrantedAuthority;

import java.util.Collection;

public interface UsuarioSistema {

    String getEmail();

    String getPassword();

    Collection<? extends GrantedAuthority> getAuthorities();
}
