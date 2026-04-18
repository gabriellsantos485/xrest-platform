package com.gestao_restaurante.repository;

import com.gestao_restaurante.model.FormaPagamento;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FormaPagamentoRepository extends JpaRepository<FormaPagamento, Integer> {
}
