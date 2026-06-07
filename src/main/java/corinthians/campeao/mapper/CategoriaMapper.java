package corinthians.campeao.mapper;


import corinthians.campeao.dto.CategoriaRequestDTO;
import corinthians.campeao.dto.CategoriaResponseDTO;
import corinthians.campeao.model.Categoria;

public class CategoriaMapper {

    public static Categoria toEntity(CategoriaRequestDTO dto){
        return Categoria.builder()
                .nome(dto.nome()).build();
    }

    public static CategoriaResponseDTO toDPO(Categoria entity){
        return new CategoriaResponseDTO(
                entity.getId(),
                entity.getNome()
        );
    }
}
