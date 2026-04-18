package com.gestao_restaurante.repository;

import com.gestao_restaurante.model.Mesa;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MesaRepository extends JpaRepository<Mesa, Integer> {
}
