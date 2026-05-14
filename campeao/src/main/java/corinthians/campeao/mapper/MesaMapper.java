package corinthians.campeao.mapper;

import corinthians.campeao.dto.MesaRequestDTO;
import corinthians.campeao.dto.MesaResponseDTO;
import corinthians.campeao.model.Mesa;

public class MesaMapper {

    public static Mesa toEntity(MesaRequestDTO dto){
        return Mesa.builder()
                .status(dto.status())
                .localizacao(dto.localizacao())
                .capacidade(dto.capacidade())
                .build();
    }

    public static MesaResponseDTO toDTO(Mesa entity){
        return new MesaResponseDTO(
                entity.getId(),
                entity.getStatus(),
                entity.getLocalizacao(),
                entity.getCapacidade()
        );
    }

}
