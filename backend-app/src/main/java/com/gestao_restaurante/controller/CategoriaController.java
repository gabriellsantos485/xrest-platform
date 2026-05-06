package com.gestao_restaurante.controller;

import com.gestao_restaurante.dto.CategoriaRequestDTO;
import com.gestao_restaurante.dto.CategoriaResponseDTO;
import com.gestao_restaurante.service.CategoriaService;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/xrest/categorias/")
@CrossOrigin(origins = "*")
public class CategoriaController {

    private final CategoriaService service;

    public CategoriaController(CategoriaService service) {
        this.service = service;
    }

    @PostMapping
    public CategoriaResponseDTO criar (@RequestBody CategoriaRequestDTO dto){
        return service.criar(dto);
    }

    @GetMapping
    public Map verCategoria(){
        return service.listarCategoria();
    }

    @PutMapping("/{id}")
    public CategoriaResponseDTO atualizar(
            @PathVariable Integer id,
            @RequestBody CategoriaRequestDTO dto) {

        return service.atualizar(id, dto);
    }

    @DeleteMapping("/{id}")
    public void apagarCategoria(@PathVariable Integer id){ service.apagar(id);}
}
