-- 02_dados.sql : dados de teste (rodar depois do 01_criacao.sql)
USE loja_estacio;

INSERT INTO categorias (nome_categoria) VALUES
('Periféricos'), ('Monitores'), ('Escritório'), ('Áudio'), ('Acessórios');

INSERT INTO clientes (nome_cliente, email, endereco, sexo) VALUES
('João da Silva',    'joao.silva@exemplo.com',     'Rua Nova, 500',            'M'),
('Maria Oliveira',   'maria.oliveira@exemplo.com', 'Avenida Brasil, 456',      'F'),
('Carlos Souza',     'carlos.souza@exemplo.com',   'Rua X, 10',                'M'),
('Ana Paula Costa',  'ana.costa@exemplo.com',      'Rua Augusta, 789',         'F'),
('Lucas Mendes',     'lucas.mendes@exemplo.com',   'Av. Paulista, 1000',       'M'),
('Fernanda Lima',    'fernanda.lima@exemplo.com',  'Rua das Flores, 25',       'F'),
('Pedro Almeida',    'pedro.almeida@exemplo.com',  'Rua São João, 300',        'M'),
('Juliana Rocha',    'juliana.rocha@exemplo.com',  'Av. Getúlio Vargas, 88',   'F'),
('Rafael Costa',     'rafael.costa@exemplo.com',   'Rua Conceição, 150',       'M'),
('Camila Ferreira',  'camila.ferreira@exemplo.com','Travessa Açaí, 7',         'F'),
('Bruno Martins',    'bruno.martins@exemplo.com',  'Rua Ipiranga, 920',        'M'),
('Sem Pedidos',      'sem.pedidos@exemplo.com',    'Rua do Teste, 1',          'F'); -- caso-limite: cliente sem pedido

INSERT INTO telefones_cliente (cod_cliente, numero) VALUES
(1, '(21) 99999-1111'), (1, '(21) 98888-2222'),
(2, '(21) 97777-3333'),
(3, '(21) 96666-4444'),
(4, '(21) 95555-5555'), (4, '(21) 3333-6666'),
(5, '(21) 94444-7777'),
(6, '(21) 93333-8888'),
(7, '(21) 92222-9999'),
(9, '(21) 91111-0000');

INSERT INTO cartoes_fidelidade (cod_cliente, pontos) VALUES
(1, 150), (2, 80), (3, 0), (4, 220), (6, 40), (9, 10);

INSERT INTO fornecedores (nome_fornecedor, cnpj) VALUES
('TecnoDistribuidora Ltda',  '11222333000181'),
('Periféricos Brasil S.A.',  '22333444000172'),
('Móveis & Cia Escritório',  '33444555000163'),
('SomMax Áudio',             '44555666000154');

INSERT INTO produtos (nome_produto, cod_categoria, preco, estoque) VALUES
('Teclado Mecânico',         1,  270.00, 12),
('Mouse Sem Fio',            1,  120.00, 30),
('Monitor 24 Polegadas',     2,  890.00,  8),
('Cadeira Ergonômica',       3, 1150.00,  5),
('Headset Gamer',            4,  320.00, 20),
('Monitor 27 Polegadas',     2, 1390.00,  6),
('Mesa de Escritório',       3,  780.00,  4),
('Webcam Full HD',           1,  210.00, 15),
('Caixa de Som Bluetooth',   4,  180.00, 25),
('Hub USB 7 Portas',         5,   95.50, 40),
('Suporte para Notebook',    5,  135.90, 18),
('Microfone Condensador',    4,  450.00,  0); -- caso-limite: nunca vendido e estoque 0

INSERT INTO produto_fornecedor (cod_produto, cod_fornecedor, custo) VALUES
(1, 2, 180.00), (2, 2,  70.00), (3, 1, 650.00), (4, 3, 800.00),
(5, 4, 210.00), (6, 1, 1000.00), (7, 3, 520.00), (8, 2, 140.00),
(9, 4, 110.00), (10, 1, 55.00), (11, 3, 80.00), (12, 4, 300.00),
(1, 1, 190.00), (5, 2, 220.00);

