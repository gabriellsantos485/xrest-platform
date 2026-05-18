package com.gestao_restaurante.dto;

public class AuthResponseDTO {

    private String token;
    private FuncionarioResponseDTO funcionario;

    public AuthResponseDTO(String token, FuncionarioResponseDTO funcionario) {
        this.token = token;
        this.funcionario = funcionario;
    }

    public String getToken() {
        return token;
    }

    public FuncionarioResponseDTO getFuncionario() {
        return funcionario;
    }
}
