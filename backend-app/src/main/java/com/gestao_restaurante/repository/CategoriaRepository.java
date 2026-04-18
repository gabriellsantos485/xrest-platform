package com.gestao_restaurante.repository;

import com.gestao_restaurante.model.Cardapio;
import com.gestao_restaurante.model.Categoria;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CategoriaRepository extends JpaRepository<Categoria, Integer> {

}
