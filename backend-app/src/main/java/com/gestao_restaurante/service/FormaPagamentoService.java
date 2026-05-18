package com.gestao_restaurante.service;

import com.gestao_restaurante.dto.FormaPagamentoRequestDTO;
import com.gestao_restaurante.dto.FormaPagamentoResponseDTO;
import com.gestao_restaurante.exception.ResourceNotFoundException;
import com.gestao_restaurante.mapper.FormaPagamentoMapper;
import com.gestao_restaurante.model.FormaPagamento;
import com.gestao_restaurante.repository.FormaPagamentoRepository;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FormaPagamentoService {

    private final FormaPagamentoRepository repository;

    @Transactional
    public FormaPagamentoResponseDTO cadastrarMetodo(FormaPagamentoRequestDTO requestDTO) {
        FormaPagamento entity = FormaPagamentoMapper.toEntity(requestDTO);
        FormaPagamento savedEntity = repository.save(entity);
        return FormaPagamentoMapper.toResponseDTO(savedEntity);
    }

    @Transactional(readOnly = true)
    public List<FormaPagamentoResponseDTO> listarTodos() {
        return repository.findAll().stream()
                .map(FormaPagamentoMapper::toResponseDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public FormaPagamentoResponseDTO atualizarMetodo(Integer id, FormaPagamentoRequestDTO requestDTO) {
        FormaPagamento entity = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Forma de pagamento não encontrada: " + id));

        FormaPagamentoMapper.updateEntity(requestDTO, entity);
        FormaPagamento savedEntity = repository.save(entity);

        return FormaPagamentoMapper.toResponseDTO(savedEntity);
    }

    @Transactional
    public void deletarMetodo(Integer id) {
        if (!repository.existsById(id)) {
            throw new ResourceNotFoundException("Forma de pagamento não encontrada: " + id);
        }
        repository.deleteById(id);
    }
}
