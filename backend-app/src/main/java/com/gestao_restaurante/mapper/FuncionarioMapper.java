package com.gestao_restaurante.mapper;

import com.gestao_restaurante.dto.FormaPagamentoRequestDTO;
import com.gestao_restaurante.dto.FuncionarioRequestDTO;
import com.gestao_restaurante.dto.FuncionarioResponseDTO;
import com.gestao_restaurante.model.FormaPagamento;
import com.gestao_restaurante.model.Funcionario;

public class FuncionarioMapper {

    public static Funcionario toEntity(FuncionarioRequestDTO dto){
        return Funcionario.builder()
                .nome(dto.nome())
                .sobrenome(dto.sobrenome())
                .telefone(dto.telefone())
                .email(dto.email())
                .cargo(dto.cargo())
                .status(dto.status())
                .username(dto.username())
                .password(dto.senha()).build();
    }

    public static FuncionarioResponseDTO toDTO(Funcionario entity){
        return new FuncionarioResponseDTO(
                entity.getId(),
                entity.getNome(),
                entity.getSobrenome(),
                entity.getTelefone(),
                entity.getEmail(),
                entity.getCargo(),
                entity.getStatus(),
                entity.getCriadoEm(),
                entity.getAtualizadoEm(),
                entity.getUsername()
        );
    }

    public static void updateEntity(FormaPagamentoRequestDTO dto, FormaPagamento entity) {
        entity.setNome(dto.nome());
    }
}
