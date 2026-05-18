package com.gestao_restaurante.mapper;

import com.gestao_restaurante.dto.MesaRequestDTO;
import com.gestao_restaurante.dto.MesaResponseDTO;
import com.gestao_restaurante.model.Mesa;

public class MesaMapper {

    public static Mesa toEntity(MesaRequestDTO dto) {
        return Mesa.builder()
                .status(dto.getStatus())
                .localizacao(dto.getLocalizacao())
                .capacidade(dto.getCapacidade())
                .build();
    }

    public static MesaResponseDTO toResponseDTO(Mesa entity) {
        return new MesaResponseDTO(
                entity.getId(),
                entity.getStatus(),
                entity.getLocalizacao(),
                entity.getCapacidade()
        );
    }
}
