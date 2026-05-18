package com.gestao_restaurante.mapper;

import com.gestao_restaurante.dto.FormaPagamentoRequestDTO;
import com.gestao_restaurante.dto.FormaPagamentoResponseDTO;
import com.gestao_restaurante.model.FormaPagamento;


public class FormaPagamentoMapper {
    private FormaPagamentoMapper() {
        throw new UnsupportedOperationException("Utility class");
    }

    public static FormaPagamento toEntity(FormaPagamentoRequestDTO dto) {
        return FormaPagamento.builder()
                .nome(dto.nome())
                .build();
    }

    public static FormaPagamentoResponseDTO toResponseDTO(FormaPagamento entity) {
        return new FormaPagamentoResponseDTO(
                entity.getId(),
                entity.getNome()
        );
    }

    public static void updateEntity(FormaPagamentoRequestDTO requestDTO, FormaPagamento entity) {
        entity.setNome(requestDTO.nome());
    }
}