package com.gestao_restaurante.service;

import com.gestao_restaurante.dto.CategoriaRequestDTO;
import com.gestao_restaurante.dto.CategoriaResponseDTO;
import com.gestao_restaurante.mapper.CategoriaMapper;
import com.gestao_restaurante.model.Categoria;
import com.gestao_restaurante.repository.CategoriaRepository;
import org.springframework.stereotype.Service;

@Service
public class CategoriaService {

    private final CategoriaRepository repository;

    public CategoriaService(CategoriaRepository repository){
        this.repository = repository;
    }

    public CategoriaResponseDTO criar(CategoriaRequestDTO dto){
        Categoria categoria = CategoriaMapper.toEntity(dto);
        categoria = repository.save(categoria);
        return CategoriaMapper.toDPO(categoria);
    }
}
