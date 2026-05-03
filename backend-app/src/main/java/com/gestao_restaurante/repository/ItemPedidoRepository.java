package com.gestao_restaurante.repository;

import com.gestao_restaurante.model.ItemPedido;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ItemPedidoRepository extends JpaRepository<ItemPedido, Integer>, ItemPedidoRepositoryCustom {
}
