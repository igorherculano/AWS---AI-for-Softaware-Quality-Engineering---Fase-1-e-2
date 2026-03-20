# Projeto: AWS AI for Software Quality Engineering  
### -> Fase 2, Sprint 2, Semana 4: CHALLENGE.

## Descrição

Este projeto contém a suíte de testes automatizados de API desenvolvida como parte do Challenge da Sprint 2 (Semana 4) do programa de bolsas AWS & AI for Software Quality Engineering. Os testes validam as regras de negócio e os contratos da API [ServeRestCompass](https://compassuol.serverest.dev), cobrindo os módulos de Login, Usuários, Produtos e Carrinhos, além de um fluxo completo de Happy Path.

## Estrutura

- [Introdução](#introdução)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Como usar](#como-usar)


## Introdução

O objetivo desta automação é garantir a qualidade e a confiabilidade da API ServeRest, aplicando boas práticas de Engenharia de Software como o **Princípio DRY (Don't Repeat Yourself)** e a separação de responsabilidades (Testes vs. Resources). O projeto foi desenhado para tratar tanto os caminhos de sucesso (Status 200/201) quanto as validações de exceção (Status 400, 401 e 403).

## Pré-requisitos

Antes de começar, você precisará ter as seguintes ferramentas instaladas na sua máquina:

__``OBRIGATÓRIO``__
* [Python](https://www.python.org/downloads/) (v3.8 ou superior)
* Gerenciador de pacotes `pip` (já vem com o Python; se possivel atualize o seu para a versão mais recente.)

__`OPCIONAL`__
* [Visual Studio Code (VS Code)](https://code.visualstudio.com/)
* [Extensão RobotCode](https://marketplace.visualstudio.com/items?itemName=d-biehl.robotcode/) (Apenas se quiser facilitar a realização dos testes separados por arquivo ou até mesmo por CT's)

## Instalação

Clone este repositório e instale as bibliotecas necessárias do Robot Framework rodando os seguintes comandos no seu terminal:

```bash
pip install robotframework
pip install robotframework-requests
```
[Para mais informação sobre RobotFramework](https://robotframework.org/)
## Como usar 
### __Opção 1: Execução Visual e Individual__
Recomendo a instalação da extensão RobotCode no VS Code.

Com ela instalada, botões de "Play" (▶️) aparecerão automaticamente ao lado de cada Caso de Teste e no topo de cada arquivo .robot. Isso permite que você rode:

    * Apenas um Caso de Teste isolado (ideal para debugar).
    * Um arquivo/suíte inteira por vez (ex: rodar apenas os testes de Carrinho).

### **Opção 2: Execução via CMD (Terminal)**

Para executar os testes diretamente pelo terminal, navegue até a pasta do projeto __TestingServerRest__ e execute o comando abaixo:

```cmd
robot ServerRest_testes_1HP.robot ServerRest_testes_CARRINHO.robot ServerRest_testes_LOGIN.robot ServerRest_testes_PRODUTOS.robot ServerRest_testes_USUARIOS.robot
```
Ou, para rodar todos os testes ao mesmo tempo:
```cmd
robot .
```
O caminho até a pasta de testes é:
```cmd
AWS---AI-for-Softaware-Quality-Engineering---Fase-1-e-2\Fase 2\Sprint 2\Semana 4\TestingServerRest