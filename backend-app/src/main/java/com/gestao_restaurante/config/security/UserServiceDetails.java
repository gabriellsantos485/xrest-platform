package com.gestao_restaurante.config.security;

import com.gestao_restaurante.model.Cliente;
import com.gestao_restaurante.repository.ClienteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class UserServiceDetails implements UserDetailsService {

    @Autowired
    private ClienteRepository repo; //Não fiz por motivos óbvios, o foco é segurança

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Cliente cliente = repo.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("Usuário não encontrado"));

        return new ClientePrincipal(cliente); //UserPrincipal implements UserDetails. Não fiz a classe por motivos óbvios, o foco é segurança
    }

}
