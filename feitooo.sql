USE loja_estacio;

-- Teste 01 (entidade): PK duplicada
INSERT INTO clientes (cod_cliente, nome_cliente, email, endereco, sexo)
VALUES (1, 'Teste', 'teste@exemplo.com', 'Rua Teste, 1', 'M');

-- Teste 02 (entidade): UNIQUE repetido (e-mail)
INSERT INTO clientes (nome_cliente, email, endereco, sexo)
VALUES ('Outro Joao', 'joao.silva@exemplo.com', 'Rua Teste, 2', 'M');

-- Teste 03 (entidade): PK composta duplicada
INSERT INTO itens_pedido (cod_pedido, cod_produto, quantidade, valor_unitario)
VALUES (1, 1, 1, 270.00);

-- Teste 04 (entidade): 1:1 violado, segundo cartão para o mesmo cliente
INSERT INTO cartoes_fidelidade (cod_cliente, pontos) VALUES (1, 5);

-- Teste 05 (referencial): FK para cliente inexistente
INSERT INTO pedidos (data_pedido, status_entrega, cod_cliente)
VALUES ('2026-11-25', 'Pendente', 999);

-- Teste 06 (referencial): apagar cliente que tem pedidos
DELETE FROM clientes WHERE cod_cliente = 1;

-- Teste 07 (referencial): apagar produto já vendido
DELETE FROM produtos WHERE cod_produto = 1;

-- Teste 08 (dominio): NOT NULL
INSERT INTO clientes (nome_cliente, email, endereco, sexo)
VALUES (NULL, 'x@exemplo.com', 'Rua Teste, 3', 'M');

-- Teste 09 (dominio): CHECK do preço negativo
INSERT INTO produtos (nome_produto, cod_categoria, preco, estoque)
VALUES ('Produto Invalido', 1, -10.00, 5);

-- Teste 10 (dominio): CHECK da quantidade zero
INSERT INTO itens_pedido (cod_pedido, cod_produto, quantidade, valor_unitario)
VALUES (2, 1, 0, 270.00);

-- Teste 11 (dominio): CHECK do status de entrega
UPDATE pedidos SET status_entrega = 'Cancelado' WHERE cod_pedido = 1;

-- Teste 12 (dominio): CHECK do sexo
INSERT INTO clientes (nome_cliente, email, endereco, sexo)
VALUES ('Sexo Invalido', 'invalido@exemplo.com', 'Rua Teste, 4', 'X');

-- Teste 13 (dominio): CHECK da forma de pagamento
INSERT INTO pagamentos (cod_pedido, forma_pagamento, valor, data_pagamento)
VALUES (1, 'Dinheiro', 50.00, '2026-11-25');