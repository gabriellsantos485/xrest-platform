package com.gestao_restaurante.service;

import com.gestao_restaurante.dto.CardapioRequestDTO;
import com.gestao_restaurante.dto.CardapioResponseDTO;
import com.gestao_restaurante.mapper.CardapioMapper;
import com.gestao_restaurante.model.Cardapio;
import com.gestao_restaurante.model.Categoria;
import com.gestao_restaurante.model.StatusCardapio;
import com.gestao_restaurante.repository.CardapioRepository;
import com.gestao_restaurante.repository.CategoriaRepository;
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

    public CardapioResponseDTO atualizar(Integer id, CardapioRequestDTO dto){
        Categoria categoria = categoriaRepository.findById(dto.categoriaId())
                .orElseThrow(() -> new RuntimeException("Categoria não encontrada"));

        Cardapio produto = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Produto não encontrado"));

        produto.setNome(dto.nome());
        produto.setValorUnidade(dto.valorUnidade());
        produto.setUnidadeMedida(dto.unidadeMedida());
        produto.setDescricao(dto.descricao());
        produto.setIngredientes(dto.ingredientes());
        produto.setPorcoesPorPessoa(dto.porcoesPorPessoa());
        produto.setInicioPromocao(dto.inicioPromocao());
        produto.setValorPromocional(dto.valorPromocional());
        produto.setTerminoPromocao(dto.terminoPromocao());
        produto.setFoto(dto.foto());
        produto.setStatus(dto.status());
        produto.setCategoria(categoria);

        repository.save(produto);

        return CardapioMapper.toDTO(produto);
    }

    public CardapioResponseDTO apagar(Integer id) {
        Cardapio produto = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Produto não encontrado"));

        produto.setStatus(StatusCardapio.INATIVO);
        repository.save(produto);
        return CardapioMapper.toDTO(produto);
    }
}

