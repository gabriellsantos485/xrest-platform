package corinthians.campeao.controler;

import corinthians.campeao.dto.FuncionarioRequestDTO;
import corinthians.campeao.dto.LoginRequestDTO;
import corinthians.campeao.model.Funcionario;
import corinthians.campeao.service.FuncionarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class FuncionarioController {

    @Autowired
    private FuncionarioService service;


    @PostMapping("/cadastrarFuncionario")
    public Funcionario cadastrarFuncionario(@RequestBody FuncionarioRequestDTO dto){
        return service.cadastrarFuncionario(dto);
    }

    @PostMapping("/login")
    public void efetuarLogin(@RequestBody LoginRequestDTO dto){
        service.efetuarLogin(dto);
    }

}
