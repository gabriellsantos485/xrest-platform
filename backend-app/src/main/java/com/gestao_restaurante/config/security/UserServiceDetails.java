package com.gestao_restaurante.config.security;

import com.gestao_restaurante.model.Cliente;
import com.gestao_restaurante.model.Funcionario;
import com.gestao_restaurante.repository.ClienteRepository;
import com.gestao_restaurante.repository.FuncionarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Optional;


@Service
public class UserServiceDetails implements UserDetailsService {

    @Autowired
    private ClienteRepository clienteRepository;

    @Autowired
    private FuncionarioRepository funcionarioRepository;

    @Override
    public UserDetails loadUserByUsername(String email)
            throws UsernameNotFoundException {

        Optional<Funcionario> funcionario =
                funcionarioRepository.findByEmail(email);

        if(funcionario.isPresent()){
            return new UsuarioPrincipal(funcionario.get());
        }

        Optional<Cliente> cliente =
                clienteRepository.findByEmail(email);

        if(cliente.isPresent()){
            return new UsuarioPrincipal(cliente.get());
        }

        throw new UsernameNotFoundException("Usuário não encontrado");
    }
}
