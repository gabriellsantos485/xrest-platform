package com.gestao_restaurante.controler;

import com.gestao_restaurante.dto.CardapioRequestDTO;
import com.gestao_restaurante.dto.CardapioResponseDTO;
import com.gestao_restaurante.dto.CategoriaRequestDTO;
import com.gestao_restaurante.dto.CategoriaResponseDTO;
import com.gestao_restaurante.service.CategoriaService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/xrest/categoria/")
public class CategoriaController {

    private final CategoriaService service;

    public CategoriaController(CategoriaService service) {
        this.service = service;
    }

    @PostMapping
    public CategoriaResponseDTO criar (@RequestBody CategoriaRequestDTO dto){
        return service.criar(dto);
    }
}
