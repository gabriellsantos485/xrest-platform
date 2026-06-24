package com.gestao_restaurante.controller;

import com.gestao_restaurante.dto.CardapioRequestDTO;
import com.gestao_restaurante.dto.CardapioResponseDTO;
import com.gestao_restaurante.service.CardapioService;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/xrest/v1/produtos")
@CrossOrigin(origins = "*")
public class CardapioController {

    private final CardapioService service;

    public CardapioController(CardapioService service){
        this.service = service;
    }
    @PostMapping("/cadastrar")
        public CardapioResponseDTO criar (@RequestBody CardapioRequestDTO dto){
        return service.criar(dto);
    }

    @GetMapping
    public Map verProdutos(){
        return service.listarAgrupadoPorCategoria();
    }

    @PutMapping("/{id}")
    public CardapioResponseDTO atualizar(
            @PathVariable Integer id,
            @RequestBody CardapioRequestDTO dto){

        return service.atualizar(id, dto);
    }

    @DeleteMapping("/{id}")
    public CardapioResponseDTO apagar(@PathVariable Integer id) {
        return service.apagar(id);
    }
}
