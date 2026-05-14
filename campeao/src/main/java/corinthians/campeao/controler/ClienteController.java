package corinthians.campeao.controler;

import corinthians.campeao.dto.ClienteRequestDTO;
import corinthians.campeao.model.Cliente;
import corinthians.campeao.repository.ClienteRepository;
import corinthians.campeao.service.ClienteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class ClienteController{

    @Autowired
    private ClienteService service;

    @Autowired
    private ClienteRepository repository;

    @Autowired
    private PasswordEncoder passwordEncoder; // Para salvar a senha criptografada

    @PostMapping("/teste")
    public ResponseEntity<String> criarTeste(@RequestBody Cliente cliente) {
        cliente.setPassword(passwordEncoder.encode(cliente.getPassword()));

        repository.save(cliente);

        return ResponseEntity.ok("Cliente salvo com sucesso no Supabase!");
    }

    @GetMapping("/pegar")
    public List<Cliente> pegarTeste() {
        return repository.findAll();
    }

    @PostMapping("/registrar")
    public Cliente registrar(@RequestBody ClienteRequestDTO dto){
        return service.registrar(dto);
    }

    @PostMapping("/login")
    public String login(@RequestBody ClienteRequestDTO dto){
        return service.login(dto);
    }


}

