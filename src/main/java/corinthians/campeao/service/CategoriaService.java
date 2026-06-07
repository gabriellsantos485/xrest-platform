package corinthians.campeao.service;


import corinthians.campeao.dto.CategoriaRequestDTO;
import corinthians.campeao.dto.CategoriaResponseDTO;
import corinthians.campeao.mapper.CategoriaMapper;
import corinthians.campeao.model.Categoria;
import corinthians.campeao.repository.CategoriaRepository;
import org.springframework.stereotype.Service;

@Service
public class CategoriaService {

    private final CategoriaRepository repository;

    public CategoriaService(CategoriaRepository repository){
        this.repository = repository;
    }

    public CategoriaResponseDTO criar(CategoriaRequestDTO dto){
        Categoria categoria = CategoriaMapper.toEntity(dto);
        categoria = repository.save(categoria);
        return CategoriaMapper.toDPO(categoria);
    }
}
