# receite.me

## Visão Geral do Projeto

O `receite.me` é uma aplicação backend desenvolvida em Java com Spring Boot, projetada para gerenciar receitas, ingredientes, e pastas de organização de receitas. Este projeto serve como um estudo de caso prático para a disciplina CK0224 - Padrões de Projeto de Software, da graduação em Ciência da Computação na Universidade Federal do Ceará (UFC), demonstrando a aplicação de diversos padrões de design em um contexto de desenvolvimento de software real.

## Funcionalidades Principais

-   **Autenticação e Autorização:** Sistema de login e registro de usuários com JWT (JSON Web Tokens).
-   **Gestão de Usuários:** Criação, leitura, atualização e exclusão de perfis de usuário.
-   **Gestão de Receitas:** Cadastro, busca, atualização e remoção de receitas, incluindo seus ingredientes e instruções.
-   **Gestão de Ingredientes:** Cadastro e gerenciamento de ingredientes.
-   **Gestão de Pastas:** Organização de receitas em pastas personalizadas pelos usuários.
-   **Envio de E-mails:** Funcionalidade para envio de e-mails para recuperação de senha.
-   **Tratamento de Erros:** Respostas padronizadas para erros da API.

## Tecnologias Utilizadas

-   **Java 17+:** Linguagem de programação.
-   **Spring Boot:** Framework para construção de aplicações Java robustas e escaláveis.
-   **Spring Security:** Para autenticação e autorização.
-   **JWT (JSON Web Tokens):** Para segurança baseada em tokens.
-   **Maven:** Ferramenta de automação de build e gerenciamento de dependências.
-   **Lombok:** Para reduzir código boilerplate (getters, setters, construtores, builders).
-   **Banco de Dados:** PostgreSQL

## Padrões de Projeto Aplicados

Este projeto foi estruturado com a aplicação consciente de diversos padrões de projeto, visando boas práticas de engenharia de software, modularidade e manutenibilidade. Abaixo, destacamos alguns dos padrões presentes:

-   **MVC (Model-View-Controller):** Embora seja uma API REST, a arquitetura segue a separação de responsabilidades do MVC, onde:
    -   **Model:** Representado pelas entidades (`Usuario`, `Receita`, `Ingrediente`, `Pasta`) e DTOs.
    -   **Controller:** Pacote `controller`, responsável por receber requisições HTTP e delegá-las.
    -   **Service:** Pacote `service`, contendo a lógica de negócio e orquestração.
-   **Repository Pattern:** Implementado através das interfaces no pacote `repository` (`UsuarioRepository`, `ReceitaRepository`, etc.), que estendem `JpaRepository`. Este padrão abstrai a camada de persistência de dados, permitindo que a lógica de negócio não se preocupe com os detalhes de como os dados são armazenados ou recuperados.
-   **Service Layer Pattern:** O pacote `service` encapsula a lógica de negócio da aplicação. Cada serviço (`UsuarioService`, `ReceitaService`, etc.) é responsável por operações específicas, promovendo a separação de preocupações e a reutilização de código.
-   **Data Transfer Object (DTO) Pattern:** O pacote `dto` contém classes como `UsuarioDto`, `ReceitaDto`, etc. DTOs são utilizados para transferir dados entre as camadas da aplicação desacoplando as entidades do banco de dados da representação da API.
-   **Mapper Pattern:** O pacote `mapper` (`UsuarioMapper`, `ReceitaMapper`, etc.) utiliza interfaces para definir a conversão entre entidades de domínio e DTOs. Isso centraliza a lógica de mapeamento e evita a duplicação de código.
-   **Factory Method Pattern:** A classe `ProblemFactory` é um exemplo de aplicação deste padrão. Ela é responsável por criar instâncias de `Problem` (provavelmente para padronizar respostas de erro da API), abstraindo a lógica de criação e permitindo flexibilidade na geração de diferentes tipos de problemas.
-   **Builder Pattern:** Utilizado implicitamente através da anotação `@Builder` do Lombok em várias classes (e.g., `AuthenticationRequest`, `AuthenticationResponse`, `Receita`, `Usuario`). Este padrão facilita a construção de objetos complexos passo a passo, tornando o código mais legível e menos propenso a erros.
-   **Singleton Pattern:** As classes de serviço, repositório e configuração do Spring são, por padrão, instanciadas como Singletons (beans gerenciados pelo contêiner Spring), garantindo que haja apenas uma instância delas na aplicação.
-   **Strategy Pattern:** Pode ser observado na configuração de segurança (`SecurityConfiguration`), onde diferentes estratégias de autenticação (e.g., baseada em JWT) podem ser plugadas e configuradas.

