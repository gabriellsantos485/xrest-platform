package corinthians.campeao.controler;


import corinthians.campeao.dto.CardapioRequestDTO;
import corinthians.campeao.dto.CardapioResponseDTO;
import corinthians.campeao.service.CardapioService;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/xrest/products/")
public class CardapioController {

    private final CardapioService service;

    public CardapioController(CardapioService service){
        this.service = service;
    }
    @PostMapping
    public CardapioResponseDTO criar (@RequestBody CardapioRequestDTO dto){
        return service.criar(dto);
    }

    @GetMapping
    public Map verProdutos(){
        return service.listarAgrupadoPorCategoria();
    }
}
