package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.FuncionarioCargo;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record FuncionarioRequestDTO(

        @NotBlank(message = "Nome é obrigatório")
        String nome,

        @NotBlank(message = "Sobrenome é obrigatório")
        String sobrenome,

        @NotBlank(message = "Email é obrigatório")
        String email,

        @NotBlank(message = "Telefone é obrigatório")
        String telefone,

        @NotNull(message = "Cargo é obrigatório")
        FuncionarioCargo cargo,

        @NotNull(message = "Status é obrigatório")
        Boolean status,

        @NotBlank(message = "Username é obrigatório")
        @Size(min = 8, message = "Username deve ter no mínimo 8 caracteres")
        String username,

        @NotBlank(message = "Senha é obrigatória")
        String senha

) { }