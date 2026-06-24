package com.gestao_restaurante.repository;

import com.gestao_restaurante.model.Cardapio;
import com.gestao_restaurante.model.StatusCardapio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CardapioRepository extends JpaRepository<Cardapio, Integer> {
    boolean existsByNome(String nome);

    @Override
    List<Cardapio> findAll();

    List<Cardapio> findByCategoriaId(Integer categoriaId);

    List<Cardapio> findByStatus(StatusCardapio status);
}