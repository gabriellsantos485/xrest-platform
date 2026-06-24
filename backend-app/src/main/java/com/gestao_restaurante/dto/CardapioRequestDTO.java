package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.StatusCardapio;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

public record CardapioRequestDTO(

        @NotBlank(message = "Nome é obrigatório")
        String nome,

        @NotNull(message = "Valor da unidade é obrigatório")
        BigDecimal valorUnidade,

        @NotBlank(message = "Unidade de medida é obrigatório")
        String unidadeMedida,

        //Não obrigatório
        String descricao,
        String ingredientes,
        Integer porcoesPorPessoa,
        OffsetDateTime inicioPromocao,
        BigDecimal valorPromocional,
        OffsetDateTime terminoPromocao,
        String foto,
        StatusCardapio status,

        @NotNull(message = "Categoria é obrigatório")
        Integer categoriaId


        // TODO: ADICIONAR MEDIDA TANTO NA TABELA QUANTO NO DTO
) { }
