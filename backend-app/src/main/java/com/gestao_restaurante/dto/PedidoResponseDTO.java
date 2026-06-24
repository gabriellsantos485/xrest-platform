package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.PedidoStatus;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;

public record PedidoResponseDTO(
        Integer id,
        Boolean viagem,
        OffsetDateTime criadoEm,
        OffsetDateTime atualizadoEm,
        BigDecimal valorTotal,
        BigDecimal valorPago,
        BigDecimal desconto,
        PedidoStatus status,
        Integer quantidadePessoas,
        String clienteNome,
        Integer mesaId,
        Integer funcionarioId,
        List<ItemPedidoResponseDTO> itens
) {
}
