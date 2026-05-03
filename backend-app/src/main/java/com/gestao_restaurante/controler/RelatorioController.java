package com.gestao_restaurante.controler;

import com.gestao_restaurante.dto.RelatorioResponseDTO;
import com.gestao_restaurante.service.RelatorioService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;

@RestController
@RequestMapping("/relatorio")
public class RelatorioController {

    private final RelatorioService relatorioService;

    public RelatorioController(RelatorioService relatorioService) {
        this.relatorioService = relatorioService;
    }

    @GetMapping
    public RelatorioResponseDTO gerarRelatorio() {
        return relatorioService.gerarRelatorio();
    }
}
