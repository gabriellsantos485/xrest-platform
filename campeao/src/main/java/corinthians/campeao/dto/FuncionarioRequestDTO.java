package corinthians.campeao.dto;

import corinthians.campeao.model.FuncionarioCargo;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record FuncionarioRequestDTO(
        @NotBlank(message = "Nome é obrigatório")
        String nome,

        @NotBlank(message = "Sobrenome é obrigatório")
        String sobrenome,

        @NotBlank(message = "Telefone é obrigatório")
        String telefone,

        @NotBlank(message = "Cargo é obrigatório")
        FuncionarioCargo cargo,

        @NotBlank(message = "Email é obrigatório")
        String email,

        @NotBlank(message = "Senha é obrigatório")
        @Size(min = 8, message = "Senha deve ter no mínimo 8 caracteres")
        String senha,

        @NotBlank(message = "Username é obrigatório")
        @Size(min = 10, message = "Username deve ter no mínimo 8 caracteres")
        String username
) { }
