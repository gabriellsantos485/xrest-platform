package corinthians.campeao.mapper;


import corinthians.campeao.dto.CardapioRequestDTO;
import corinthians.campeao.dto.CardapioResponseDTO;
import corinthians.campeao.model.Cardapio;
import corinthians.campeao.model.Categoria;

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
