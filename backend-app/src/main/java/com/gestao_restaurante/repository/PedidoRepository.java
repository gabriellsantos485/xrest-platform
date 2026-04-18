package com.gestao_restaurante.repository;

import com.gestao_restaurante.model.Pedido;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PedidoRepository extends JpaRepository<Pedido, Integer> {
}
