package com.gestao_restaurante.config.security;

import com.gestao_restaurante.repository.ClienteRepository;
import com.gestao_restaurante.repository.FuncionarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class UserServiceDetails implements UserDetailsService {

    @Autowired
    private ClienteRepository clienteRepo;

    @Autowired
    private FuncionarioRepository funcionarioRepo;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {

        // 1. Tenta buscar na tabela de Clientes
        var cliente = clienteRepo.findByEmail(email);
        if (cliente.isPresent()) {
            return new User(
                    cliente.get().getEmail(),
                    cliente.get().getPassword(),
                    "CLIENTE"
            );
        }

        // 2. Tenta buscar na tabela de Funcionarios
        var funcionario = funcionarioRepo.findByEmail(email);
        if (funcionario.isPresent()) {

            String cargo = funcionario.get().getCargo().name();

            return new User(
                    funcionario.get().getEmail(),
                    funcionario.get().getPassword(),
                    cargo
            );
        }

        throw new UsernameNotFoundException("E-mail não encontrado em nenhuma base do sistema.");
    }

}