package com.gestao_restaurante.repository;

import com.gestao_restaurante.model.Cliente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ClienteRepository extends JpaRepository<Cliente, Integer> {

    boolean existsByEmail(String email);
    boolean existsByCpf(String cpf);
    boolean existsByTelefone(String telefone);

    Optional<Cliente> findByEmail(String email);
    Optional<Cliente> findByCpf(String cpf);
    List<Cliente> findAllBy();
    Optional<Cliente> findById(Integer id);
}
