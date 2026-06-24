# Backend - Spring Boot

## Visão Geral

Este projeto segue uma **Arquitetura em Camadas (Layered Architecture)**, promovendo separação de responsabilidades, organização do código, facilidade de manutenção e escalabilidade.

Estrutura principal:

```text
src/main/java
│
├── config
│   └── security
│
├── controller
├── dto
├── exception
├── mapper
├── model
├── repository
└── service
```

---

# Fluxo da Aplicação

```text
Cliente (Frontend)
        │
        ▼
Controller
        │
        ▼
Service
        │
        ▼
Repository
        │
        ▼
Banco de Dados
```

As requisições percorrem esse fluxo até o banco de dados, retornando posteriormente ao cliente.

---

# Estrutura das Camadas

## config.security

Responsável pelas configurações de segurança da aplicação.

### Responsabilidades

- Configuração do Spring Security
- Autenticação de usuários
- Autorização baseada em Roles
- Configuração de JWT
- Criptografia de senhas
- Definição de rotas públicas e privadas
- Filtros de autenticação

### Exemplos

```java
SecurityConfig
JwtAuthenticationFilter
JwtService
PasswordEncoder
AuthenticationManager
```

---

## controller

Responsável por expor os endpoints da API REST.

### Responsabilidades

- Receber requisições HTTP
- Validar dados de entrada
- Delegar processamento para a camada Service
- Retornar respostas HTTP apropriadas

### Exemplo

```java
@RestController
@RequestMapping("/clientes")
public class ClienteController {

    private final ClienteService service;

    @GetMapping("/{id}")
    public ResponseEntity<ClienteResponseDTO> buscar(
            @PathVariable Long id) {

        return ResponseEntity.ok(service.buscarPorId(id));
    }
}
```

---

## dto

DTO (Data Transfer Object) é utilizado para transportar dados entre cliente e servidor.

### Benefícios

- Evita exposição direta das entidades
- Aumenta a segurança da API
- Facilita validações
- Permite controle total dos dados enviados e recebidos

### Exemplos

```java
ClienteRequestDTO
ClienteResponseDTO
LoginRequestDTO
FuncionarioRequestDTO
PedidoResumoDTO
```

---

## exception

Camada responsável pelo tratamento centralizado de exceções.

### Responsabilidades

- Criar exceções customizadas
- Padronizar respostas de erro
- Melhorar legibilidade e manutenção

### Exemplos

```java
ResourceNotFoundException
BusinessRuleException
UnauthorizedException
```

### Handler Global

```java
@RestControllerAdvice
public class GlobalExceptionHandler {
}
```

---

## mapper

Responsável pela conversão entre objetos.

### Conversões comuns

```text
DTO ↔ Entity
Entity ↔ DTO
```

### Benefícios

- Reduz duplicação de código
- Mantém Controllers e Services limpos
- Centraliza transformações de dados

### Exemplo

```java
Cliente cliente = mapper.toEntity(dto);

ClienteResponseDTO response =
        mapper.toResponseDTO(cliente);
```

---

## model

Representa as entidades do domínio da aplicação.

Normalmente cada entidade corresponde a uma tabela do banco de dados.

### Exemplo

```java
@Entity
@Table(name = "clientes")
public class Cliente {

    @Id
    private Long id;

    private String nome;
}
```

### Relacionamentos

```java
@OneToMany
@ManyToOne
@ManyToMany
@OneToOne
```

---

## repository

Camada de acesso aos dados utilizando Spring Data JPA.

### Responsabilidades

- Consultas
- Inserções
- Atualizações
- Remoções

### Exemplo

```java
public interface ClienteRepository
        extends JpaRepository<Cliente, Long> {

    Optional<Cliente> findByEmail(String email);

}
```

O Spring Data JPA gera automaticamente as implementações dos métodos.

---

## service

Responsável pelas regras de negócio da aplicação.

### Responsabilidades

- Aplicar regras de negócio
- Validar operações
- Orquestrar chamadas aos repositórios
- Integrar sistemas externos
- Garantir consistência dos dados

### Exemplo

```java
@Service
public class ClienteService {

    private final ClienteRepository repository;

    public ClienteResponseDTO buscarPorId(Long id) {

        Cliente cliente = repository.findById(id)
            .orElseThrow(() ->
                new ResourceNotFoundException("Cliente não encontrado"));

        return mapper.toResponseDTO(cliente);
    }
}
```

---

# Padrão REST

A API segue os princípios REST (Representational State Transfer).

Cada recurso possui uma URL específica e utiliza verbos HTTP para representar operações.

---

## GET

Busca informações.

```http
GET /clientes
GET /clientes/1
```

### Resposta

```json
{
  "id": 1,
  "nome": "João"
}
```

---

## POST

Cria um novo recurso.

```http
POST /clientes
```

### Body

```json
{
  "nome": "João",
  "email": "joao@email.com"
}
```

### Retorno

```http
201 Created
```

---

## PUT

Atualiza completamente um recurso.

```http
PUT /clientes/1
```

---

## PATCH

Atualiza parcialmente um recurso.

```http
PATCH /clientes/1
```

---

## DELETE

Remove um recurso.

```http
DELETE /clientes/1
```

### Retorno

```http
204 No Content
```

---

# Códigos HTTP Utilizados

| Código | Significado |
|----------|------------|
| 200 | OK |
| 201 | Created |
| 204 | No Content |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 409 | Conflict |
| 500 | Internal Server Error |

---

# Boas Práticas Aplicadas

- Separação de responsabilidades
- Utilização de DTOs para comunicação externa
- Regras de negócio isoladas na camada Service
- Tratamento centralizado de exceções
- Uso de Spring Security para autenticação e autorização
- Persistência utilizando Spring Data JPA
- API seguindo padrões REST
- Código desacoplado e de fácil manutenção

---

# Resumo da Arquitetura

```text
Controller
    ↓
Service
    ↓
Repository
    ↓
Banco de Dados
```

Camadas de apoio:

```text
Security
DTO
Mapper
Exception
Model
```

Essa arquitetura permite o desenvolvimento de APIs REST seguras, escaláveis, organizadas e alinhadas às boas práticas recomendadas pelo ecossistema Spring Boot.