## Como Rodar o Projeto

Para configurar e executar o projeto `receite.me` localmente, siga os passos abaixo:

### Pré-requisitos

-   Java Development Kit (JDK) 17 ou superior.
-   Maven 3.6.0 ou superior.
-   Um ambiente de desenvolvimento integrado (IDE) como IntelliJ IDEA ou VS Code (opcional).

### Instalação e Execução

1.  **Clone o Repositório:**
    ```bash
    git clone https://github.com/havillonf/receite.me.git
    cd receite.me
    ```

2.  **Build do Projeto:**
    Navegue até o diretório raiz do projeto (`receite.me`) e execute o Maven para construir o projeto:
    ```bash
    mvn clean install
    ```

3.  **Executar a Aplicação:**
    Após o build bem-sucedido, você pode executar a aplicação Spring Boot:
    ```bash
    mvn spring-boot:run
    ```
    A aplicação estará disponível em `http://localhost:8080`.

## Estrutura do Projeto

```
receite.me/
├───pom.xml
├───src/
│   └───main/
│       ├───java/
│       │   └───receite/
│       │       └───me/
│       │           ├───ApplicationStart.java
│       │           ├───auth/               # Classes de autenticação e registro
│       │           ├───config/             # Configurações de segurança (JWT, Spring Security)
│       │           ├───controller/         # Endpoints da API REST
│       │           ├───dto/                # Objetos de Transferência de Dados (DTOs)
│       │           ├───factory/            # Fábricas (ProblemFactory)
│       │           ├───mapper/             # Mapeamento entre entidades e DTOs
│       │           ├───model/              # Entidades de domínio (Receita, Usuario, etc.)
│       │           ├───repository/         # Interfaces de acesso a dados (JPA Repositories)
│       │           └───service/            # Lógica de negócio da aplicação
│       └───resources/
│           └───application.yml             # Configurações da aplicação
└───target/                                 # Artefatos de build
```

## Endpoints da API

Abaixo estão os endpoints da API, extraídos diretamente dos controladores:

-   **Autenticação (`AuthenticationController`):**
    -   `POST /auth/create` - Registrar um novo usuário.
    -   `POST /auth/authenticate` - Autenticar um usuário existente.
    -   `POST /auth/passwordConfirmation` - Confirmar senha (uso interno/específico).

-   **Ingredientes (`IngredienteController`):**
    -   `GET /ingredientes` - Listar todos os ingredientes.
    -   `GET /ingredientes/{nome}` - Buscar ingrediente pelo nome.

-   **Pastas (`PastaController`):**
    -   `GET /pastas/list/{id}` - Listar pastas (o `{id}` no path não é utilizado no método).
    -   `GET /pastas/{idPasta}` - Obter detalhes de uma pasta específica pelo ID.
    -   `GET /pastas/list-usuario/{idUsuario}` - Listar todas as pastas de um usuário.
    -   `GET /pastas/favoritos/{idUsuario}` - Obter receitas favoritas de um usuário.
    -   `POST /pastas/{idReceita}/{idUsuario}` - Alternar receita como favorita/não favorita para um usuário.
    -   `POST /pastas/create/{idUsuario}` - Criar uma nova pasta para um usuário.
    -   `GET /pastas/{idPasta}/receitas` - Listar receitas dentro de uma pasta específica.
    -   `POST /pastas/add-receita/{idPasta}/{idReceita}` - Adicionar uma receita a uma pasta.

-   **Receitas (`ReceitaController`):**
    -   `GET /receitas` - Listar todas as receitas.
    -   `GET /receitas/findById/{id}` - Buscar receita pelo ID.
    -   `GET /receitas/{nome}` - Buscar receita pelo nome.
    -   `POST /receitas/filtro` - Filtrar receitas por uma lista de ingredientes.
    -   `GET /receitas/filtro/{categoria}` - Filtrar receitas por categoria.
    -   `GET /receitas/recomendacoes` - Obter recomendações de receitas.

-   **Usuários (`UsuarioController`):**
    -   `GET /usuarios/{id}` - Buscar usuário pelo ID.
    -   `GET /usuarios/findByEmail/{email}` - Buscar usuário pelo email.
    -   `POST /usuarios` - Criar um novo usuário.
    -   `PATCH /usuarios/update` - Atualizar informações de um usuário.
    -   `DELETE /usuarios/{id}` - Deletar um usuário pelo ID.
    -   `GET /usuarios/request_reset/{email}` - Solicitar redefinição de senha para um email.
    -   `POST /usuarios/reset` - Redefinir senha com código de verificação.
    -   `POST /usuarios/resetWithoutCode` - Redefinir senha sem código de verificação (uso interno/específico).
