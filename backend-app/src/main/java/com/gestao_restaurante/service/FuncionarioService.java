package com.gestao_restaurante.service;

import com.gestao_restaurante.dto.FuncionarioRequestDTO;
import com.gestao_restaurante.dto.FuncionarioResponseDTO;
import com.gestao_restaurante.mapper.ClienteMapper;
import com.gestao_restaurante.mapper.FuncionarioMapper;
import com.gestao_restaurante.model.Cliente;
import com.gestao_restaurante.model.Funcionario;
import com.gestao_restaurante.repository.FuncionarioRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.OffsetDateTime;
import java.util.List;

import static org.springframework.data.jpa.domain.AbstractPersistable_.id;

@Service
public class FuncionarioService {

    private final FuncionarioRepository funcionarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService = new JwtService();

    public FuncionarioService(FuncionarioRepository funcionarioRepository, PasswordEncoder passwordEncoder){
        this.funcionarioRepository = funcionarioRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public List<FuncionarioResponseDTO> listarFuncionarios(){
        return funcionarioRepository.findByStatusTrue()
                .stream()
                .map(FuncionarioMapper::toDTO)
                .toList();
    }

    public FuncionarioResponseDTO criarFuncionario(FuncionarioRequestDTO dto){
        Funcionario funcionario = FuncionarioMapper.toEntity(dto);
        String senhaCriptografada = passwordEncoder.encode(funcionario.getPassword());
        funcionario.setPassword(senhaCriptografada);
        funcionario.setCriadoEm(OffsetDateTime.now());
        funcionario = funcionarioRepository.save(funcionario);
        return FuncionarioMapper.toDTO(funcionario);
    }

    public FuncionarioResponseDTO atualizarFuncionario(FuncionarioRequestDTO dto, Integer id){
        Funcionario funcionario = funcionarioRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Funcionário não encontrado"));

        funcionario.setNome(dto.nome());
        funcionario.setSobrenome(dto.sobrenome());
        funcionario.setEmail(dto.email());
        funcionario.setTelefone(dto.telefone());
        funcionario.setCargo(dto.cargo());
        funcionario.setStatus(dto.status());
        funcionario.setUsername(dto.username());
        funcionarioRepository.save(funcionario);
        return FuncionarioMapper.toDTO(funcionario);
    }

    public boolean deletarFuncionario(Integer id) {
        Funcionario funcionario = funcionarioRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Funcionário não encontrado"));
        funcionario.setStatus(false);
        funcionarioRepository.save(funcionario);
        return true;
    }
}


