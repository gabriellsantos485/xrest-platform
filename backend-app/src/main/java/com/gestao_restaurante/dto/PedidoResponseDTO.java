package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.*;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;

public record PedidoResponseDTO (
    Integer id,
    OffsetDateTime criadoEm,
    OffsetDateTime atualizadoEm,
    BigDecimal valorTotal,
    BigDecimal valorPago,
    PedidoStatus status,
    Boolean viagem,
    BigDecimal desconto,
    Integer quantidadePessoas,
    Cliente cliente,
    Mesa mesa,
    Funcionario funcionario,
    List<ItemPedido> itensPedido
) {}
