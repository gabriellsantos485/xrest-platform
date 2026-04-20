package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.Cardapio;
import com.gestao_restaurante.model.Funcionario;
import com.gestao_restaurante.model.ItemPedidoStatus;
import com.gestao_restaurante.model.Pedido;
import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

public record ItemPedidoRequestDTO (

    @NotBlank(message = "Quantidade é obrigatório")
    Integer quantidade,

    @NotNull(message = "Valor unitario é obrigatório")
    BigDecimal valor_unitario,

    @NotNull(message = "Valor total é obrigatório")
    BigDecimal valor_total,

    @NotBlank(message = "Valor descontado é obrigatório")
    OffsetDateTime criadoEm,

    //Não obrigatório
    BigDecimal valor_descontado,
    String observacoes,
    ItemPedidoStatus status,

    @NotNull(message = "Pedido é obrigatório")
    Pedido pedido,

    @NotNull(message = "Cardápio é obrigatório")
    Cardapio cardapio,

    @NotNull(message = "Funcionario é obrigatório")
    Funcionario funcionario,

    @NotNull(message = "Liberacao do funcionario é obrigatório")
    Funcionario funcionario_liberou
    ){}
