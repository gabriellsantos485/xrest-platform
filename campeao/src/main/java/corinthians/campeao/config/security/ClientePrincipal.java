package corinthians.campeao.config.security;

import corinthians.campeao.model.Cliente;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

public class ClientePrincipal implements UserDetails {

    private Cliente cliente;

    public ClientePrincipal(Cliente cliente) {
        this.cliente = cliente;
    }

    @Override
    public String getUsername() {
        return cliente.getNome();
    }

    @Override
    public String getPassword() {
        return cliente.getPassword();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(); // sem roles por enquanto
    }

    @Override
    public boolean isAccountNonExpired() { return true; }

    @Override
    public boolean isAccountNonLocked() { return true; }

    @Override
    public boolean isCredentialsNonExpired() { return true; }

    @Override
    public boolean isEnabled() { return true; }
}
