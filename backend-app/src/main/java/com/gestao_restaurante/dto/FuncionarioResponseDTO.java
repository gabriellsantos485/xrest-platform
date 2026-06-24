package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.FuncionarioCargo;
import java.time.OffsetDateTime;

public record FuncionarioResponseDTO(
        Integer id,
        String nome,
        String sobrenome,
        String telefone,
        String email,
        FuncionarioCargo cargo,
        Boolean status,
        OffsetDateTime criadoEm,
        OffsetDateTime atualizadoEm,
        String username
) {
}
