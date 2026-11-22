USE loja_estacio;

-- 1. Listar todos os clientes ordenados pelo nome
SELECT cod_cliente, nome_cliente, endereco, sexo
FROM clientes
ORDER BY nome_cliente;

-- 2. Listar produtos com preço acima de 200.00
SELECT cod_produto, nome_produto, categoria, preco, estoque
FROM produtos
WHERE preco > 200.00
ORDER BY preco DESC;

-- 3. Pedidos com nome do cliente e estado da entrega (JOIN)
SELECT 
    p.cod_pedido,
    p.data_pedido,
    p.status_entrega,
    c.nome_cliente
FROM pedidos p
INNER JOIN clientes c ON p.cod_cliente = c.cod_cliente
ORDER BY p.data_pedido;

-- 4. Detalhes dos itens de cada pedido (cliente, produto, quantidade e subtotal)
SELECT 
    p.cod_pedido,
    c.nome_cliente,
    pr.nome_produto,
    ip.quantidade,
    ip.valor_unitario,
    (ip.quantidade * ip.valor_unitario) AS subtotal
FROM itens_pedido ip
INNER JOIN pedidos p ON ip.cod_pedido = p.cod_pedido
INNER JOIN clientes c ON p.cod_cliente = c.cod_cliente
INNER JOIN produtos pr ON ip.cod_produto = pr.cod_produto
ORDER BY p.cod_pedido, ip.cod_item;

-- 5. Total por pedido (agregação com GROUP BY)
SELECT 
    p.cod_pedido,
    c.nome_cliente,
    SUM(ip.quantidade * ip.valor_unitario) AS total_pedido
FROM pedidos p
INNER JOIN clientes c ON p.cod_cliente = c.cod_cliente
INNER JOIN itens_pedido ip ON p.cod_pedido = ip.cod_pedido
GROUP BY p.cod_pedido, c.nome_cliente
ORDER BY p.cod_pedido;