INSERT INTO pedidos (data_pedido, status_entrega, cod_cliente) VALUES
('2026-10-02', 'Entregue', 1),   -- 1
('2026-10-05', 'Entregue', 2),   -- 2
('2026-10-08', 'Entregue', 3),   -- 3
('2026-10-10', 'Entregue', 4),   -- 4
('2026-10-12', 'Entregue', 5),   -- 5
('2026-10-15', 'Entregue', 6),   -- 6
('2026-10-18', 'Entregue', 7),   -- 7
('2026-10-20', 'Entregue', 8),   -- 8
('2026-10-22', 'Entregue', 9),   -- 9
('2026-10-25', 'Entregue', 10),  -- 10
('2026-10-27', 'Entregue', 11),  -- 11
('2026-10-29', 'Entregue', 1),   -- 12
('2026-11-01', 'Entregue', 2),   -- 13
('2026-11-03', 'Entregue', 3),   -- 14
('2026-11-05', 'Entregue', 4),   -- 15
('2026-11-06', 'Entregue', 5),   -- 16
('2026-11-08', 'Entregue', 6),   -- 17
('2026-11-10', 'Entregue', 1),   -- 18
('2026-11-11', 'Entregue', 7),   -- 19
('2026-11-12', 'Entregue', 2),   -- 20
('2026-11-14', 'Entregue', 8),   -- 21
('2026-11-15', 'Em rota',  3),   -- 22
('2026-11-16', 'Entregue', 9),   -- 23
('2026-11-18', 'Entregue', 1),   -- 24
('2026-11-19', 'Em rota',  10),  -- 25
('2026-11-20', 'Em rota',  4),   -- 26
('2026-11-21', 'Pendente', 5),   -- 27
('2026-11-22', 'Pendente', 11),  -- 28
('2026-11-23', 'Pendente', 6),   -- 29
('2026-11-24', 'Pendente', 7);   -- 30

INSERT INTO itens_pedido (cod_pedido, cod_produto, quantidade, valor_unitario) VALUES
(1, 1, 1,  270.00), (1, 2, 1, 120.00),
(2, 3, 1,  890.00),
(3, 4, 1, 1150.00),
(4, 5, 2,  320.00), (4, 10, 1, 95.50),
(5, 6, 1, 1390.00),
(6, 7, 1,  780.00), (6, 11, 1, 135.90),
(7, 8, 1,  210.00), (7, 9, 2, 180.00),
(8, 2, 3,  120.00),
(9, 1, 1,  270.00), (9, 5, 1, 320.00),
(10, 3, 1, 890.00), (10, 10, 2, 95.50),
(11, 9, 1, 180.00),
(12, 6, 1, 1390.00), (12, 2, 1, 120.00),
(13, 4, 1, 1150.00), (13, 11, 1, 135.90),
(14, 8, 1, 210.00),
(15, 1, 1, 270.00), (15, 2, 1, 120.00), (15, 10, 1, 95.50),
(16, 3, 1, 890.00),
(17, 5, 1, 320.00), (17, 9, 1, 180.00),
(18, 7, 1, 780.00),
(19, 2, 2, 120.00),
(20, 1, 1, 250.00),  -- preço praticado na época (menor que o atual): justifica valor_unitario
(21, 6, 1, 1390.00), (21, 8, 1, 210.00),
(22, 4, 1, 1150.00),
(23, 11, 2, 135.90), (23, 10, 1, 95.50),
(24, 5, 1, 320.00),
(25, 3, 1, 890.00), (25, 9, 1, 180.00),
(26, 7, 1, 780.00),
(27, 1, 1, 270.00), (27, 2, 1, 120.00),
(28, 8, 1, 210.00),
(29, 10, 3, 95.50),
(30, 6, 1, 1390.00);

INSERT INTO pagamentos (cod_pedido, forma_pagamento, valor, data_pagamento) VALUES
(1, 'Pix',    390.00,  '2026-10-02'),
(2, 'Cartão', 890.00,  '2026-10-05'),
(3, 'Boleto', 1150.00, '2026-10-09'),
(4, 'Pix',    735.50,  '2026-10-10'),
(5, 'Cartão', 1390.00, '2026-10-12'),
(6, 'Pix',    915.90,  '2026-10-15'),
(7, 'Cartão', 570.00,  '2026-10-18'),
(8, 'Boleto', 360.00,  '2026-10-21');

SELECT * FROM clientes;
SELECT * FROM produtos;
SELECT * FROM pedidos;
SELECT * FROM itens_pedido;