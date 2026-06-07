package corinthians.campeao.service;

import corinthians.campeao.config.security.AuthService;
import corinthians.campeao.dto.FuncionarioRequestDTO;
import corinthians.campeao.dto.LoginRequestDTO;
import corinthians.campeao.mapper.FuncionarioMapper;
import corinthians.campeao.model.Funcionario;
import corinthians.campeao.repository.FuncionarioRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class FuncionarioService {

    private FuncionarioRepository funcionarioRepo;
    private final PasswordEncoder passwordEncoder;
    private AuthService authService;

    public FuncionarioService(FuncionarioRepository funcionarioRepo, PasswordEncoder passwordEncoder, AuthService authService){
        this.funcionarioRepo = funcionarioRepo;
        this.passwordEncoder = passwordEncoder;
        this.authService = authService;
    }

    //‘Login’ do Funcionario
    public void efetuarLogin(LoginRequestDTO dto){ //LoginRequestDTO é um record com dois atributos: email e nome
        authService.verify(dto);
    }

    //Cadastro do funcionário.
    //Apenas Admin tem autorização para usar esse metodo.
    public Funcionario cadastrarFuncionario(FuncionarioRequestDTO dto){
        Funcionario funcionario = FuncionarioMapper.toEntity(dto);
        funcionario.setPassword(passwordEncoder.encode(funcionario.getPassword()));
        return funcionarioRepo.save(funcionario);
    }
}
