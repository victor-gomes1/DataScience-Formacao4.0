USE petshop;

-- Relatório 1: Lista dos empregados admitidos entre 2023-01-01 e 2024-03-31
SELECT
    E.nome AS "Nome Empregado",
    E.cpf AS "CPF Empregado",
    E.dataAdm AS "Data Admissão",
    E.salario AS "Salário",
    D.nome AS "Departamento",
    T.numero AS "Número de Telefone"
FROM
    Empregado E
JOIN
    Departamento D ON E.Departamento_idDepartamento = D.idDepartamento
LEFT JOIN
    Telefone T ON E.cpf = T.Empregado_cpf
WHERE
    E.dataAdm BETWEEN '2023-01-01' AND '2024-03-31'
ORDER BY
    E.dataAdm DESC;

-- Relatório 2: Lista dos empregados que ganham menos que a média salarial
SELECT
    E.nome AS "Nome Empregado",
    E.cpf AS "CPF Empregado",
    E.dataAdm AS "Data Admissão",
    E.salario AS "Salário",
    D.nome AS "Departamento",
    T.numero AS "Número de Telefone"
FROM
    Empregado E
JOIN
    Departamento D ON E.Departamento_idDepartamento = D.idDepartamento
LEFT JOIN
    Telefone T ON E.cpf = T.Empregado_cpf
WHERE
    E.salario < (SELECT AVG(salario) FROM Empregado)
ORDER BY
    E.nome ASC;

-- Relatório 3: Lista dos departamentos com a quantidade de empregados, média salarial e média de comissão
SELECT
    D.nome AS "Departamento",
    COUNT(E.cpf) AS "Quantidade de Empregados",
    AVG(E.salario) AS "Média Salarial",
    AVG(E.comissao) AS "Média da Comissão"
FROM
    Departamento D
JOIN
    Empregado E ON D.idDepartamento = E.Departamento_idDepartamento
GROUP BY
    D.nome
ORDER BY
    D.nome;

-- Relatório 4: Lista dos empregados com a quantidade total de vendas, valor total e comissão
SELECT
    E.nome AS "Nome Empregado",
    E.cpf AS "CPF Empregado",
    E.sexo AS "Sexo",
    E.salario AS "Salário",
    COUNT(V.idVenda) AS "Quantidade Vendas",
    SUM(V.valor) AS "Total Valor Vendido",
    SUM(V.comissao) AS "Total Comissão das Vendas"
FROM
    Empregado E
LEFT JOIN
    Venda V ON E.cpf = V.Empregado_cpf
GROUP BY
    E.nome, E.cpf, E.sexo, E.salario
ORDER BY
    "Quantidade Vendas" DESC;

-- Relatório 5: Lista dos empregados que prestaram serviço na venda
SELECT
    E.nome AS "Nome Empregado",
    E.cpf AS "CPF Empregado",
    E.sexo AS "Sexo",
    E.salario AS "Salário",
    COUNT(DISTINCT IServ.Venda_idVenda) AS "Quantidade Vendas com Serviço",
    SUM(IServ.valor) AS "Total Valor Vendido com Serviço",
    SUM(V.comissao) AS "Total Comissão das Vendas com Serviço"
FROM
    Empregado E
LEFT JOIN
    Venda V ON E.cpf = V.Empregado_cpf
LEFT JOIN
    itensServico IServ ON V.idVenda = IServ.Venda_idVenda
GROUP BY
    E.nome, E.cpf, E.sexo, E.salario
ORDER BY
    "Quantidade Vendas com Serviço" DESC;

-- Relatório 6: Lista dos serviços já realizados por um Pet
SELECT
    P.nome AS "Nome do Pet",
    V.data AS "Data do Serviço",
    S.nome AS "Nome do Serviço",
    IServ.quantidade AS "Quantidade",
    IServ.valor AS "Valor",
    E.nome AS "Empregado que realizou o Serviço"
FROM
    PET P
JOIN
    itensServico IServ ON P.idPET = IServ.PET_idPET
JOIN
    Servico S ON IServ.Servico_idServico = S.idServico
JOIN
    Venda V ON IServ.Venda_idVenda = V.idVenda
JOIN
    Empregado E ON IServ.Empregado_cpf = E.cpf
ORDER BY
    V.data DESC;

-- Relatório 7: Lista das vendas já realizadas para um Cliente
SELECT
    V.data AS "Data da Venda",
    V.valor AS "Valor",
    V.desconto AS "Desconto",
    (V.valor - V.desconto) AS "Valor Final",
    E.nome AS "Empregado que realizou a venda"
FROM
    Venda V
JOIN
    Empregado E ON V.Empregado_cpf = E.cpf
ORDER BY
    V.data DESC;

-- Relatório 8: Lista dos 10 serviços mais vendidos
SELECT
    S.nome AS "Nome do Serviço",
    COUNT(IServ.Servico_idServico) AS "Quantidade Vendas",
    SUM(IServ.valor) AS "Total Valor Vendido"
FROM
    Servico S
JOIN
    itensServico IServ ON S.idServico = IServ.Servico_idServico
GROUP BY
    S.nome
ORDER BY
    "Quantidade Vendas" DESC
LIMIT 10;

-- Relatório 9: Lista das formas de pagamentos mais utilizadas nas Vendas
SELECT
    FPV.tipo AS "Tipo Forma Pagamento",
    COUNT(DISTINCT V.idVenda) AS "Quantidade Vendas",
    SUM(V.valor) AS "Total Valor Vendido"
FROM
    FormaPgVenda FPV
JOIN
    Venda V ON FPV.Venda_idVenda = V.idVenda
GROUP BY
    FPV.tipo
ORDER BY
    "Quantidade Vendas" DESC;

-- Relatório 10: Balanço das Vendas
SELECT
    DATE(V.data) AS "Data Venda",
    COUNT(V.idVenda) AS "Quantidade de Vendas",
    SUM(V.valor) AS "Valor Total Venda"
FROM
    Venda V
GROUP BY
    DATE(V.data)
ORDER BY
    "Data Venda" DESC;

-- Relatório 11: Lista dos Produtos, informando qual Fornecedor de cada produto
SELECT
    P.nome AS "Nome Produto",
    P.valorVenda AS "Valor Produto",
    'Não Implementado' AS "Categoria do Produto",  -- A coluna Categoria não existe na tabela Produtos
    F.nome AS "Nome Fornecedor",
    F.email AS "Email Fornecedor",
    T.numero AS "Telefone Fornecedor"
FROM
    Produtos P
JOIN
    ItensCompra IC ON P.idProduto = IC.Produtos_idProduto
JOIN
    Compras C ON IC.Compras_idCompra = C.idCompra
JOIN
    Fornecedor F ON C.Fornecedor_cpf_cnpj = F.cpf_cnpj
LEFT JOIN
    Telefone T ON F.cpf_cnpj = T.Fornecedor_cpf_cnpj
GROUP BY
    P.nome, P.valorVenda, F.nome, F.email, T.numero
ORDER BY
    P.nome;

-- Relatório 12: Lista dos Produtos mais vendidos
SELECT
    P.nome AS "Nome Produto",
    SUM(IVP.quantidade) AS "Quantidade (Total) Vendas",
    SUM(IVP.valor) AS "Valor Total Recebido pela Venda do Produto"
FROM
    Produtos P
JOIN
    ItensVendaProd IVP ON P.idProduto = IVP.Produto_idProduto
GROUP BY
    P.nome
ORDER BY
    "Quantidade (Total) Vendas" DESC;