package corinthians.campeao.repository;

import corinthians.campeao.model.Cliente;
import corinthians.campeao.model.Cardapio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ClienteRepository extends JpaRepository<Cliente, Long> {

    boolean existsByEmail(String email);
    boolean existsByCpf(String cpf);
    boolean existsByTelefone(String telefone);

    Optional<Cliente> findByEmail(String email);
    Optional<Cliente> findByCpf(String cpf);
    Optional<Cardapio> findByNome(String nome);
}
