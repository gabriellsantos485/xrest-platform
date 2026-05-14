package corinthians.campeao.dto;

import corinthians.campeao.model.Categoria;
import corinthians.campeao.model.StatusCardapio;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

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
