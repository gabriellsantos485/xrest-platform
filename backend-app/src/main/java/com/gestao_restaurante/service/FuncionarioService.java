package com.gestao_restaurante.service;

import com.gestao_restaurante.dto.FuncionarioRequestDTO;
import com.gestao_restaurante.dto.FuncionarioResponseDTO;
import com.gestao_restaurante.mapper.FuncionarioMapper;
import com.gestao_restaurante.model.Funcionario;
import com.gestao_restaurante.repository.FuncionarioRepository;

public class FuncionarioService {

    private final FuncionarioRepository funcionarioRepository;

    public FuncionarioService(FuncionarioRepository funcionarioRepository){
        this.funcionarioRepository = funcionarioRepository;
    }

    public FuncionarioResponseDTO criar(FuncionarioRequestDTO dto){
        Funcionario funcionario = FuncionarioMapper.toEntity(dto);
        funcionario = funcionarioRepository.save(funcionario);
        return FuncionarioMapper.toDTO(funcionario);
    }
}
