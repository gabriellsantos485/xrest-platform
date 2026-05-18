package com.gestao_restaurante.repository;

import com.gestao_restaurante.model.Pedido;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.OffsetDateTime;
import java.util.List;

public interface PedidoRepository extends JpaRepository<Pedido, Integer> {
    List<Pedido> findByStatus(String status);
    List<Pedido> findByCriadoEmBetween(OffsetDateTime dataInicio, OffsetDateTime dataFim);
    List<Pedido> findByMesaId(Integer mesaId);
    List<Pedido> findByClienteId(Integer clienteId);
}
