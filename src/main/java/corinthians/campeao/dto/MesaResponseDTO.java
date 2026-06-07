package corinthians.campeao.dto;

import corinthians.campeao.model.MesaStatus;

public record MesaResponseDTO (
     Integer id,
     MesaStatus status,
     String localizacao,
     Short capacidade
) {}
