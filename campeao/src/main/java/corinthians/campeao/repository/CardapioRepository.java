package corinthians.campeao.repository;

import corinthians.campeao.model.Cardapio;
import corinthians.campeao.model.StatusCardapio;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;


public interface CardapioRepository extends JpaRepository<Cardapio, Integer> {
    boolean existsByNome(String nome);

    @Override
    List<Cardapio> findAll();

    List<Cardapio> findByCategoriaId(Integer categoriaId);

    List<Cardapio> findByStatus(StatusCardapio status);
}