package com.gestao_restaurante.controller;

import com.gestao_restaurante.dto.*;
import com.gestao_restaurante.model.Funcionario;
import com.gestao_restaurante.service.CardapioService;
import com.gestao_restaurante.service.FuncionarioService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/xrest")
@CrossOrigin(origins = "*")
public class FuncionarioController {

    private final FuncionarioService funcionarioService;

    public FuncionarioController(FuncionarioService funcionarioService){
        this.funcionarioService = funcionarioService;
    }

    @GetMapping("/funcionarios")
    public ResponseEntity<List<FuncionarioResponseDTO>> listarFuncionarios(){
        return ResponseEntity.ok(
                funcionarioService.listarFuncionarios()
        );
    }

    @PostMapping("/funcionario/register")
    public FuncionarioResponseDTO criarFuncionario (@RequestBody FuncionarioRequestDTO dto){
        return funcionarioService.criarFuncionario(dto);
    }

    @PutMapping("/funcionario/atualizar/{id}")
    public  FuncionarioResponseDTO atualizarFuncionario (
            @PathVariable Integer id,
            @RequestBody FuncionarioRequestDTO dto
    ){
        return funcionarioService.atualizarFuncionario(dto, id);
    }

    @DeleteMapping("/funcionario/delete/{id}")
    public boolean deletarFuncionario(@PathVariable Integer id){
        return funcionarioService.deletarFuncionario(id);
    }

}

