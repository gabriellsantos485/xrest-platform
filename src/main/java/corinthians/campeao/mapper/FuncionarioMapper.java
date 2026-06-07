package corinthians.campeao.mapper;

import corinthians.campeao.dto.FuncionarioRequestDTO;
import corinthians.campeao.dto.FuncionarioResponseDTO;
import corinthians.campeao.model.Funcionario;

import java.time.OffsetDateTime;

public class FuncionarioMapper {
    public static Funcionario toEntity(FuncionarioRequestDTO dto){
        return Funcionario.builder()
                .nome(dto.nome())
                .sobrenome(dto.sobrenome())
                .telefone(dto.telefone())
                .cargo(dto.cargo())
                .email(dto.email())
                .password(dto.senha())
                .username(dto.username())
                .criadoEm(OffsetDateTime.now())
                .atualizadoEm(null)
                .build();
    }

    public static FuncionarioResponseDTO toDTO(Funcionario entity){
        return new FuncionarioResponseDTO(
                entity.getId(),
                entity.getNome(),
                entity.getSobrenome(),
                entity.getUsername(),
                entity.getTelefone(),
                entity.getCriadoEm(),
                entity.getAtualizadoEm()
        );
    }
}
