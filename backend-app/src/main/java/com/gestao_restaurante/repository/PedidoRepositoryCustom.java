package com.gestao_restaurante.repository;

import com.gestao_restaurante.model.Pedido;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public interface PedidoRepositoryCustom {
    List<Pedido> pedidosPorData(LocalDate date);
    Long quantidadeVendas(LocalDate date);
    BigDecimal valorTotalVendas(LocalDate data);
    BigDecimal pedidosPorHora(LocalDateTime inicio, LocalDateTime fim);
    List<Pedido> pedidosEmAndamento();
    List<Pedido> pedidosCancelados(LocalDate date);
    String escolherMesa(Integer id);
}
