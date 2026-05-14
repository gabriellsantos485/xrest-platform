package corinthians.campeao.mapper;


import corinthians.campeao.dto.ClienteRequestDTO;
import corinthians.campeao.dto.ClienteResponseDTO;
import corinthians.campeao.model.Cliente;

public class ClienteMapper {

    public static Cliente toEntity(ClienteRequestDTO dto){
        return Cliente.builder()
                .nome(dto.nome())
                .sobrenome(dto.sobrenome())
                .email(dto.email())
                .cpf(dto.cpf())
                .cidade(dto.cidade())
                .bairro(dto.bairro())
                .numeroCasa(dto.numeroCasa())
                .rua(dto.rua())
                .telefone(dto.telefone())
                .password(dto.senha())
                .build();
    }

    public static ClienteResponseDTO toDTO(Cliente entity){
        return new ClienteResponseDTO(
                entity.getId(),
                entity.getNome(),
                entity.getSobrenome(),
                entity.getCpf(),
                entity.getEmail(),
                entity.getCidade(),
                entity.getBairro(),
                entity.getNumeroCasa(),
                entity.getRua(),
                entity.getTelefone()
        );
    }
}
