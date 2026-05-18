package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.MesaStatus;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MesaRequestDTO {

    @NotNull(message = "O status da mesa é obrigatório")
    private MesaStatus status;

    @NotBlank(message = "A localização da mesa é obrigatória")
    private String localizacao;

    @NotNull(message = "A capacidade da mesa é obrigatória")
    @Min(value = 1, message = "A mesa deve comportar pelo menos 1 pessoa")
    private Short capacidade;
}