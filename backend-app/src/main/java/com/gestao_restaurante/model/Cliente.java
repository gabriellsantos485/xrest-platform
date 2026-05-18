package com.gestao_restaurante.model;

import com.gestao_restaurante.config.security.UsuarioSistema;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;

@Entity
@Table(name = "cliente", schema = "x_rest")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Cliente implements UsuarioSistema {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cli_id")
    private Integer id;

    @Column(name = "cli_nome", nullable = false, length = 60)
    @NotBlank
    @Size(max = 60)
    private String nome;

    @Column(name = "cli_sobrenome",nullable = false, length = 60)
    @NotBlank
    @Size(max = 60)
    private String sobrenome;

    @Column(name = "cli_cpf", length = 14, unique = true)
    @NotBlank
    @Size(max = 14, min = 11)
    private String cpf;

    @Column(name = "cli_email", nullable = false, unique = true, length = 80)
    @NotBlank
    @Size(max = 80)
    @Email
    private String email;

    @Column(name = "cli_telefone", nullable = false, unique = true, length = 13)
    @NotBlank
    @Size(max = 15)
    private String telefone;

    @Column(name = "cli_numero", nullable = false)
    @NotNull
    private Integer numeroCasa;

    @Column(name = "cli_rua", nullable = false, length = 40)
    @NotBlank
    @Size(max = 40)
    private String rua;

    @Column(name = "cli_bairro", nullable = false, length = 100)
    @NotBlank
    @Size(max = 100)
    private String bairro;

    @Column(name = "cli_cidade", nullable = false, length = 60)
    @NotBlank
    @Size(max = 60)
    private String cidade;

    @Column(name = "cli_password", nullable = true, length = 255)
    @Size(max = 255)
    private String password;

    @Override
    public String getEmail() {
        return email;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(
                new SimpleGrantedAuthority("ROLE_CLIENTE")
        );
    }

}