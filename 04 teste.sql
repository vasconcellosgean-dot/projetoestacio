-- 04_testes.sql : testes de integridade (cada comando DEVE falhar)
-- Rode um comando por vez e anote o erro obtido. Mensagens variam conforme a versão do MySQL.
-- CHECK só é aplicado no MySQL 8.0.16 ou superior.
USE loja_estacio;

-- ===== INTEGRIDADE DE ENTIDADE =====

-- Teste 01: PK duplicada
INSERT INTO clientes (cod_cliente, nome_cliente, email, endereco, sexo)
VALUES (1, 'Teste', 'teste@exemplo.com', 'Rua Teste, 1', 'M');
-- Esperado: ERROR 1062: Duplicate entry '1' for key 'clientes.PRIMARY'
-- Obtido: ERROR 1062: Duplicate entry '1' for key 'clientes.PRIMARY'

-- Teste 02: UNIQUE repetido (e-mail)
INSERT INTO clientes (nome_cliente, email, endereco, sexo)
VALUES ('Outro João', 'joao.silva@exemplo.com', 'Rua Teste, 2', 'M');
-- Esperado: ERROR 1062: Duplicate entry 'joao.silva@exemplo.com' for key 'clientes.uq_clientes_email'
-- Obtido: ERROR 1062: Duplicate entry 'joao.silva@exemplo.com' for key 'clientes.uq_clientes_email'

-- Teste 03: PK composta duplicada (mesmo produto duas vezes no mesmo pedido)
INSERT INTO itens_pedido (cod_pedido, cod_produto, quantidade, valor_unitario)
VALUES (1, 1, 1, 270.00);
-- Esperado: ERROR 1062: Duplicate entry '1-1' for key 'itens_pedido.PRIMARY'
-- Obtido: ERROR 1062: Duplicate entry '1-1' for key 'itens_pedido.PRIMARY'

-- Teste 04: 1:1 violado (segundo cartão para o mesmo cliente)
INSERT INTO cartoes_fidelidade (cod_cliente, pontos) VALUES (1, 5);
-- Esperado: ERROR 1062: Duplicate entry '1' for key 'cartoes_fidelidade.uq_cartoes_cliente'
-- Obtido: ERROR 1062: Duplicate entry '1' for key 'cartoes_fidelidade.uq_cartoes_cliente'

-- ===== INTEGRIDADE REFERENCIAL =====

-- Teste 05: FK para cliente inexistente
INSERT INTO pedidos (data_pedido, status_entrega, cod_cliente)
VALUES ('2026-11-25', 'Pendente', 999);
-- Esperado: ERROR 1452: Cannot add or update a child row: a foreign key constraint fails
-- Obtido: ERROR 1452: Cannot add or update a child row: a foreign key constraint fails

-- Teste 06: apagar pai que possui filhos (RESTRICT)
DELETE FROM clientes WHERE cod_cliente = 1;
-- Esperado: ERROR 1451: Cannot delete or update a parent row: a foreign key constraint fails
-- Obtido: ERROR 1451: Cannot delete or update a parent row: a foreign key constraint fails

-- Teste 07: apagar produto que já foi vendido
DELETE FROM produtos WHERE cod_produto = 1;
-- Esperado: ERROR 1451: Cannot delete or update a parent row: a foreign key constraint fails
-- Obtido: ERROR 1451: Cannot delete or update a parent row: a foreign key constraint fails (fk_itens_produtos)

-- ===== INTEGRIDADE DE DOMÍNIO =====

-- Teste 08: NOT NULL
INSERT INTO clientes (nome_cliente, email, endereco, sexo)
VALUES (NULL, 'x@exemplo.com', 'Rua Teste, 3', 'M');
-- Esperado: ERROR 1048: Column 'nome_cliente' cannot be null
-- Obtido: ERROR 1048: Column 'nome_cliente' cannot be null

-- Teste 09: CHECK do preço (negativo)
INSERT INTO produtos (nome_produto, cod_categoria, preco, estoque)
VALUES ('Produto Inválido', 1, -10.00, 5);
-- Esperado: ERROR 3819: Check constraint 'chk_produtos_preco' is violated.
-- Obtido: (executar o Teste 09 e preencher: esperado ERROR 3819)

-- Teste 10: CHECK da quantidade (zero)
INSERT INTO itens_pedido (cod_pedido, cod_produto, quantidade, valor_unitario)
VALUES (2, 1, 0, 270.00);
-- Esperado: ERROR 3819: Check constraint 'chk_itens_quantidade' is violated.
-- Obtido: ERROR 3819: Check constraint 'chk_itens_quantidade' is violated.

-- Teste 11: CHECK do status de entrega
UPDATE pedidos SET status_entrega = 'Cancelado' WHERE cod_pedido = 1;
-- Esperado: ERROR 3819: Check constraint 'chk_pedidos_status' is violated.
-- Obtido: ERROR (comando rejeitado pelo CHECK chk_pedidos_status; esperado 3819)

-- Teste 12: CHECK do sexo
INSERT INTO clientes (nome_cliente, email, endereco, sexo)
VALUES ('Sexo Inválido', 'invalido@exemplo.com', 'Rua Teste, 4', 'X');
-- Esperado: ERROR 3819: Check constraint 'chk_clientes_sexo' is violated.
-- Obtido: ERROR 3819: Check constraint 'chk_clientes_sexo' is violated.

-- Teste 13: CHECK da forma de pagamento
INSERT INTO pagamentos (cod_pedido, forma_pagamento, valor, data_pagamento)
VALUES (1, 'Dinheiro', 50.00, '2026-11-25');
-- Esperado: ERROR 3819: Check constraint 'chk_pagamentos_forma' is violated.
-- Obtido: ERROR 3819: Check constraint 'chk_pagamentos_forma' is violated.