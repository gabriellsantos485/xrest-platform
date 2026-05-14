package corinthians.campeao.service;


import corinthians.campeao.config.security.AuthService;
import corinthians.campeao.dto.ClienteRequestDTO;
import corinthians.campeao.mapper.ClienteMapper;
import corinthians.campeao.model.Cliente;
import corinthians.campeao.repository.ClienteRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class ClienteService {

    private final ClienteRepository clienteRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthService authService;

    public ClienteService(ClienteRepository clienteRepository,
                          PasswordEncoder passwordEncoder,
                          AuthService authService){
        this.clienteRepository = clienteRepository;
        this.passwordEncoder = passwordEncoder;
        this.authService = authService;
    }

    public Cliente registrar(ClienteRequestDTO dto){
        Cliente cliente = ClienteMapper.toEntity(dto);
        cliente.setPassword(passwordEncoder.encode(cliente.getPassword()));
        return clienteRepository.save(cliente);
    }

    public String login(ClienteRequestDTO dto){
        return authService.verify(dto);
    }
}
