package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.Categoria;
import com.gestao_restaurante.model.StatusCardapio;
import jakarta.validation.constraints.NotBlank;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.Date;

public record CardapioResponseDTO(
        Integer id,
        String nome,
        BigDecimal valorUnidade,
        String unidadeMedida,
        String descricao,
        String ingredientes,
        Integer porcoesPorPessoa,
        OffsetDateTime inicioPromocao,
        BigDecimal valorPromocional,
        OffsetDateTime terminoPromocao,
        String foto,
        StatusCardapio status,
        Categoria categoria
) {
}
