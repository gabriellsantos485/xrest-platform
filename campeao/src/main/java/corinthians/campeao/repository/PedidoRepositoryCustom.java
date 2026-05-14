package corinthians.campeao.repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

public interface PedidoRepositoryCustom {
    BigDecimal sumValorByData(LocalDate data);
    BigDecimal sumValorByDataHoraBetween(OffsetDateTime inicio, OffsetDateTime fim);
}
