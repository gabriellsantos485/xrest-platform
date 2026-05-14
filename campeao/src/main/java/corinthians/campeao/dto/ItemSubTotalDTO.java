package corinthians.campeao.dto;

import java.math.BigDecimal;

public record ItemSubTotalDTO(
        BigDecimal valor,
        Integer quantidade)
{}
