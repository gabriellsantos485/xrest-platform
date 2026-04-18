package com.gestao_restaurante.mapper;

import com.gestao_restaurante.dto.CardapioRequestDTO;
import com.gestao_restaurante.dto.CardapioResponseDTO;
import com.gestao_restaurante.model.Cardapio;
import com.gestao_restaurante.model.Categoria;

public class CardapioMapper {

    public static Cardapio toEntity(CardapioRequestDTO dto, Categoria categoria){
        return Cardapio.builder()
                .nome(dto.nome())
                .valorUnidade(dto.valorUnidade())
                .unidadeMedida(dto.unidadeMedida())
                .descricao(dto.descricao())
                .ingredientes(dto.ingredientes())
                .porcoesPorPessoa(dto.porcoesPorPessoa())
                .inicioPromocao(dto.inicioPromocao())
                .terminoPromocao(dto.terminoPromocao())
                .foto(dto.foto())
                .status(dto.status())
                .categoria(categoria).build();
    }

    public static CardapioResponseDTO toDTO(Cardapio entity){
        return new CardapioResponseDTO(
                entity.getId(),
                entity.getNome(),
                entity.getValorUnidade(),
                entity.getUnidadeMedida(),
                entity.getDescricao(),
                entity.getIngredientes(),
                entity.getPorcoesPorPessoa(),
                entity.getInicioPromocao(),
                entity.getValorPromocional(),
                entity.getTerminoPromocao(),
                entity.getFoto(),
                entity.getStatus(),
                entity.getCategoria()
        );
    }
}
