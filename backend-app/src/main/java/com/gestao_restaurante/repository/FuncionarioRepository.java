package com.gestao_restaurante.repository;

import com.gestao_restaurante.model.Funcionario;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface FuncionarioRepository extends JpaRepository<Funcionario, Integer> {
        Optional<Funcionario> findByEmail(String email);
        Optional<Funcionario> findById(Integer id);

        Optional<Funcionario> findAllBy();
        List<Funcionario> findByStatusTrue();
}


