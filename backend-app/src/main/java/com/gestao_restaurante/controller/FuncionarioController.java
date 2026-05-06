package com.gestao_restaurante.controller;

import com.gestao_restaurante.dto.CardapioRequestDTO;
import com.gestao_restaurante.dto.CardapioResponseDTO;
import com.gestao_restaurante.dto.FuncionarioRequestDTO;
import com.gestao_restaurante.dto.FuncionarioResponseDTO;
import com.gestao_restaurante.model.Funcionario;
import com.gestao_restaurante.service.CardapioService;
import com.gestao_restaurante.service.FuncionarioService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/xrest/funcionario/")
@CrossOrigin(origins = "*")
public class FuncionarioController {

    private final FuncionarioService funcionarioService;

    public FuncionarioController(FuncionarioService funcionarioService){
        this.funcionarioService = funcionarioService;
    }

    @PostMapping
    public FuncionarioResponseDTO criar (@RequestBody FuncionarioRequestDTO dto){
        return funcionarioService.criar(dto);
    }

}
