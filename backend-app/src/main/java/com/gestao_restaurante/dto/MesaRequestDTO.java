package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.MesaStatus;
import jakarta.persistence.Column;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.validation.constraints.NotBlank;

public record MesaRequestDTO(
        //Não é obrigatórioo
        MesaStatus status,

        @NotBlank(message= "Localização é obrigatório")
        String localizacao,

        @NotBlank(message = "Capacidade é obrigatória")
        Short capacidade
) {
}
