package corinthians.campeao.config.security;

import corinthians.campeao.dto.LoginRequestDTO;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final AuthenticationManager authManager;
    private final JwtService jwtService;

    public AuthService(AuthenticationManager authManager, JwtService jwtService) {
        this.authManager = authManager;
        this.jwtService = jwtService;
    }

    public String verify(LoginRequestDTO dto) {

        Authentication authentication = authManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        dto.email(),
                        dto.senha()
                )
        );

        if (authentication.isAuthenticated()) {
            UsuarioPrincipal principal = (UsuarioPrincipal) authentication.getPrincipal();

            var token = jwtService.generateToken(principal);
            System.out.println("Token gerado com sucesso:" + token);
            return token;
        }

        throw new RuntimeException("Credenciais inválidas");
    }
}

