package corinthians.campeao.controler;

import corinthians.campeao.dto.RelatorioResponseDTO;
import corinthians.campeao.service.RelatorioService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/relatorio")
public class RelatorioController {

    private final RelatorioService relatorioService;

    public RelatorioController(RelatorioService relatorioService) {
        this.relatorioService = relatorioService;
    }

    @GetMapping
    public ResponseEntity<RelatorioResponseDTO> gerarRelatorio() {
        RelatorioResponseDTO relatorio = relatorioService.gerarRelatorio();
        return ResponseEntity.ok(relatorio);
    }
}
