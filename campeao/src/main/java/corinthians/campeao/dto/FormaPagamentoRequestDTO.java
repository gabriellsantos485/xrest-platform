package corinthians.campeao.dto;

import jakarta.validation.constraints.NotBlank;

public record FormaPagamentoRequestDTO(
        @NotBlank(message = "Nome é obrigatório")
        String nome
) {
}
