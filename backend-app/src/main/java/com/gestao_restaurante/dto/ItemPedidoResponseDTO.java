package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.Cardapio;
import com.gestao_restaurante.model.Funcionario;
import com.gestao_restaurante.model.ItemPedidoStatus;
import com.gestao_restaurante.model.Pedido;
import jakarta.validation.constraints.NotBlank;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

public record ItemPedidoResponseDTO (
    Integer id,
    Integer quantidade,
    BigDecimal valor_unitario,
    BigDecimal valor_total,
    OffsetDateTime criadoEm,
    BigDecimal valor_descontado,
    String observacoes,
    ItemPedidoStatus status,
    Pedido pedido,
    Cardapio cardapio,
    Funcionario funcionario,
    Funcionario funcionario_liberou
) {}
