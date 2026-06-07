package corinthians.campeao.dto;

import corinthians.campeao.model.MesaStatus;
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
