package com.gestao_restaurante.dto;

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
