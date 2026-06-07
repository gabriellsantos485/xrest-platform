package corinthians.campeao.service;


import corinthians.campeao.dto.MesaRequestDTO;
import corinthians.campeao.dto.MesaResponseDTO;
import corinthians.campeao.mapper.MesaMapper;
import corinthians.campeao.model.Mesa;
import corinthians.campeao.model.MesaStatus;
import corinthians.campeao.repository.MesaRepository;
import org.springframework.stereotype.Service;

import java.util.NoSuchElementException;

@Service
public class MesaService{

    private MesaRepository mesaRepository;

    public MesaService(MesaRepository mesaRepository){
        this.mesaRepository = mesaRepository;
    }

    public MesaResponseDTO criarMesa(MesaRequestDTO mesaRequestDTO){
        Mesa mesa = MesaMapper.toEntity(mesaRequestDTO);
        mesa = mesaRepository.save(mesa);
        return MesaMapper.toDTO(mesa);
    }

    public void excluirMesa(MesaRequestDTO mesaRequestDTO){
        mesaRepository.delete(MesaMapper.toEntity(mesaRequestDTO));
    }

    public MesaResponseDTO atualizarMesa(MesaRequestDTO mesaRequestDTO, Integer id, String localizacao, Short capacidade){
        Mesa mesa = MesaMapper.toEntity(mesaRequestDTO);
        mesaRepository.delete(mesa);
        mesa.setId(id);
        mesa.setCapacidade(capacidade);
        mesa.setLocalizacao(localizacao);
        mesaRepository.save(mesa);
        return MesaMapper.toDTO(mesa);
    }

    public Mesa pesquisarMesa(Integer numero){
        Mesa mesa = mesaRepository.findById(numero)
                .orElseThrow(() -> new NoSuchElementException("\nERRO - Mesa não encontrada!!\nVerifique o numero" + numero + " digitado!!!\n"));
        return mesa;
    }

    public void usarMesa(Integer numero){
        Mesa mesa = pesquisarMesa(numero);
        mesa.setStatus(MesaStatus.LOTADA);
    }

    public void sairMesa(Integer numero){
        Mesa mesa = pesquisarMesa(numero);
        mesa.setStatus(MesaStatus.LIVRE);
    }

    public void desabilitarMesa(Integer numero){
        Mesa mesa = pesquisarMesa(numero);
        mesa.setStatus(MesaStatus.MANUTENCAO);
    }

}
