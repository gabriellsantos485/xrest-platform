package com.gestao_restaurante.service;

import com.gestao_restaurante.dto.CategoriaRequestDTO;
import com.gestao_restaurante.dto.CategoriaResponseDTO;
import com.gestao_restaurante.mapper.CategoriaMapper;
import com.gestao_restaurante.model.Categoria;
import com.gestao_restaurante.repository.CategoriaRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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

    public Map<String, List<Categoria>> listarCategoria(){
        List<Categoria> categorias = repository.findAll();
        return categorias.stream()
                .collect(Collectors.groupingBy(Categoria::getNome));
    }

    public CategoriaResponseDTO atualizar(Integer id, CategoriaRequestDTO dto){
        Categoria categoria = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Categoria não encontrada"));
        categoria.setNome(dto.nome());
        repository.save(categoria);
        return CategoriaMapper.toDPO(categoria);
    }

    public void apagar(Integer id){
        Categoria categoria = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Categoria não encontrada"));
        repository.delete(categoria);
    }
}
