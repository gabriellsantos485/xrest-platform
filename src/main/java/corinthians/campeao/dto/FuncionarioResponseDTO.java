package corinthians.campeao.dto;

import java.time.OffsetDateTime;

public record FuncionarioResponseDTO(
        Integer id,
        String nome,
        String sobrenome,
        String username,
        String telefone,
        OffsetDateTime criadoEm,
        OffsetDateTime atualizadoEm
) {
}
