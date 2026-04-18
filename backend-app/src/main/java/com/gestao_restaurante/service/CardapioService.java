package com.gestao_restaurante.service;

import com.gestao_restaurante.dto.CardapioRequestDTO;
import com.gestao_restaurante.dto.CardapioResponseDTO;
import com.gestao_restaurante.mapper.CardapioMapper;
import com.gestao_restaurante.mapper.CategoriaMapper;
import com.gestao_restaurante.model.Cardapio;
import com.gestao_restaurante.model.Categoria;
import com.gestao_restaurante.model.StatusCardapio;
import com.gestao_restaurante.repository.CardapioRepository;
import com.gestao_restaurante.repository.CategoriaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;


@Service
public class CardapioService {

    private final CardapioRepository repository;
    private final CategoriaRepository categoriaRepository;

    public CardapioService(CardapioRepository repository, CategoriaRepository categoriaRepository){
        this.repository = repository;
        this.categoriaRepository = categoriaRepository;

    }

    public CardapioResponseDTO criar(CardapioRequestDTO dto){
        Categoria categoria = categoriaRepository.findById(dto.categoriaId())
                .orElseThrow();
        Cardapio cardapio = CardapioMapper.toEntity(dto, categoria);
        cardapio = repository.save(cardapio);
        return CardapioMapper.toDTO(cardapio);
    }

    public Map<String, List<CardapioResponseDTO>>  listarAgrupadoPorCategoria(){
        List<Cardapio> itens = repository.findByStatus(StatusCardapio.ATIVO);
        return itens.stream()
                .collect(Collectors.groupingBy(
                        item -> item.getCategoria().getNome(),
                        Collectors.mapping(CardapioMapper::toDTO, Collectors.toList())
                ));
    }
}

