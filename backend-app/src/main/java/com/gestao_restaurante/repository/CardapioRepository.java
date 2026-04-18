package com.gestao_restaurante.repository;
import com.gestao_restaurante.model.Cardapio;
import com.gestao_restaurante.model.Categoria;
import com.gestao_restaurante.model.StatusCardapio;
import org.springframework.data.jpa.repository.JpaRepository;

import javax.smartcardio.Card;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;


public interface CardapioRepository extends JpaRepository<Cardapio, Integer> {
    boolean existsByNome(String nome);

    @Override
    List<Cardapio> findAll();

    List<Cardapio> findByCategoriaId(Integer categoriaId);

    List<Cardapio> findByStatus(StatusCardapio status);
}