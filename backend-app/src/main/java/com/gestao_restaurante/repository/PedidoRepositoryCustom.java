package com.gestao_restaurante.repository;

import com.gestao_restaurante.model.Pedido;

import java.time.LocalDate;
import java.util.List;

public interface PedidoRepositoryCustom {
    List<Pedido> pedidosPorData(LocalDate date);
}
