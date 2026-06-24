package com.gestao_restaurante.repository;

import com.gestao_restaurante.model.ItemPedido;
import com.gestao_restaurante.model.ItemPedidoStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ItemPedidoRepository extends JpaRepository<ItemPedido, Integer> {
    List<ItemPedido> findByStatus(ItemPedidoStatus status);
    Optional<ItemPedido> findById(Integer id);
    List<ItemPedido> findByStatusIn(List<ItemPedidoStatus> status);
}
