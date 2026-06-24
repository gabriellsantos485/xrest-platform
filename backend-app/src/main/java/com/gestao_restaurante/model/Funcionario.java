package com.gestao_restaurante.model;

import com.gestao_restaurante.config.security.UsuarioSistema;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import java.time.OffsetDateTime;
import java.util.Collection;
import java.util.List;

@Entity
@Table(name = "funcionario", schema = "x_rest")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Funcionario implements UsuarioSistema {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "fun_id")
    private Integer id;

    @Column(name = "fun_nome",length = 60,nullable = false)
    @NotBlank
    @Size(max = 60)
    private String nome;

    @Column(name = "fun_sobrenome", length = 60, nullable = false)
    @NotBlank
    @Size(max = 60)
    private String sobrenome;

    @Column(name = "fun_telefone", length = 15, nullable = false)
    @NotBlank
    @Size(max = 15)
    private String telefone;

    @Column(name = "fun_email", length = 120, nullable = false, unique = true)
    @NotBlank
    @Email
    @Size(max = 120)
    private String email;

    @Enumerated(EnumType.STRING)
    @Column(name = "fun_cargo", nullable = false)
    @NotNull
    private FuncionarioCargo cargo;

    @Column(name = "fun_status", nullable = false)
    @NotNull
    @Builder.Default
    private Boolean status = true;

    @Column(name = "fun_criado_em", nullable = false, updatable = false)
    @CreationTimestamp
    @NotNull
    private OffsetDateTime criadoEm;

    @Column(name = "fun_atualizado_em", columnDefinition = "TIMESTAMPTZ")
    @org.hibernate.annotations.UpdateTimestamp
    private OffsetDateTime atualizadoEm;

    @Column(name = "fun_username", nullable = false, unique = true, length = 18)
    @NotBlank
    @Size(max = 18)
    private String username;

    @Column(name = "fun_password", nullable = false, length = 255)
    @NotBlank
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
