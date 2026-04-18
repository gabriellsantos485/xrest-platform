package com.gestao_restaurante.mapper;

import com.gestao_restaurante.dto.CategoriaRequestDTO;
import com.gestao_restaurante.dto.CategoriaResponseDTO;
import com.gestao_restaurante.model.Categoria;

public class CategoriaMapper {

    public static Categoria toEntity(CategoriaRequestDTO dto){
        return Categoria.builder()
                .nome(dto.nome()).build();
    }

    public static CategoriaResponseDTO toDPO(Categoria entity){
        return new CategoriaResponseDTO(
                entity.getId(),
                entity.getNome()
        );
    }
}
