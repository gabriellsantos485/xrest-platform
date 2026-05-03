package com.gestao_restaurante.repository;

import com.gestao_restaurante.dto.ItemMaisVendidoDTO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ItemPedidoRepositoryCustomImpl implements ItemPedidoRepositoryCustom {

    @PersistenceContext
    private EntityManager entityManager;

    public List<ItemMaisVendidoDTO> itensMaisVendidos() {
        return entityManager.createQuery(
                        "SELECT new com.seuprojeto.relatorio.ItemMaisVendidoDTO(" +
                                "i.nome, SUM(i.quantidade)) " +
                                "FROM ItemPedido i " +
                                "GROUP BY i.nome " +
                                "ORDER BY SUM(i.quantidade) DESC",
                        ItemMaisVendidoDTO.class)
                .getResultList();
    }
}

