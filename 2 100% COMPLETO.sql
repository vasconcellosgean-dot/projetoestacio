USE loja_estacio;

INSERT INTO clientes (nome_cliente, endereco, sexo) VALUES
('João da Silva', 'Rua das Flores, 123', 'M'),
('Maria Oliveira', 'Avenida Brasil, 456', 'F'),
('Carlos Souza', 'Rua X, 10', 'M'),
('Ana Paula Costa', 'Rua Augusta, 789', 'F'),
('Lucas Mendes', 'Av. Paulista, 1000', 'M');

INSERT INTO produtos (nome_produto, categoria, preco, estoque) VALUES
('Teclado Mecânico', 'Periféricos', 250.00, 15),
('Mouse Sem Fio', 'Periféricos', 120.00, 30),
('Monitor 24 Polegadas', 'Monitores', 890.00, 8),
('Cadeira Ergonómica', 'Escritório', 1150.00, 5),
('Headset Gamer', 'Áudio', 320.00, 20);

INSERT INTO pedidos (data_pedido, status_entrega, cod_cliente) VALUES
('2026-11-10', 'Entregue', 1),
('2026-11-12', 'Pendente', 2),
('2026-11-15', 'Em rota', 3),
('2026-11-18', 'Entregue', 1);

INSERT INTO itens_pedido (cod_pedido, cod_produto, quantidade, valor_unitario) VALUES
(1, 1, 1, 250.00),
(1, 2, 1, 120.00),
(2, 3, 1, 890.00),
(3, 4, 1, 1150.00),
(4, 5, 2, 320.00);

SELECT * FROM clientes;
SELECT * FROM produtos;
SELECT * FROM pedidos;
SELECT * FROM itens_pedido;