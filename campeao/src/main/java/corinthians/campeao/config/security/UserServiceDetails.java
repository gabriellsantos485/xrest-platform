package corinthians.campeao.config.security;


import corinthians.campeao.model.Cliente;
import corinthians.campeao.repository.ClienteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class UserServiceDetails implements UserDetailsService {

    @Autowired
    private ClienteRepository repo;

    @Override
    public UserDetails loadUserByUsername(String nome) throws UsernameNotFoundException {
        Cliente cliente = repo.findByNome(nome)
                .orElseThrow(() -> new UsernameNotFoundException("Usuário não encontrado"));

        return new ClientePrincipal(cliente); //ClientePrincipal implements UserDetails.
    }

}
