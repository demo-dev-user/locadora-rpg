# Locadora RPG

Sistema simples para uma locadora de filmes controlar **clientes**, **filmes** e **locações**, com a regra de negócio:

> Um filme alugado não pode ser alugado de novo até ser devolvido. O sistema recusa e avisa o funcionário com a mensagem: **"Filme já alugado. Devolva antes de alugar de novo."**

## Stack

- Ruby on Rails 7.1
- SQLite
- Sem login (roda local na loja)

## Como rodar com Docker (recomendado)

Pré-requisito: Docker + Docker Compose instalados.

```bash
docker compose up --build
```

Acesse: <http://localhost:3000>

O container já sobe o Rails e prepara o banco (cria/migra automaticamente). O banco SQLite fica em `./storage/` (volume bind) e persiste entre os `up`s.

Para parar: `Ctrl+C` (ou `docker compose down` em outro terminal).

### Rodar os testes dentro do container

```bash
docker compose run --rm web bundle exec rails test
```

## Como rodar sem Docker (local)

Pré-requisitos: Ruby 3.2.3, Bundler, SQLite3.

```bash
bundle install
bin/rails db:prepare
bin/rails server
```

Acesse: <http://localhost:3000>

### Rodar os testes

```bash
bin/rails test
```

## Funcionalidades

- **Clientes**: cadastro (CRUD completo).
- **Filmes**: cadastro com status `available` (disponível) / `rented` (alugado).
- **Locação**: registra o aluguel de um filme para um cliente; só lista filmes disponíveis.
- **Devolução**: ação dedicada que libera o filme para um novo aluguel.

## Regra de negócio principal

Um filme alugado não pode ser alugado de novo até ser devolvido. Implementado como validação no model `Rental`:

```ruby
errors.add(:base, "Filme já alugado. Devolva antes de alugar de novo.")
```

## Fluxo de uso

1. Cadastrar cliente.
2. Cadastrar filme (começa como "Disponível").
3. Alugar o filme para um cliente (filme passa para "Alugada").
4. Tentar alugar o mesmo filme de novo → o sistema recusa com a mensagem acima.
5. Devolver o filme (filme volta para "Disponível").
6. Alugar de novo → agora passa.