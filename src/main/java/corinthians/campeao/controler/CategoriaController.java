package corinthians.campeao.controler;


import corinthians.campeao.dto.CategoriaRequestDTO;
import corinthians.campeao.dto.CategoriaResponseDTO;
import corinthians.campeao.service.CategoriaService;
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
