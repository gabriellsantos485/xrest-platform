package com.gestao_restaurante.repository;

import com.gestao_restaurante.model.PedidoFormaPagamento;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PedidoFormaPagamentoRepository extends JpaRepository<PedidoFormaPagamento, Integer> {
}
