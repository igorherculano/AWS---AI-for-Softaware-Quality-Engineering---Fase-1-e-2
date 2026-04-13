2. Abordagem de Teste

A abordagem de teste será automatizada, desenvolvida com o Robot Framework em conjunto com a RequestsLibrary. A arquitetura do projeto aplica fortemente o Princípio DRY (Don't Repeat Yourself), mantendo uma separação clara entre os arquivos de Teste e os arquivos de base (Resources).

3.1. Justificativa da Automação (Pirâmide de Testes)

Seguindo os princípios da Pirâmide de Testes, a automação na camada de API (Serviços) foi escolhida como foco principal por oferecer o melhor balanço entre velocidade de execução, confiabilidade e custo de manutenção. Testes de Interface (UI) estão fora do escopo desta fase.

3.2. Estratégia por Módulo

Módulo /login: Foco na validação de autenticação, geração correta do token JWT, resposta a credenciais inválidas e expiração do token.

Módulo /usuarios: Cobertura do fluxo CRUD (Create, Read, Update, Delete) completo, com atenção especial às validações de obrigatoriedade de campos e garantia de unicidade de e-mail (bloqueio de duplicidade).

Módulo /produtos: Validação do CRUD, verificações de regras de negócio (como preço e estoque) e tratamento de exclusão de produtos que já estejam vinculados a um carrinho.

Módulo /carrinhos: Validação das regras de negócio complexas, incluindo criação, conclusão de compra, exclusão e a regra estrita de "1 carrinho ativo por usuário".

3.3. Categorias e Tipos de Teste

Os cenários mapeados englobam as seguintes categorias:

Happy Path (Caminho Feliz): Validação dos fluxos de sucesso onde todos os dados enviados são válidos e a API retorna os Status Codes 200/201.

Negative Testing (Testes Negativos): Validação do comportamento da API diante de dados inválidos, formatos incorretos ou ausência de campos obrigatórios (Status Codes 400).

Boundary Testing (Testes de Limite): Verificação do comportamento da aplicação nos limites das regras de negócio (ex: cadastrar carrinho com quantidade maior que o estoque).

Security Testing (Segurança): Validação do acesso a rotas protegidas tentando acessá-las sem token, com token expirado ou inválido (Status Codes 401/403).

Contract Testing (Testes de Contrato): Validação da estrutura do JSON de resposta e tipagem de dados comparando o retorno real com a documentação oficial (Swagger).

gurança Básica: Validação de acesso a rotas protegidas sem token ou com token inválido.


4. Critérios de entrada

Esta seção define as condições necessárias para iniciar o ciclo de testes (Definition of Ready), as metas para considerá-lo concluído (Definition of Done) e as regras para interrupção imediata.

4.1. Critérios de entrada

Os testes automatizados só poderão ser iniciados ou integrados à pipeline se os seguintes itens estiverem confirmados:

A documentação (Swagger) da API ServeRest deve estar acessível, atualizada e mapeada.

O ambiente de teste (compassuol.serverest.dev) deve estar online e respondendo a um Health Check básico.

Todas as dependências do projeto (requirements.txt) devem estar corretamente instaladas na máquina de execução ou no agente de CI/CD.

[As credenciais e variáveis de ambiente necessárias devem estar devidamente configuradas.

4.2. Critérios de saída

O ciclo de validação será considerado um sucesso e finalizado quando atingir as seguintes métricas:

100% dos Casos de Teste planejados (Seção 6) foram executados.

Taxa mínima de aprovação de 95% nos cenários gerais.

Taxa de 100% de aprovação nos testes de Happy Path e Sad Path (Caminhos Críticos).

Zero (0) bugs de severidade "Crítica" ou "Alta" (Bloqueantes) abertos.

Todos os defeitos encontrados reportados e devidamente tipificados no Jira (com evidências anexadas).

Relatórios finais do Robot Framework (report.html e log.html) gerados e anexados à entrega.

4.3. Critérios de suspensão

A execução dos testes (manual ou automatizada) deverá ser imediatamente pausada caso ocorra uma das situações abaixo:

O ambiente da API ficar indisponível (Erro 500 ou Timeout) contínuo por mais de 10 minutos.

Falha massiva: Mais de 30% dos testes falharem logo nas suítes iniciais, indicando que a versão entregue está instável demais para validação.

Nesses casos, um bug bloqueante geral deve ser aberto, e a execução só retorna após correção por parte da engenharia.