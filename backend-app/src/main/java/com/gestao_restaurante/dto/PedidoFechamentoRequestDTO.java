package com.gestao_restaurante.dto;

import java.math.BigDecimal;
import java.util.List;

public record PedidoFechamentoRequestDTO(
        List<PedidoFormaPagamentoRequestDTO> formasPagamento,
        Integer quantPessoas
) { }
