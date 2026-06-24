package com.gestao_restaurante.service;

import com.gestao_restaurante.dto.MesaRequestDTO;
import com.gestao_restaurante.dto.MesaResponseDTO;
import com.gestao_restaurante.exception.BusinessRuleException;
import com.gestao_restaurante.exception.ResourceNotFoundException;
import com.gestao_restaurante.mapper.MesaMapper;
import com.gestao_restaurante.model.Mesa;
import com.gestao_restaurante.model.MesaStatus;
import com.gestao_restaurante.repository.MesaRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MesaService {

    private final MesaRepository mesaRepository;

    @Transactional
    public MesaResponseDTO cadastrarMesa(MesaRequestDTO requestDTO) {
        Mesa mesa = MesaMapper.toEntity(requestDTO);
        Mesa savedMesa = mesaRepository.save(mesa);
        return MesaMapper.toResponseDTO(savedMesa);
    }

    @Transactional
    public boolean desabilitarMesa(Integer mesaId) {
        Mesa mesa = mesaRepository.findById(mesaId)
                .orElseThrow(() -> new ResourceNotFoundException("Mesa não encontrada com o ID: " + mesaId));

        if (MesaStatus.OCUPADA == mesa.getStatus()) {
            throw new BusinessRuleException("Não é possível desabilitar uma mesa ocupada.");
        }
        mesa.setStatus(MesaStatus.DESABILITADA);
        mesaRepository.save(mesa);
        return true;
    }

    @Transactional
    public void trocarMesa(Integer mesaOrigemId, Integer mesaDestinoId) {
        Mesa mesaOrigem = mesaRepository.findById(mesaOrigemId)
                .orElseThrow(() -> new ResourceNotFoundException("Mesa de origem não encontrada."));

        Mesa mesaDestino = mesaRepository.findById(mesaDestinoId)
                .orElseThrow(() -> new ResourceNotFoundException("Mesa de destino não encontrada."));

        if (MesaStatus.LIVRE != (mesaDestino.getStatus())) {
            throw new BusinessRuleException("A mesa de destino não está disponível para transferência.");
        }

        mesaDestino.setStatus(MesaStatus.OCUPADA);
        mesaOrigem.setStatus(MesaStatus.EM_LIMPEZA);

        mesaRepository.save(mesaDestino);
        mesaRepository.save(mesaOrigem);
    }

    @Transactional(readOnly = true)
    public List<MesaResponseDTO> listarTodas() {
        return mesaRepository.findAll().stream()
                .map(MesaMapper::toResponseDTO)
                .collect(Collectors.toList());
    }
}
