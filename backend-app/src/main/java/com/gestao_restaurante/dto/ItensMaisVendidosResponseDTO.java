package com.gestao_restaurante.dto;

import java.math.BigDecimal;

public record ItensMaisVendidosResponseDTO(
        Integer idItem,
        String imagem,
        String nome,
        String categoria,
        Long quantidadeVendida,
        BigDecimal valorArrecadado
) {
}
