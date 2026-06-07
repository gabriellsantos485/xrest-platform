package corinthians.campeao.service;


import corinthians.campeao.dto.CardapioRequestDTO;
import corinthians.campeao.dto.CardapioResponseDTO;
import corinthians.campeao.mapper.CardapioMapper;
import corinthians.campeao.model.Cardapio;
import corinthians.campeao.model.Categoria;
import corinthians.campeao.model.StatusCardapio;
import corinthians.campeao.repository.CardapioRepository;
import corinthians.campeao.repository.CategoriaRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;


@Service
public class CardapioService {

    private final CardapioRepository repository;
    private final CategoriaRepository categoriaRepository;

    public CardapioService(CardapioRepository repository, CategoriaRepository categoriaRepository){
        this.repository = repository;
        this.categoriaRepository = categoriaRepository;

    }

    public CardapioResponseDTO criar(CardapioRequestDTO dto){   //Cadastrar cardapio
        Categoria categoria = categoriaRepository.findById(dto.categoriaId())
                .orElseThrow();
        Cardapio cardapio = CardapioMapper.toEntity(dto, categoria);
        cardapio = repository.save(cardapio);
        return CardapioMapper.toDTO(cardapio);
    }

    public Map<String, List<CardapioResponseDTO>>  listarAgrupadoPorCategoria(){  //Consultar cardapio
        List<Cardapio> itens = repository.findByStatus(StatusCardapio.ATIVO);
        return itens.stream()
                .collect(Collectors.groupingBy(
                        item -> item.getCategoria().getNome(),
                        Collectors.mapping(CardapioMapper::toDTO, Collectors.toList())
                ));
    }

    public void reajustarValor(Integer id, BigDecimal novoValor){
        Cardapio cardapio = repository.findById(id).orElseThrow();
        cardapio.setValorUnidade(novoValor);
        repository.save(cardapio);
    }

    public void adicionarPromocoes(Integer id,OffsetDateTime inicio, BigDecimal valorPromocional, OffsetDateTime fim){
        Cardapio cardapio = repository.findById(id).orElseThrow();
        cardapio.setInicioPromocao(inicio);
        cardapio.setValorPromocional(valorPromocional);
        cardapio.setTerminoPromocao(fim);
        repository.save(cardapio);
    }

    public void alterarStatus(Integer id, StatusCardapio status){
        Cardapio cardapio = repository.findById(id).orElseThrow();
        cardapio.setStatus(status);
        repository.save(cardapio);
    }

    public void desabilitar(Integer id){
        Cardapio cardapio = repository.findById(id).orElseThrow();
        cardapio.setStatus(StatusCardapio.INATIVO);
        repository.save(cardapio);
    }

}

