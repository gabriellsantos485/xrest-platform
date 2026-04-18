package com.gestao_restaurante.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.hibernate.validator.constraints.br.CPF;

public record ClienteRequestDTO(

        @NotBlank(message = "Nome é obrigatório")
        String nome,

        @NotBlank(message = "Sobrenome é obrigatório")
        String sobrenome,

        @CPF(message = "CPF inválido")
        String cpf,

        @NotBlank(message = "Email é obrigatório")
        @Email(message = "Email inválido")
        String email,

        @NotBlank(message = "Cidade é obrigatória")
        String cidade,

        @NotBlank(message = "Bairro é obrigatório")
        String bairro,

        @NotNull(message = "Número da casa é obrigatório")
        Integer numeroCasa,

        @NotBlank(message = "Rua é obrigatória")
        String rua,

        @NotBlank(message = "Telefone é obrigatório")
        String telefone,

        @NotBlank(message = "Senha é obrigatória")
        @Size(min = 8, message = "Senha deve ter no mínimo 8 caracteres")
        String senha
) {}